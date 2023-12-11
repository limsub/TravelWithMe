//
//  ModifyProfileViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/11/23.
//

import UIKit
import RxSwift
import RxCocoa

class ModifyProfileViewController: BaseViewController {
    
    let mainView = ModifyProfileView()
    let viewModel = ModifyProfileViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        settingInitialDataOnView()
        
//        mainView.birthdayTextField.text = "19991010"
    }
    
    
    // 초기 데이터 (이전 화면에서 값전달로 받아온) 뷰에 띄워준다
    func settingInitialDataOnView() {
        if let initData = viewModel.profileInfo {
            mainView.initView(initData)
        }
    }
    
    
    // 수정 네트워크 콜이 200 나왓으면, delegate pattern 이용해서 이전 뷰컨(ProfileVC)에서 fetchData 시켜주자-> 프로필 정보 새로 받아서 뷰 업데이트함.
    func bind() {
        
        // 전달해준 값을 수정 안하고 그대로 쓸 수도 있기 때문에, 초기값과 변경값을 둘 다 반영하기 위함
        let nick1 = mainView.nicknameTextField.rx.text.orEmpty
        let nick2 = mainView.nicknameTextField.rx.observe(String.self, "text")
        let nick = PublishSubject<String>()
        
        let birth1 = mainView.birthdayTextField.rx.text.orEmpty
        let birth2 = mainView.birthdayTextField.rx.observe(String.self, "text")
        let birth = PublishSubject<String>()
        
        let gender1 = mainView.genderSelectSegmentControl.rx.selectedSegmentIndex
        let gender2 = mainView.genderSelectSegmentControl.rx.observe(Int.self, "selectedSegmentIndex")
        let gender = PublishSubject<Int>()
        
        
        nick1.subscribe(with: self) { owner , value in
            nick.onNext(value)
        }.disposed(by: disposeBag)
        nick2.subscribe(with: self) { owner , value in
            nick.onNext(value!)
        }.disposed(by: disposeBag)
        
        birth1.subscribe(with: self) { owner , value in
            birth.onNext(value)
        }.disposed(by: disposeBag)
        birth2.subscribe(with: self) { owner , value in
            birth.onNext(value!)
        }.disposed(by: disposeBag)
        
        gender1.subscribe(with: self) { owner , value in
            gender.onNext(value)
        }.disposed(by: disposeBag)
        gender2.subscribe(with: self) { owner , value in
            gender.onNext(value!)
        }.disposed(by: disposeBag)
        
        
        
        let input = ModifyProfileViewModel.Input(
            nicknameText: nick,
            birthdayText: birth,
            genderSelectedIndex: gender,
            
            introduceText: mainView.introduceTextView.rx.text.orEmpty,
            modifyButtonClicked: mainView.completeButton.rx.tap
        )
        

        let output = viewModel.tranform(input)
        
        output.validNicknameFormat
            .subscribe(with: self) { owner , value in
                owner.mainView.checkNicknameLabel.setUpText(value)
            }
            .disposed(by: disposeBag)
        
        output.validBirthdayFormat
            .subscribe(with: self) { owner , value in
                owner.mainView.checkBirthdayLabel.setUpText(value)
            }
            .disposed(by: disposeBag)
        
        
        output.enabledModifyButton
            .subscribe(with: self) { owner , value in
                print("(VC) -- enabledButton : \(value)")
                owner.mainView.completeButton.update( (value) ? .enabled : .disabled)
            }
            .disposed(by: disposeBag)
        
 
        
    }
}
