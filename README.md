<img src="https://github.com/limsub/TravelWithMe/assets/99518799/1b10a1fb-b6c1-4692-9d62-9c91c97d1427" align="center" width="100%">

## :airplane: Travel With Me
> 서비스 소개 : 같이 여행을 떠날 사람을 모집하고, 마음에 드는 여행을 신청하는 앱
<br> 개발 인원 : 1인
<br> 개발 기간 : 23.11.27 ~ 23.12.16


<br>



## 💪 주요 기능
- 회원 인증 : 회원가입 / 로그인 / 회원 탈퇴 / 프로필 수정
- 게시글
  - 여행 게시글 작성 / 수정 / 삭제
  - 여행 게시글 조회 (카테고리별 조회)
  - 여행 신청 / 취소
  - 여행 후기 작성 / 수정 / 삭제
- 유저 팔로우 / 언팔로우


<br>


## 🛠 기술 스택
- UIKit, MVVM
- RxSwift - Input/Output pattern
- Alamofire - Router pattern
- SnapKit, Tabman, FSCalendar, MapKit, KingFisher


<br>


## 💻 구현 내용
### 1. RxSwift를 이용한 실시간 회원가입 유효성 검증
<img src="https://github.com/limsub/TravelWithMe/assets/99518799/52565fd5-13fb-4f52-b728-2e8b5c16de11" align="center" width="24%">

- VC에서 VM의 input으로 `textField.rx.text.orEmpty` 를 전달하고, 
- `transform` 메서드 내에서 해당 텍스트에 대한 유효성을 검증한 후,
- output으로 결과를 전달받아서 실시간으로 View를 업데이트한다.
```swift
// VC (func bind())
let input = viewModel.input(pwText: mainView.pwTextField.rx.text.orEmpty)
let output = viewModel.transform(input)
output.validPWFormat
    .subscribe(with: self) { owner, value in 
        owner.mainView.checkPWLabel.setUpText(value)
    }
    .disposed(by: disposeBag)


// VM (func transform())
let validPWFormat = PublishSubject<ValidPW>()
input.pwText
    .map { text in 
        // 1. text.isEmpty
        return ValidPW.nothing
        // 2. text.count < 8
        return ValidPW.tooShort
        // 3. no specialCharacter
        return ValidPW.missingSpecialCharacter
        // 4. available
        return ValidPW.available
    }
    .subscribe(with: self) { owner, value in 
        validPWFormat.onNext(value)
    }
    .disposed(by: disposeBag)

return Output(validPWFormat: validPWFormat)
```

<br>

### 2 - 1. Router pattern 구현 -> 보류


### 2 - 2. jwt 토큰 갱신을 위한 Interceptor 구현
- Keychain에 저장된 access token과 refresh token을 이용해서
<br> 매번 네트워크 통신 전 토큰의 유효성 검증을 진행하였다.

- `adapt` : 현재 Keychain에 저장된 token값을 헤더에 업데이트한다. 
  - (retry 함수로 인해 Keychain의 토큰 값이 변경된 경우를 대비하기 위함)

- `retry` : 네트워크 에러 발생 시 실행된다
  1. access token 만료 에러(statusCode: 419)가 아닌 경우, 해당 에러를 그대로 반환한다.
  2. access token 만료 에러인 경우, access token 갱신 네트워크 요청을 한다
  3. access token 갱신 성공이면, Keychain 헤더 업데이트 후 현재 네트워크 통신을 재요청한다.
  4. access token 갱신에 실패하면, 해당 에러를 그대로 반환한다.
```swift
// adapt
func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
    var urlRequest = urlRequest
    urlRequest.headers.add(name: "Authorization", value: KeychainStorage.shared.accessToken ?? "")
    completion(.success(urlRequest))
}

// retry
func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {

    guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
        // 1.
        completion(.doNotRetryWithError(error))
        return
    }
    
    // 2.
    RouterAPIManager.shared.requestNormalWithNoIntercept(
        type: RefreshTokenResponse.self,
        error: RefreshTokenAPIError.self,
        api: .refreshToken) { response  in
            switch response {
            case .success(let result):
                // 3.
                KeychainStorage.shared.accessToken = result.token
                completion(.retry)
                return
            case .failure(let error):
                // 4.
                // (에러 분기 처리 생략)
                completion(.doNotRetryWithError(error))
            }
        }
}
```

### 2 - 3. 네트워크 통신 에러 처리
- API 별로 Error를 enum으로 선언하였다.
- 모든 에러의 공통적인 내용을 `APIError` 라는 프로토콜을 선언하여 정의하였다.
- `protocol APIError` 를 선언하여 Router Manager에서 모든 에러를 제네릭 타입으로 받을 수 있게 하였다.
    ```swift
    protocol APIError: RawRepresentable, Error where RawValue == Int {
        var description: String { get }
    }

    /* ===== 회원가입 ===== */
    enum JoinAPIError: Int, APIError {
        case missingValue = 400
        case alreadyRegistered = 409
        
        var description: String {
            switch self {
            case .missingValue:
                return "필수값을 채워주세요"
            case .alreadyRegistered:
                return "이미 가입된 유저입니다"
            }
        }
    }
    ```
- 이를 통해 RouterManager의 메서드에서 제네릭 타입으로 에러를 받고, 이를 핸들링할 수 있도록 하였다
<br> 에러 별 rawValue를 statusCode로 분기 처리를 진행하였다
    ```swift
    func requestNormal<T: Decodable, U: APIError>(type: T.Type, error: U.Type, api: Router, completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        AF.request(api, interceptor: APIRequestInterceptor())
            .responseDecodable(of: T.self) { response in
                print(response)
                
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                    
                case .failure(let error):
                    let statusCode = response.response?.statusCode ?? 500

                    // 1. 공통 에러
                    if [420, 429, 444, 500].contains(statusCode) {
                        let returnError = CommonAPIError(rawValue: statusCode)!
                        completionHandler(.failure(returnError))
                    }
                    
                    // 2. 토큰 갱신 에러
                    else if case .requestRetryFailed(let retryError as RefreshTokenAPIError, _) = error {
                        completionHandler(.failure(retryError))
                    }

                    // 3. U 타입 에러
                    else if let returnError = U(rawValue: statusCode) {
                        completionHandler(.failure(returnError))
                    }

                    // 4. 알 수 없는 에러
                    else {
                        completionHandler(.failure(CommonError.unknownError))
                    }
                }
            }   
    }
    ```

<br>

### 3. 자동 로그인 구현
- 플로우 차트


<br>

### 4. UIBezierPath 활용 곡선 뷰 구현
- 코드 
- (추가 내용) hitTest 전달해서 스크롤 가능

<br>

## 🔥트러블 슈팅
### 1. Image Loading
- 기존에는 header가 필요 없이 url으로만 이미지 로딩 작업을 해왔기 때문에
<br> 서버에 저장되는 이미지, 즉 권한이 필요한 이미지를 불러오는 작업이 처음이었다.

1. insomnia를 이용해서 url과 header를 통해 이미지 파일 확인

2. Router에 이미지 다운로드하는 case 추가 및 프로퍼티 구현
<br> **AlamofireImage** 라이브러리 이용해서 이미지 파일 다운로드
<br> **NSCache** 를 통한 직접 메모리 캐싱 구현

3. **KingFisher**의 option 활용 이미지 로딩
<br> 내부적으로 downsampling이 가능하고 caching 처리가 가능하다는 장점

4. `UIImageView`의 메서드 구현해서 보다 간편하게 사용할 수 있도록 함

<br>

### 2. UIButton의 `isSelected` Control Property 직접 구현
- 카테고리 버튼의 선택 여부 (isSelected)를 input으로 전달하는 과정에서, 
<br> RxCocoa에 `button.rx.isSelected` 프로퍼티가 없다는 것을 알게 되었고, 이를 직접 구현하였다.
    ```swift
    extension Reactive where Base: UIButton {
        
        var isSelected: ControlProperty<Bool> {
            
            return base.rx.controlProperty(
                editingEvents: [.touchUpInside]) { button  in
                    button.isSelected
                } setter: { button , value  in
                    button.isSelected = value
                }
        }
    }
    ```

- 이슈 : 사용자가 버튼을 눌렀을 때는 정상적으로 이벤트를 방출하지만, 코드 내에서 직접 `button.isSelected` 값을 바꿔줄 때는 이벤트가 방출되지 않았다.
  - 해결 방법 1 : 코드로 값을 바꿔줄 때마다 해당 버튼에 `touchUpInside` 액션을 전달한다.
    ```swift
    button.isSelected.toggle()
    button.sendActions(for: .touchUpInside)
    ```
  - 해결 방법 2 : KVO 개념을 이용해서 사용자의 액션을 통한 이벤트와 코드를 통한 이벤트를 따로 처리한다.
    ```swift
    let buttonSelected1 = button.rx.isSelected
    let buttonSelected2 = button.rx.observe(Bool.self, "isSelected")
    ```
- `UIButton` 외에도 `UITextField` 등 객체에도 동일한 이슈가 발생하여, 위 방법으로 해결하였다.

<br>

### 3. Image Resizing
- 서버에 이미지 데이터를 올릴 때, 제한 용량이 존재했다. (ex. 프로필 이미지 제한 용량 1MB)
- 따라서 이미지를 올리기 전 용량을 줄이는 resizing 작업이 필요했다.
- `.jpegData` 메서드의 `compressionQuality` 를 줄여가며 리사이징 구현


- 한계 : 특정 값 이하에서는 용량이 줄지 않아서 무한 루프 발생
<Br>-> 다른 방법은?
