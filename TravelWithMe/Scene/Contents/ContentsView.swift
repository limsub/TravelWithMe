//
//  ContentsView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit

class ContentsView: BaseView {
    
    lazy var tourCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createTourCollectionViewLayout())
        
        view.register(AboutTourCollectionViewCell.self, forCellWithReuseIdentifier: "ContentsView - tourCollectionView")
        
        view.backgroundColor = .red
        
        return view
    }()
    
    
    
    func createTourCollectionViewLayout() -> UICollectionViewFlowLayout  {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 270)
        
        layout.minimumLineSpacing = 20
        
        return layout
    }
    
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(tourCollectionView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tourCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
    
}
