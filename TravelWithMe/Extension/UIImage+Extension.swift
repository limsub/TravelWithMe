//
//  UIImage+Extension.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/26.
//

import UIKit

extension UIImage{
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.draw(in: CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeImage2(newWidth: CGFloat, newHeight: CGFloat) -> UIImage {
        
        // 꽉 차게 보이게 하기 위해서 가로 세로 중 작은 값을 기준으로 잡아준다
        if self.size.width < self.size.height {
            
            let scale = newWidth / self.size.width
            let newHeight2 = self.size.height * scale
            
            let size = CGSize(width: newWidth, height: newHeight2)
            
            let render = UIGraphicsImageRenderer(size: size)
            let renderImage = render.image { contenxt in
                self.draw(in: CGRect(origin: .zero, size: size))
            }
            
            
            if let originImageData = self.jpegData(compressionQuality: 1.0),
               let resize2ImageData = renderImage.jpegData(compressionQuality: 1.0) {
                print("origin : \(originImageData), resize2 : \(resize2ImageData)")
            }
            
            return renderImage
        } else {
            
            let scale = newHeight / self.size.height
            let newWidth2 = self.size.width * scale
            
            let size = CGSize(width: newWidth2, height: newHeight)
            
            let render = UIGraphicsImageRenderer(size: size)
            let renderImage = render.image { contenxt in
                self.draw(in: CGRect(origin: .zero, size: size))
            }
            
            if let originImageData = self.jpegData(compressionQuality: 1.0),
               let resize2ImageData = renderImage.jpegData(compressionQuality: 1.0) {
                print("origin : \(originImageData), resize2 : \(resize2ImageData)")
            }
            
            return renderImage
        }
    }
}
