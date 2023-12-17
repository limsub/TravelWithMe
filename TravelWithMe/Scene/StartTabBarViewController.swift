//
//  StartTabBarViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/6/23.
//

import UIKit



class StartTabBarViewController: UITabBarController {
    
//    let a = StartViewController()
    let b = ContentsViewController()
    let c = ProfileViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        c.fromTabBar = true
        
        view.backgroundColor = .clear
        

        
        UITabBar.clearShadow()
        tabBar.layer.applyShadow()
        
//        tabBar.tintColor = Constant.Color.main2
        
        tabBarController?.tabBar.backgroundColor = .white
    
        tabBar.layer.cornerRadius = 30
        
//        a.tabBarItem.image = UIImage(systemName: "music.note.house")
        b.tabBarItem.image = UIImage(systemName: "house")
        c.tabBarItem.image = UIImage(systemName: "person")
        
        
        
        [ b, c].forEach { vc in
            vc.tabBarItem.imageInsets = UIEdgeInsets(
                top: -30,
                left: 0,
                bottom: 10,
                right: 0
            )
            vc.title = nil
        }
        
//        let navPager = UINavigationController(rootViewController: pagerVC)
//        let navA = UINavigationController(rootViewController: a)
        let navB = UINavigationController(rootViewController: b)
        let navC = UINavigationController(rootViewController: c)
        
        
        let tabItem = [navB, navC]
        self.viewControllers = tabItem
        
        tabBarController?.hidesBottomBarWhenPushed = true
    
        setViewControllers(tabItem, animated: true)
    }
}
