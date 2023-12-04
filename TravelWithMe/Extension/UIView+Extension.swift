//
//  UIView+Extension.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import UIKit

extension UIView {
    
    
    // 투어 컬렉션뷰 셀 레이아웃
    func createTourCollectionViewLayout(topInset: Int) -> UICollectionViewFlowLayout  {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 36, height: 270)
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: CGFloat(topInset), left: 0, bottom: 0, right: 0)
       
        return layout
    }
    
    // 상세 투어 이미지 컬렉션뷰 셀 레이아웃
    func createSwipeImageLayout() -> UICollectionViewFlowLayout  {
        let layout = UICollectionViewFlowLayout()
        
        let width = UIScreen.main.bounds.width
        let height = CGFloat(360)
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
       
        return layout
    }
    
    
    // 상세 투어 투어 카테고리 컬렉션뷰 셀 레이아웃
    func createDetailTourCategoryCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 40, height: 30)
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        return layout
    }
    
}
