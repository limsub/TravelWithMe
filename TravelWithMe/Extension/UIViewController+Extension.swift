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
    
    
    
}
