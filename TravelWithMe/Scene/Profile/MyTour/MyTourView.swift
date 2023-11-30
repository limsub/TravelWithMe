//
//  MyTourView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import UIKit

class MyTourView: BaseView {
    
    lazy var myTourCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createTourCollectionViewLayout())
        
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
            make.verticalEdges.equalTo(self)
            make.horizontalEdges.equalTo(self).inset(18)
        }
    }
    
}
