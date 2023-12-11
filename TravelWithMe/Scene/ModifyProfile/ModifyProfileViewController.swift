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
        let input = ModifyProfileViewModel.Input(
            firstNickName: mainView.nicknameTextField.rx.observe(String.self, "text"),
            firstBirthday: mainView.birthdayTextField.rx.observe(String.self, "text"),
            firstGender: mainView.genderSelectSegmentControl.rx.observe(Int.self, "selectedSegmentIndex"),
            
            nicknameText:
                mainView.nicknameTextField.rx.text.orEmpty,
            birthdayText: mainView.birthdayTextField.rx.text.orEmpty,
            genderSelectedIndex: mainView.genderSelectSegmentControl.rx.selectedSegmentIndex,
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
