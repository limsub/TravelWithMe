//
//  SignUpViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit
import SnapKit

class SignUpViewController: BaseViewController {
    
    let mainView = SignUpView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setNavigation()
    }
    
    
    override func setConfigure() {
        super.setConfigure()
        
        
    }
    
    override func setConstraints() {
        super.setConstraints()
    
    }
    
    func setNavigation() {
        navigationItem.title = "회원가입"
        navigationItem.largeTitleDisplayMode = .always
    }
}
