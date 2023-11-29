//
//  UIImageView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/29.
//

import UIKit
import Kingfisher
import Alamofire

extension UIImageView {
    
    func loadImage(endURLString: String) {
        
        let imageURLString = SeSACAPI.baseURL + "/" + endURLString
        let imageURL = URL(string: imageURLString)
        
        let header = [
            "Authorization": KeychainStorage.shared.accessToken ?? "",
            "SesacKey": SeSACAPI.subKey
        ]
        
        let modifier = AnyModifier { request in
            var modifiedRequest = request
            for (key, value) in header {
                modifiedRequest.headers.add(name: key, value: value)
            }
            return modifiedRequest
        }
        
        
        self.kf.setImage(
            with: imageURL,
            options: [
                .requestModifier(modifier),
                .transition(.fade(0.5)),
                .forceTransition
            ]
        )
        
        
        
    }
}
