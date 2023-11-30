//
//  CALayer.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import UIKit

extension CALayer {
    // Sketch 스타일의 그림자를 생성한다
    func applyShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4) {
        
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
    }
}
