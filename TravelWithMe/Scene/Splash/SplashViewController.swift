//
//  SplashViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/13/23.
//

import UIKit

class SplashViewController: BaseViewController {
    
    let mainView = SplashView()
    let viewModel = SplashViewModel()
    
    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViewFadeEffect()
        
        viewModel.testToken()
        transitionNextPage()
    }
    
    func setUpViewFadeEffect() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .fade
        view.window?.layer.add(transition, forKey: kCATransition)
    }
    
    func transitionNextPage() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            print("1초 지남. viewModel에 저장된 값에 따라 화면 전환")
            
            switch self.viewModel.nextPage {
            case .loginView:
                self.setUpViewFadeEffect()
                let vc = UINavigationController(rootViewController: LoginViewController()) 
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            case .mainView:
                self.setUpViewFadeEffect()
                let vc = StartTabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false)
            }
        }
        
    }
}
