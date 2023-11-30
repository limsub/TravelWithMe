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
    
}
