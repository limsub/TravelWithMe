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
    }
    
    struct Output {
        let validEmailFormat: PublishSubject<ValidEmail>
        let validPWFormat: PublishSubject<ValidPW>
        let validNicknameFormat: PublishSubject<ValidNickname>
        let validBirthdayFormat: PublishSubject<ValidBirthday>
        
        let validSignUpButton: Observable<Bool>
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
            .map { return ValidEmail.available }
            .subscribe(with: self) { owner , value  in
                print("이메일 중복 체크 버튼 클릭")
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

            return (v1 == ValidEmail.available)
            && (v2 == ValidPW.available)
            && (v3 == ValidNickname.available)
            && (v4 == ValidBirthday.available)
            && (v5 == 0 || v5 == 1)
        }
        
        
        return Output(
            validEmailFormat: validEmailFormat,
            validPWFormat: validPWFormat,
            validNicknameFormat: validNicknameFormat,
            validBirthdayFormat: validBirthdayFormat,
            validSignUpButton: validSignUp
        )
    }
    
    func checkValidFormatEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func checkSpecialCharacterPW(_ pw: String) -> Bool {
        let specialCharacterRegex = ".*[^A-Za-z0-9].*"
        let numberRegex = ".*[0-9].*"

        let specialCharacterTest = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex)
        let numberTest = NSPredicate(format: "SELF MATCHES %@", numberRegex)

        return specialCharacterTest.evaluate(with: pw) && numberTest.evaluate(with: pw)
    }
    
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
