//
//  ModifyProfileViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/11/23.
//

import UIKit

class ModifyProfileViewController: BaseViewController {
    
    let mainView = ModifyProfileView()
    let viewModel = ModifyProfileViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingInitialDataOnView()
    }
    
    
    // 초기 데이터 (이전 화면에서 값전달로 받아온) 뷰에 띄워준다
    func settingInitialDataOnView() {
        if let initData = viewModel.profileInfo {
            mainView.initView(initData)
        }
    }
    
    
    // 수정 네트워크 콜이 200 나왓으면, delegate pattern 이용해서 이전 뷰컨(ProfileVC)에서 fetchData 시켜주자-> 프로필 정보 새로 받아서 뷰 업데이트함.
}
