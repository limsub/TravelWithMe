<img src="https://github.com/limsub/TravelWithMe/assets/99518799/1b10a1fb-b6c1-4692-9d62-9c91c97d1427" align="center" width="100%">

## :airplane: Travel With Me
> 서비스 소개 : 같이 여행을 떠날 사람을 모집하고, 마음에 드는 여행을 신청하는 앱
<br> 개발 인원 : 1인
<br> 개발 기간 : 23.11.27 ~ 23.12.16


<br>

## 🥇 Awards
- 새싹 iOS 3기 **LSLP (Light Service Level Project) 경진대회 1위**


<br>

## 📚 Tech Blog
- [[MapKit] 장소 검색 및 애플 맵 annotation](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-17%EC%A3%BC%EC%B0%A8MapKit-%EC%8B%A4%EC%8B%9C%EA%B0%84-%EC%9E%A5%EC%86%8C-%EA%B2%80%EC%83%89-%EB%B0%8F-Apple-Map-%EC%9C%84%EC%B9%98-%ED%91%9C%EC%8B%9C)
- [[FSCalendar] Custom cell을 활용한 날짜 기간 선택 구현](https://velog.io/@s_sub/%EC%83%88%EC%8B%B9-iOS-17%EC%A3%BC%EC%B0%A8)


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
### 1. RxSwift + Input/Output patttern을 이용한 실시간 회원가입 유효성 검증

|![이메일](https://github.com/limsub/TravelWithMe/assets/99518799/dda886b6-56ab-4258-8d26-121c8b272e7d)|![비밀번호](https://github.com/limsub/TravelWithMe/assets/99518799/206ce7b4-554c-4a98-9beb-0cf53d946808)|![닉네임](https://github.com/limsub/TravelWithMe/assets/99518799/7baa768f-d3ca-4d8c-8275-c99125f71c65)|![생년월일](https://github.com/limsub/TravelWithMe/assets/99518799/f499209a-7258-48bb-9bde-6b7cd830bb7d)|
|:--:|:--:|:--:|:--:|
|이메일 계정|비밀번호|닉네임|생년월일|

- RxCocoa의 `textField.rx.text.orEmpty` 를 Input 으로 전달
- `transform` 메서드 내부에서 유효성 검사 후 Output 결과 전달
 
    <details>
    <summary><b>Input/Output pattern</b> </summary>
    <div markdown="1">

    ```swift
    // VM
    struct Input {
        let emailText: ControlProperty<String>

        /* ... */
    }

    struct Output {
        let validEmailFormat: PublishSubject<ValidEmail>

        /* ... */
    }

    func transform(_ input: Input) -> Output {
        /* ... */
    }
    ```

    </div>
    </details>

<br>

- `textField.rx.text` 는 텍스트의 변화(`.valueChanged`) 외에도 모든 액션(`.allEditingEvents`) 에 대해 이벤트를 방출하기 때문에 `distinctUntilChanged()` 를 통해 텍스트의 변화만 감지할 수 있도록 구현

    <details>
    <summary><b>distinctUntilChanged</b> </summary>
    <div markdown="1">

    ```swift
    input.emailText
	.distintUntilChanged()
	.subscribe {
		/* ... */
	}
	.disposed(by: disposeBag)
    ```

    </div>
    </details>

<br>

- enum을 이용해서 구체적인 상태에 대한 결과 전달

    <details>
    <summary><b>enum ValidEmail</b> </summary>
    <div markdown="1">

    ```swift
    enum ValidEmail: Int {
        case nothing
        case invalidFormat
        case validFormatBeforeCheck
        case alreadyInUse
        case available
        
        var description: String {
            switch self {
            case .nothing:
                return ""
            case .invalidFormat:
                return "이메일 형식에 맞지 않습니다"
            case .validFormatBeforeCheck:
                return "이메일 중복 확인을 해주세요"
            case .alreadyInUse:
                return "이미 사용중인 이메일입니다"
            case .available:
                return "사용 가능한 이메일입니다"
            }
        }
    }

    ```

    </div>
    </details>


<br>

### 2 - 1. Alamofire RequestInterceptor를 이용한 JWT 갱신
![‎인터셉터 ‎001](https://github.com/limsub/TravelWithMe/assets/99518799/d59c6524-09bc-4d68-8f4d-5a8982b53273)


- **APIRequestInterceptor** 를 구현하여 Keychain에 저장된 access token의 유효성을 검증하고 필요 시 토큰 갱신

    <details>
    <summary><b>APIRequestInterceptor</b> </summary>
    <div markdown="1">

    ```swift
    final class APIRequestInterceptor: RequestInterceptor {
    
        func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
            // 키체인에 있는 토큰을 header에 추가
            var urlRequest = urlRequest
            urlRequest.headers.add(name: "Authorization", value: KeychainStorage.shared.accessToken ?? "")
            completion(.success(urlRequest))
        }
        
        func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {

            // Token 만료 에러가 아닌 경우
            guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 419 else {
                completion(.doNotRetryWithError(error))
                return
            }
            
            // Token 만료 에러인 경우 (statusCode: 419)
            RouterAPIManager.shared.requestNormal(
                type: RefreshTokenResponse.self,
                error: RefreshTokenAPIError.self,
                api: .refreshToken) { response  in
                    switch response {
                    case .success(let result):
                        // 키체인에 new Token 저장
                        KeychainStorage.shared.accessToken = result.token

                        // retry
                        completion(.retry)

                    case .failure(let error)
                        /* ... 에러 분기 처리 생략 ... */

                        // doNotRetryWithError
                        completion(.doNotRetryWithError(error))
                    }
                }
        }
    }
    ```

    </div>
    </details>


<br>

### 2 - 2. Protocol, Generic을 이용한 API 에러 타입 및 request 메서드 추상화

- 프로젝트 내 API 에러 특징
  1. **Int 타입 RawValue** (statusCode)
  2. **protocol Error** 채택
  3. **String 타입 error description** (alert, log에서 활용)

<br>


- 위 내용을 프로토콜로 선언하고, 각 에러 타입(enum)이 채택

    <details>
    <summary><b>protocol APIError</b> </summary>
    <div markdown="1">

    ```swift
    // protocol
    protocol APIError: RawRepresentable, Error where RawValue == Int {
        var description: String { get }
    }

    /* === 공통 에러 === */
    enum CommonAPIError: Int, APIError {
        case invalidSeSACKey = 420
        case overInvocation = 429
        case invalidURL = 444
        case unknownError = 500

            var description: String {
                    /* ... */
            }
    }

    /* ===== 이메일 중복 확인 ===== */
    enum ValidEmailAPIError: Int, APIError {
        case missingValue = 400
        case invalidEmail = 409
        
        var description: String {
                    /* ... */
        }
    }

    ```

    </div>
    </details>

<br>


- 네트워크 요청 시 Generic을 이용해서 여러 응답 모델과 에러 타입에 대해 대응

    <details>
    <summary><b>network request</b> </summary>
    <div markdown="1">

    ```swift
    func request<T: Decodable, U: APIError>(
        responseType: T.Type, 
        errorType: U.Type, 
        api: Router, 
        completionHandler: @escaping (Result<T, Error>) -> Void
    ) {
        /* ... */
    }
    
    ```

    </div>
    </details>


<br>


### 3. Splash View에서 refresh token API 를 이용한 자동 로그인 구현
![‎자동 로그인 ‎001](https://github.com/limsub/TravelWithMe/assets/99518799/65fd706a-c7c3-4bc1-8972-1f87bae3c95a)


- 앱의 생명주기를 관리하는 `AppDelegate`와 화면의 상태를 관리하는 `SceneDelegate`에서 네트워크 통신을 수행하는 건 적절하지 않다
- Splash View를 Code-Based로 구현하여 네트워크 통신 수행

<br>

- Keychain에 저장된 refresh token으로 access token 갱신 네트워크 요청
    1. **성공** 또는 **access token이 만료되지 않은 경우 (419)**, 메인 화면 전환
    2. **419 외 에러인 경우** 유효하지 않은 토큰으로 간주, 로그인 화면 전환


<br>

### 4. UIBezierPath를 이용한 곡선 UI 구현 및 CAGradientLayer를 이용한 색상 그라데이션 효과 구현

|![다른 사람 프로필 - 만든 여행](https://github.com/limsub/TravelWithMe/assets/99518799/3301e20d-092d-49a1-9ba9-c30f2f2dc6bd)|![myprofile_joinedTour](https://github.com/limsub/TravelWithMe/assets/99518799/84c48070-3d4d-45da-b9ca-32c03589ebfd)|![내 프로필 - 정보](https://github.com/limsub/TravelWithMe/assets/99518799/b45edb4a-cf4a-438c-ae75-31a482b4f467)|![투어 상세페이지 - top](https://github.com/limsub/TravelWithMe/assets/99518799/23c6a40a-3aeb-4c20-92a4-8735fe3d85a8)|
|:--:|:--:|:--:|:--:|
|다른 유저 프로필 - 만든 여행|내 프로필 - 신청한 여행|내 프로필 - 정보|여행 상세페이지|


- 
	<details>
	<summary><b>UIBezierPath</b> </summary>
	<div markdown="1">
	
	```swift
	override func draw(_ rect: CGRect) {
 		super.draw(rect)
 
		let path = UIBezierPath()
		
		UIColor.white.setFill()
		path.lineWidth = 0
		
		path.move(to: CGPoint(x: leftX, y: bottomY))
		path.addLine(to: CGPoint(x: leftX, y: startY))
		path.addCurve(to: CGPoint(x: rightX, y: endY),
			    controlPoint1: CGPoint(x: firstX, y: firstY),
			    controlPoint2: CGPoint(x: secondX, y: secondY)
		)
		path.addLine(to: CGPoint(x: rightX, y: bottomY))
		
		path.stroke()
		path.fill()
	}
	```
	</div>
	</details>


- 
	<details>
	<summary><b>CAGradientLayer</b> </summary>
	<div markdown="1">
	
	```swift
	override func draw(_ rect: CGRect) {
		super.draw(rect)
	        
	        let gradientLayer = CAGradientLayer()
	        gradientLayer.frame = self.bounds
	        let colors: [CGColor] = [
	            UIColor.appColor(.main1).cgColor,
	            UIColor.appColor(.second1).cgColor
	        ]
	        gradientLayer.colors = colors
	
	        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
	        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
	        
	        self.layer.insertSublayer(gradientLayer, at: 0)
	}
	```
	</div>
	</details>



## 🔥트러블 슈팅
### 1. Image Loading
1. header가 필요한 이미지 로딩 - AlamofireImage 이용 + 캐싱을 위해 NSCache
2. ~~ 한 점에서 한계. 이를 보완할 수 있는 KingFisher 이용 - option에 헤더 추가
   	- `UIImageView`의 메서드로 구현
4. 하지만 KingFisher 역시 ~~ 한 점에서 한계. (회고?)

<br>
----
<br>
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


### 4. multiple image select 시 순서 보장 방법
- 기존 : 시작 시점과 마지막 시점만 파악함
- 그래서 순서가 뒤죽박죽으로 들어갔음
- 미리 배열 만들어서 인덱스로 접근할 수 있도록 수정



## 회고!
