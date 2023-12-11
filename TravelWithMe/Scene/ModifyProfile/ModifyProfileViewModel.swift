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
    
    
    struct Input {
        let firstNickName: Observable<String?>
        let firstBirthday: Observable<String?>
        let firstGender: Observable<Int?>
        
        let nicknameText: ControlProperty<String>
        let birthdayText: ControlProperty<String>
        let genderSelectedIndex: ControlProperty<Int>
        let introduceText: ControlProperty<String>
        
        let modifyButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let validNicknameFormat: PublishSubject<ValidNickname>
        let validBirthdayFormat: PublishSubject<ValidBirthday>
//        
        let enabledModifyButton: Observable<Bool>
//        let resultModifyClicked: publ
    }
    
    
    func tranform(_ input: Input) -> Output {
        
        var finalNickName: String
        var finalBirthday: String
        var finalGender: Int
        var finalIntroduce: String
        
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
        
        
        // 초기값 대응
        input.firstNickName
            .map { text in
                guard let text else { return ValidNickname.nothing }
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
                print("-- (first) validnickname \(value) ")
                validNicknameFormat.onNext(value)
            })
            .disposed(by: disposeBag)
        input.firstBirthday
            .map { text in
                guard let text else { return ValidBirthday.nothing }
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
                print("-- (first) validbirthday \(value) ")
                validBirthdayFormat.onNext(value)
            }
            .disposed(by: disposeBag)
        input.firstGender
            .subscribe(with: self) { owner , value in
                
                print("-- (first) validgender \(value) ")
                validGenderSelected.onNext(value ?? -1)
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
        
        
        return Output(
            validNicknameFormat: validNicknameFormat,
            validBirthdayFormat: validBirthdayFormat,
            enabledModifyButton: enabledModifyButton
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
