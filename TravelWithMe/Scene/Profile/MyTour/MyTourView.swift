//
//  MyTourView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import UIKit

class MyTourView: BaseView {
    
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
