//
//  DetailTourView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import UIKit

class HideHalfDetailTourImageBezierView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white.withAlphaComponent(0.00001)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        let width = UIScreen.main.bounds.width
        
        
        UIColor.yellow.setFill()
        path.lineWidth = 0
        
        path.move(to: CGPoint(x: 0, y: 100))
        path.addLine(to: CGPoint(x: 0, y: 60))
        path.addCurve(to: CGPoint(x: width, y: 30),
                      controlPoint1: CGPoint(x: center.x - 50, y: 150),
                      controlPoint2: CGPoint(x: center.x + 50, y: -50)
        )
        path.addLine(to: CGPoint(x: width, y: 100))
        
        path.stroke()
        path.fill()
    }
}

class DetailTourView: BaseView {
    
    // * 스크롤뷰
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    
    // 1. 이미지 스와이프해서 넘길 컬렉션뷰
    lazy var swipeImagesCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createSwipeImageLayout())
        
        view.register(DetailTourSwipeImageCollectionViewCell.self , forCellWithReuseIdentifier: "DetailTourView - DetailTourSwipeImageCollectionViewCell")
        
        view.showsHorizontalScrollIndicator = false
        
        view.isPagingEnabled = true
        
        view.backgroundColor = .red
        
        return view
    }()
    
    // 2. 곡선 뷰 (이미지 컬렉션뷰 위에 덮어씌우기)
    let curveView = HideHalfDetailTourImageBezierView()
    
    // 3. 이미지 PageControl
    lazy var swipeImagesPageControl = {
        let view = UIPageControl()
        view.numberOfPages = 4
        view.hidesForSinglePage = true
        view.currentPageIndicatorTintColor = .red
        view.pageIndicatorTintColor = .blue
        return view
    }()
    
    // 4. 투어 카테고리 컬렉션뷰
    lazy var tourCategoryCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createDetailTourCategoryCollectionViewLayout())
        
        view.register(DetailTourCategoryCollectionViewCell.self , forCellWithReuseIdentifier: "DetailTourView - DetailTourCategoryCollectionViewCell")
        
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .orange
        
        view.isScrollEnabled = false
        
        return view
    }()
    
    // 5. 투어 타이틀 레이블
    let tourTitleLabel = ContentsTourTitleLabel(.black)
    
    // 6. 투어 제작자 이미지뷰
    let tourProfileImageView = ContentsProfileImageView(frame: .zero)
    
    // 6. 투어 제작자 레이블
    let tourProfileLabel = ContentsTourProfileNameLabel(.black)

    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [swipeImagesCollectionView, curveView, swipeImagesPageControl, tourCategoryCollectionView, tourTitleLabel, tourProfileImageView, tourProfileLabel].forEach { item  in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        // * 스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        
        
        // * 인스턴스
        swipeImagesCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(360)
        }
        
        curveView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(260)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        swipeImagesPageControl.snp.makeConstraints { make in
            make.centerY.equalTo(curveView).inset(20)
            make.trailing.equalTo(contentView).inset(20)
        }
        
        tourCategoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(curveView.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(30)
        }
        
        tourTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(tourCategoryCollectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        tourProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(tourTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(contentView).inset(18)
            make.size.equalTo(40)
        }
        tourProfileLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tourProfileImageView)
            make.leading.equalTo(tourProfileImageView.snp.trailing).offset(12)
        }
    }
    
}
