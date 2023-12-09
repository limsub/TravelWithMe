//
//  ProfileInfoViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import UIKit

class ProfileInfoViewController: BaseViewController {
    
    let mainView = ProfileInfoView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        mainView.backgroundColor = .blue
        
        
        RouterAPIManager.shared.requestNormal(
            type: LookProfileResponse.self,
            error: LookProfileAPIError.self,
            api: .lookMyProfile) { response in
                print(" * === 프로필 조회 === * ")
                print(response)
            }
    }
}
