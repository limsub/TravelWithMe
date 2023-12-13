//
//  UIViewController+Extension.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/29.
//

import UIKit

extension UIViewController {
    
    func showActionSheet(_ title: String?, message: String?, firstTitle: String, secondTitle: String, firstCompletionHandler: @escaping () -> Void, secondCompletionHandler: @escaping () -> Void ) {
        
        let actionSheet = UIAlertController(title: title , message: message, preferredStyle: .actionSheet)
        
        let firstButton = UIAlertAction(title: firstTitle, style: .default) { _ in
            firstCompletionHandler()
        }
        
        let secondButton = UIAlertAction(title: secondTitle, style: .default) { _ in
            secondCompletionHandler()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
    
        
        actionSheet.addAction(firstButton)
        actionSheet.addAction(secondButton)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
    
    
    func showNoButtonAlert(_ title: String? = nil, message: String? = nil, completionHandler: @escaping () -> Void) {
        
        if title == nil && message == nil { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true)
            completionHandler()
        }
    }
    
    
    func showSingleAlert(_ title: String? = nil, message: String? = nil, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "확인", style: .default)
        
        alert.addAction(okButton)
        
        present(alert, animated: true)
    }
    
    
    func showAPIErrorAlert() {
        
    }
    
    
    func goToLoginViewController() {
        
        showNoButtonAlert("토큰이 만료되었습니다", message: "로그인 화면으로 돌아갑니다. 재로그인 해주세요") {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            
            let vc = UINavigationController(rootViewController: LoginViewController())
            sceneDelegate?.window?.rootViewController = vc
            sceneDelegate?.window?.makeKeyAndVisible()
        }
        
    }
    

    
}
