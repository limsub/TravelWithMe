//
//  ModifyProfileViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/11/23.
//

import Foundation
import RxSwift
import RxCocoa

class ModifyProfileViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    // 이전 화면에서 값전달로 받아야 하는 프로필 데이터 -> 초기 뷰에 띄워준다
    var profileInfo: LookProfileResponse?
    
    // 화면에 보여주는 이미지 데이터 (url String 타입으로만 가지고 있기 때문에, Data 타입으로 가지고 있는 변수를 하나 생성한다
    var profileImageData: Data?
    
    
    struct Input {
//        let firstNickName: Observable<String?>
//        let firstBirthday: Observable<String?>
//        let firstGender: Observable<Int?>
        
        let nicknameText: PublishSubject<String>
        let birthdayText: PublishSubject<String>
        let genderSelectedIndex: PublishSubject<Int>
        let introduceText: ControlProperty<String>
        
        let modifyButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let validNicknameFormat: PublishSubject<ValidNickname>
        let validBirthdayFormat: PublishSubject<ValidBirthday>
//        
        let enabledModifyButton: Observable<Bool>
        let resultModifyButtonClicked: PublishSubject<AttemptModifyMyProfile>
    }
    
    
    func tranform(_ input: Input) -> Output {
        

        // 수정하러 들어왔기 때문에 기본적으로 맨 처음 값은 무조건 available, true이다
        // (textfield.rx.text는 포커스를 받았을 때만 이벤트를 방출하기 때문에 이렇게 하는걸로..)
        // -> textField.rx.observe(String.self, "text") 이용해야 한다..
        
        // 닉네임
        let validNicknameFormat = PublishSubject<ValidNickname>()
        input.nicknameText
            .map { text in
                if text.isEmpty {
                    return ValidNickname.nothing
                } else {
                    if text.count < 2 || text.count > 6 {
                        return ValidNickname.invalidLength
                    } else {
                        return ValidNickname.available
                    }
                }
            }
            .subscribe(with: self, onNext: { owner , value in
                print("-- validnickname \(value) ")
                validNicknameFormat.onNext(value)
            })
            .disposed(by: disposeBag)
        
        
        // 생년월일
        let validBirthdayFormat = PublishSubject<ValidBirthday>()
        input.birthdayText
            .map { text in
                if text.count == 0 {
                    return ValidBirthday.nothing
                } else {
                    if !self.checkBirthdayFormat(text) {
                        return ValidBirthday.invalidFormat
                    } else {
                        return ValidBirthday.available
                    }
                }
            }
            .subscribe(with: self) { owner , value in
                print("-- validbirthday \(value) ")
                validBirthdayFormat.onNext(value)
            }
            .disposed(by: disposeBag)
        
        
        // 성별
        let validGenderSelected = PublishSubject<Int>()
        input.genderSelectedIndex
            .subscribe(with: self) { owner , value in
                print("-- validgender \(value) ")
                validGenderSelected.onNext(value)
            }
            .disposed(by: disposeBag)
        
    
        // 소개
        let validIntroduceText = BehaviorSubject<Bool>(value: false)
        input.introduceText
            .subscribe(with: self) { owner , value in
                print("-- validintroduce \(value) ")
                validIntroduceText.onNext(!value.isEmpty)
            }
            .disposed(by: disposeBag)
        
     
        // 버튼 enabled
        let enabledModifyButton = Observable.combineLatest(validNicknameFormat, validBirthdayFormat, validGenderSelected, validIntroduceText) { v1, v2, v3,  v4 in
            
            print("-- enabledModifyButton")
            print(v1)
            print(v2)
            print(v3)
            print(v4)
            
            return v1 == ValidNickname.available &&
            v2 == ValidBirthday.available &&
            v3 != -1 &&
            v4 == true
        }
        
        
        // 요청할 정보
        let modifyMyProfileInfo = Observable.combineLatest(input.nicknameText, input.birthdayText, input.genderSelectedIndex, input.introduceText) { v1, v2, v3, v4 in
            
            let nickStruct = ProfileInfo(
                nick: v1,
                gender: v3,
                birthday: v2,
                introduce: v4
            )
            
            let nickString = encodingStructToString(sender: nickStruct)
            
            return nickString ?? ""
        }
        
        // 버튼 클릭
        let resultModifyButtonClicked = PublishSubject<AttemptModifyMyProfile>()
        input.modifyButtonClicked
            .withLatestFrom(modifyMyProfileInfo)
            .flatMap { value in
                
                // 뷰모델의 ProfileImageData가 nil이라면 이미지 수정을 하지 않았다. 이럴 때는 request의 profile을 nil로 해서 보내자 (수정하지 않겠다는 뜻)
                // -> profileImageData의 타입도 Data? 이고, ModifyMyProfileRequest의 파라미터 타입도 Data? 이기 때문에 그대로 넣어주면 알아서 걸러지겠다.
                
                return RouterAPIManager.shared.requestMultiPart(
                    type: LookProfileResponse.self,  // 응답 타입이 동일해서 같이 쓴다
                    error: ModifyMyProfileAPIError.self,
                    api: .modifyMyProfile(sender: ModifyMyProfileRequest(
                        nick: value, profile: self.profileImageData
                    )))
            }
            .map { response in
                switch response {
                case .success(let result):
                    print("프로필 수정 성공")
                    return AttemptModifyMyProfile.success(result: result)
                case .failure(let error):
                    print("프로필 수정 실퍠")
                    
                    if let commonError = error as? CommonAPIError {
                        print("  공통 에러 중 하나")
                        return AttemptModifyMyProfile.commonError(error: commonError)
                    }
                    
                    if let modifyMyProfileError = error as? ModifyMyProfileAPIError {
                        print("  프로필 수정 에러 중 하나")
                        return AttemptModifyMyProfile.modifyMyProfileError(error: modifyMyProfileError)
                    }
                    
                    if let expiredTokenError = error as? RefreshTokenAPIError {
                        print ("  토큰 만료 에러 중 하나")
                        print("  만약 에러 내용이 '리프레시 토큰 만료'이면 로그인 화면으로 돌아가야 합니다")
                        return AttemptModifyMyProfile.refreshTokenError(error: expiredTokenError)
                    }
                    
                    print("  알 수 없는 에러.. 뭔 에러일까..?")
                    return AttemptModifyMyProfile.commonError(error: .unknownError)
                }
                
            }
            .subscribe(with: self) { owner , value in
                resultModifyButtonClicked.onNext(value)
            }
            .disposed(by: disposeBag)
        
        
        return Output(
            validNicknameFormat: validNicknameFormat,
            validBirthdayFormat: validBirthdayFormat,
            enabledModifyButton: enabledModifyButton,
            resultModifyButtonClicked: resultModifyButtonClicked
        )
    }
    
    
    
    // (생년월일) YYYYMMDD 형식에 맞는지 확인
    func checkBirthdayFormat(_ b: String) -> Bool {
        if b.count != 8 { return false }
        
        guard let _ = Int(b) else { return false }
        
        guard let year = Int(b.prefix(4)),
              (1900...2023).contains(year) else { return false }
        
        guard let month = Int(b.dropFirst(4).prefix(2)),
              (1...12).contains(month) else { return false }
        
        guard let day = Int(b.dropFirst(6).prefix(2)),
              (1...31).contains(day) else { return false }
        
        return true
    }
}
