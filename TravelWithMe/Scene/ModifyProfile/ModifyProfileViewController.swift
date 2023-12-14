//
//  ModifyProfileViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/11/23.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

class ModifyProfileViewController: BaseViewController {
    
    let mainView = ModifyProfileView()
    let viewModel = ModifyProfileViewModel()
    let disposeBag = DisposeBag()
    
    var delegate: RetryNetworkAndUpdateView?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        settingInitialDataOnView()
        settingProfileImageButton()
        
//        mainView.birthdayTextField.text = "19991010"
    }
    
    
    // 초기 데이터 (이전 화면에서 값전달로 받아온) 뷰에 띄워준다
    func settingInitialDataOnView() {
        if let initData = viewModel.profileInfo {
            mainView.initView(initData)
        }
    }
    
    // 프로필 이미지 버튼 addTarget 연결
    func settingProfileImageButton() {
        mainView.modifyProfileImageClearButton.addTarget(self , action: #selector(modifyProfileImageButtonClicked), for: .touchUpInside)
    }
    @objc
    func modifyProfileImageButtonClicked() {
        print("프로필 수정하기 - 이미지 클릭")
        
        showActionSheet("프로필 사진 설정", message: nil, firstTitle: "앨범에서 사진 선택", secondTitle: "기본 이미지로 변경") {
            self.showPHPicker()
        } secondCompletionHandler: {
            self.settingBasicProfileImage()
        }
    }
    
    // 기본 이미지로 변경 (저장된 profileImage를 없애는 것이 아니라, 기본 이미지를 저장시킨다)
    func settingBasicProfileImage() {
        let basicImage = UIImage(named: "basicProfile2")
        guard let imageData = basicImage?.jpegData(compressionQuality: 0.00000001) else { return }
        viewModel.profileImageData = imageData
        
        updateProfileImage()
    }
    
    // 프로필 이미지 업데이트
    func updateProfileImage() {
        if let newProfileImageData = viewModel.profileImageData {
            mainView.profileImageView.image = UIImage(data: newProfileImageData)
        } else {
            mainView.profileImageView.image = UIImage(named: "basicProfile2")
        }
    }
    
    

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
        
        
        output.resultModifyButtonClicked
            .subscribe(with: self) { owner , value in
                print(" --- VC에서 결과 받음 --- ")
                switch value {
                case .success(_):
                    print("(ModifyProfile) 네트워크 응답 성공")
                    
                    // 해야 할 것
                    // 1. delegate pattern 이용해서 profileView의 fetchData 로드
                    // -> 자동으로 네트워크 콜 하고 뷰 업데이트 할겨
                    owner.delegate?.reload()
                    
                    // 2. navigation pop
                    owner.navigationController?.popViewController(animated: true)
                    
                case .commonError(let error):
                    print("(ModifyProfile) 네트워크 응답 실패 - 공통 에러")
                    owner.showAPIErrorAlert(error.description)
                    
                case .modifyMyProfileError(let error):
                    print("(ModifyProfile) 네트워크 응답 실패 - 프로필 수정 에러")
                    owner.showAPIErrorAlert(error.description)
                    
                case .refreshTokenError(let error):
                    print("(ModifyProfile) 네트워크 응답 실패 - 토큰 에러")
                    if error == .refreshTokenExpired {
                        print("- 리프레시 토큰 만료!")
                        owner.goToLoginViewController()
                    } else {
                        owner.showAPIErrorAlert(error.description)
                    }
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    
    
    // 프로필 이미지 추가
    func showPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension ModifyProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard let result = results.first else { return }
        
        let itemProvider = result.itemProvider
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image , error in
                
                print("이미지 : ", image)
                print("에러 : ", error)
                
                guard let image = image as? UIImage else { return }
                
                guard let imageData = image.jpegData(compressionQuality: 0.0000000000001) else { return }
                
                self?.viewModel.profileImageData = imageData
                
                print("--- 용량?(bytes) : \(imageData.count)")
                let bytesInMegaByte = 1024.0 * 1024.0
                let mb = Double(imageData.count) / bytesInMegaByte
                print("--- 용량?(megabytes) : \(mb)")
                
                DispatchQueue.main.async {
                    self?.updateProfileImage()
                }
                
            }
        }
        
        picker.dismiss(animated: true)
        
    }
}
