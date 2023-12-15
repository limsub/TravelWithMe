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
    
    func loadImage(endURLString: String, size: CGSize) {
        
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
        
//        let value = CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale)
//        let processor = DownsamplingImageProcessor(size: CGSize(width: 400, height: 400))
//        let processor = DownsamplingImageProcessor(size: size)
        
        self.kf.setImage(
            with: imageURL,
            placeholder: UIImage(named: "basicProfile2"),
            options: [
                .requestModifier(modifier),
//                .processor(processor),
//                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .progressiveJPEG(.init(isBlur: false, isFastestScan: true, scanInterval: 0.1))
            ]
        )
        
        
        
    }
}
