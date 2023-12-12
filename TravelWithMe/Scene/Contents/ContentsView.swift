//
//  ContentsView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit

class ContentsView: BaseView {
    
    /* 카테고리 버튼 */
    let categoryScrollView = UIScrollView()
    let categoryContentView = UIView()
    
    let categoryButtons = [
        ContentsCategoryButton(.all),
        ContentsCategoryButton(.city),
        ContentsCategoryButton(.nature),
        ContentsCategoryButton(.culture),
        ContentsCategoryButton(.food),
        ContentsCategoryButton(.adventure),
        ContentsCategoryButton(.history),
        ContentsCategoryButton(.local)
    ]
    

    
    /* 메인 컬렉션뷰 */
    lazy var tourCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createTourCollectionViewLayout(topInset: 0))
        
        view.register(AboutTourCollectionViewCell.self, forCellWithReuseIdentifier: "ContentsView - tourCollectionView")
        
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        
        addSubview(categoryScrollView)
        addSubview(tourCollectionView)
        categoryScrollView.addSubview(categoryContentView)
        categoryButtons.forEach { item  in
            categoryContentView.addSubview(item)
        }
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        categoryScrollView.backgroundColor = .white
        
        categoryScrollView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        categoryContentView.snp.makeConstraints { make in
            make.edges.equalTo(categoryScrollView.contentLayoutGuide)
            make.width.greaterThanOrEqualTo(self.snp.width).priority(.low)
            make.height.equalTo(categoryScrollView.snp.height)
        }
        categoryButtons[0].snp.makeConstraints { make in
            make.verticalEdges.equalTo(categoryContentView).inset(4)
            make.leading.equalTo(categoryContentView).inset(18)
            make.width.equalTo(60)
        }
        for (index, item) in categoryButtons.enumerated() {
            if (index == 0) { continue }
            item.snp.makeConstraints { make in
                make.verticalEdges.equalTo(categoryContentView).inset(4)
                make.leading.equalTo(categoryButtons[index-1].snp.trailing).offset(10)
                make.width.equalTo(60)
            }
            
            if item == categoryButtons.last {
                item.snp.makeConstraints { make in
                    make.trailing.equalTo(categoryContentView)
                }
            }
        }
  
        tourCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(categoryScrollView.snp.bottom)
            make.top.equalTo(categoryScrollView.snp.bottom).offset(8)
            make.bottom.equalTo(self)
            make.horizontalEdges.equalTo(self)
        }
    }
    
    override func setting() {
        super.setting()

        tourCollectionView.layer.addBorder([.top], color: UIColor.appColor(.main3), width: 10)
        
        categoryScrollView.showsHorizontalScrollIndicator = false
    }
    
}
