//
//  MyTourView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import UIKit

class MyTourView: BaseView {
    
    // refreshControl하려면 위에 빈 뷰 하나 공간 차지하게 두는게 낫지 않을까 싶음!!!
    
    lazy var myTourCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createTourCollectionViewLayout(topInset: 10))
        
        view.register(AboutTourCollectionViewCell.self, forCellWithReuseIdentifier: "ProfileMyTourView - tourCollectionView")
        
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(myTourCollectionView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        myTourCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self)
            make.top.equalTo(self).inset(270)
        }
        
    }
    
}
