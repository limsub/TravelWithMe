//
//  StartTabBarViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/6/23.
//

import UIKit

//extension CALayer {
//    // Sketch 스타일의 그림자를 생성한다
//    func applyShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4) {
//        
//        shadowColor = color.cgColor
//        shadowOpacity = alpha
//        shadowOffset = CGSize(width: x, height: y)
//        shadowRadius = blur / 2.0
//    }
//}

//extension UITabBar {
//    // 기본 그림자 스타일을 초기화해서, 커스텀 스타일을 적용할 준비를 한다
//    static func clearShadow() {
//        UITabBar.appearance().shadowImage = UIImage()
//        UITabBar.appearance().backgroundImage = UIImage()
//        UITabBar.appearance().backgroundColor = UIColor.white
//    }
//}



class StartTabBarViewController: UITabBarController {
    
    let a = StartViewController()
    let b = ContentsViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .clear
        

        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow()
        
//        tabBar.tintColor = Constant.Color.main2
        
        tabBarController?.tabBar.backgroundColor = .white
    
        tabBar.layer.cornerRadius = 30
        
        a.tabBarItem.image = UIImage(systemName: "music.note.house")
        b.tabBarItem.image = UIImage(systemName: "calendar")
        
        
        
        [a, b].forEach { vc in
            vc.tabBarItem.imageInsets = UIEdgeInsets(
                top: -30,
                left: 0,
                bottom: 10,
                right: 0
            )
            vc.title = nil
        }
        
//        let navPager = UINavigationController(rootViewController: pagerVC)
        let navA = UINavigationController(rootViewController: a)
        let navB = UINavigationController(rootViewController: b)
        
        
        let tabItem = [navA, navB]
        self.viewControllers = tabItem
        
        tabBarController?.hidesBottomBarWhenPushed = true
    
        setViewControllers(tabItem, animated: true)
    }
}
