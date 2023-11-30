//
//  UITabBar+Extension.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import UIKit


extension UITabBar {
    // 기본 그림자 스타일을 초기화해서, 커스텀 스타일을 적용할 준비를 한다
    static func clearShadow() {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().backgroundColor = UIColor.white
    }
}
