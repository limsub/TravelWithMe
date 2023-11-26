//
//  SignUpViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/21.
//

import Foundation
import RxCocoa
import RxSwift


class SignUpViewModel: ViewModelType {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let emailEditing: ControlEvent<Void>
        let emailText: ControlProperty<String>
        let emailCheckButtonClicked: ControlEvent<Void>
        let pwText: ControlProperty<String>
        let nicknameText: ControlProperty<String>
        let birthdayText: ControlProperty<String>
        let genderSelectedIndex: ControlProperty<Int>
        
        let signUpButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let validEmailFormat: PublishSubject<ValidEmail>
        let validPWFormat: PublishSubject<ValidPW>
        let validNicknameFormat: PublishSubject<ValidNickname>
        let validBirthdayFormat: PublishSubject<ValidBirthday>
        
        let enabledSignUpButton: Observable<Bool>
        let resultSignUpClicked: PublishSubject<AttemptSignUp>
    }
    
    func tranform(_ input: Input) -> Output {
        
        /* 1. 이메일 */
        // 이메일 형식에 맞는지 확인
        let validEmailFormat = PublishSubject<ValidEmail>()
        input.emailEditing
            .withLatestFrom(input.emailText)
            .map { text in
                if (text.isEmpty) {
                    return ValidEmail.nothing
                } else {
                    return self.checkValidFormatEmail(text) ? ValidEmail.validFormatBeforeCheck : ValidEmail.invalidFormat
                }
            }
            .subscribe(with: self) { owner , value in
                validEmailFormat.onNext(value)
            }
            .disposed(by: disposeBag)
        
        // 이메일 중복 체크
        input.emailCheckButtonClicked
            .withLatestFrom(input.emailText)
//            .flatMap { APIManager.shared.requestValidEmail(ValidEmailRequest(email: $0)) }
            .flatMap {
                RouterAPIManager.shared.request(
                    type: ValidEmailResponse.self,
                    error: ValidEmailAPIError.self,
                    api: .validEmail(sender: ValidEmailRequest(email: $0)))
            }
//            .debug()
            .map { response in
                switch response {
                case .success(_):
                    return ValidEmail.available
                case .failure(_):
                    return ValidEmail.alreadyInUse
                }
            }
            .subscribe(with: self) { owner , value in
                validEmailFormat.onNext(value)
            }
            .disposed(by: disposeBag)
 
        
        /* 2. 비밀번호 */
        let validPWFormat = PublishSubject<ValidPW>()
        input.pwText
            .map { text in
                if text.isEmpty {
                    return ValidPW.nothing
                } else {
                    if text.count < 8 {
                        return ValidPW.tooShort
                    } else {
                        if !self.checkSpecialCharacterPW(text) {
                            return ValidPW.missingSpecialCharacter
                        } else {
                            return ValidPW.available
                        }
                    }
                }
            }
            .subscribe(with: self) { owner , value in
                validPWFormat.onNext(value)
            }
            .disposed(by: disposeBag)
        
        /* 3. 닉네임 */
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
            .subscribe(with: self) { owner , value in
                validNicknameFormat.onNext(value)
            }
            .disposed(by: disposeBag)
        
        /* 4. 생년월일 */
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
                validBirthdayFormat.onNext(value)
            }
            .disposed(by: disposeBag)
        
        
        /* 5. 성별 - 따로 검사할 내용 없음. 데이터 저장 */
        let validGenderSelected = PublishSubject<Int>()
        // 처음 (선택x) : -1
        // 여성 : 0 / 남성 : 1
        input.genderSelectedIndex
            .subscribe(with: self , onNext: { owner , value in
                validGenderSelected.onNext(value)
                print("====", value)
            })
            .disposed(by: disposeBag)
        
        
        /* 라스트. 회원가입 버튼 활성화 여부 */
        let validSignUp =  Observable.combineLatest(validEmailFormat, validPWFormat, validNicknameFormat, validBirthdayFormat, validGenderSelected) { v1 , v2, v3, v4, v5  in
            
            // 모든 객체가 편집 시작해야 그때부터 작동됨
                
            return (v1 == ValidEmail.available)
            && (v2 == ValidPW.available)
            && (v3 == ValidNickname.available)
            && (v4 == ValidBirthday.available)
            && (v5 == 0 || v5 == 1)
        }
        
        /* 찐 라스트. 회원가입 버튼 클릭 */
        let signUpInfo = Observable.combineLatest(input.emailText, input.pwText, input.nicknameText, input.birthdayText, input.genderSelectedIndex)
        
        let resultSignUpClicked = PublishSubject<AttemptSignUp>()
        input.signUpButtonClicked
            .withLatestFrom(signUpInfo)
//            .flatMap { value in
//                APIManager.shared.requestJoin(
//                    JoinRequest(
//                        email: value.0,
//                        password: value.1,
//                        nick: value.2,
//                        gender: Gender(rawValue: value.4)!.description,
//                        birthDay: value.3
//                    )
//                )
//            }
            .flatMap { value in
                RouterAPIManager.shared.request(
                    type: JoinResponse.self,
                    error: JoinAPIError.self,
                    api: .join(
                        sender: JoinRequest(
                            email: value.0, password: value.1, nick: value.2, gender: Gender(rawValue: value.4)!.description, birthDay: value.3))
                )
            }
            .map { response in
                switch response {
                case .success(_):
                    return AttemptSignUp.success
                case .failure(_):   // 임시. 추후에 나눌 예정
                    print("회원가입 실패. 에러 타입은 추후에 분리")
                    return AttemptSignUp.alreadyRegistered
                }
            }
            .subscribe(with: self) { owner , value in
                resultSignUpClicked.onNext(value)
            }
            .disposed(by: disposeBag)
            
        
        
        return Output(
            validEmailFormat: validEmailFormat,
            validPWFormat: validPWFormat,
            validNicknameFormat: validNicknameFormat,
            validBirthdayFormat: validBirthdayFormat,
            enabledSignUpButton: validSignUp,
            resultSignUpClicked: resultSignUpClicked
        )
    }
    
    
    // (이메일) 이메일 형식에 맞는지 확인
    func checkValidFormatEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // (패스워드) 특수문자와 숫자가 포함되어 있는지 확인
    func checkSpecialCharacterPW(_ pw: String) -> Bool {
        let specialCharacterRegex = ".*[^A-Za-z0-9].*"
        let numberRegex = ".*[0-9].*"

        let specialCharacterTest = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegex)

        return specialCharacterTest.evaluate(with: pw) && numberTest.evaluate(with: pw)
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

