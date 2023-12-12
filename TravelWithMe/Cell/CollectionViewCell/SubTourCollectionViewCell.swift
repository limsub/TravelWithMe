////
////  SubTourCollectionViewCell.swift
////  TravelWithMe
////
////  Created by 임승섭 on 2023/11/28.
////
//
//import UIKit
//import SnapKit
//
//// 셀 크기 150x200. title font 14. horizontal, bottom padding 12
//class SubTourCollectionViewCell: BaseCollectionViewCell {
//    
//    let backImageView = {
//        let view = UIImageView()
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 20
//        view.layer.cornerCurve = .continuous
//        view.image = UIImage(named: "sample")
//        return view
//    }()
//    
//    let shadowView = {
//        let view = UIImageView()
//        view.clipsToBounds = true
//        view.layer.cornerRadius = 20
//        view.layer.cornerCurve = .continuous
//        view.backgroundColor = .black.withAlphaComponent(0.5)
//        return view
//    }()
//    
//    let tourTitleLabel = {
//        let view = UILabel()
//        view.font = .boldSystemFont(ofSize: 14)
//        view.textColor = .white
//        view.numberOfLines = 2
//        view.text = "3박 4일 도쿄 여행 같이 가실분sadjfl;kjasd;lfkjas;dlfkja;slkdfja;sldkjf"
//        return view
//    }()
//    
//    override func setConfigure() {
//        super.setConfigure()
//        
//        [backImageView, shadowView, tourTitleLabel].forEach { item  in
//            contentView.addSubview(item)
//        }
//    }
//    
//    override func setConstraints() {
//        super.setConstraints()
//        
//        backImageView.snp.makeConstraints { make in
//            make.edges.equalTo(contentView)
//        }
//        shadowView.snp.makeConstraints { make in
//            make.edges.equalTo(backImageView)
//        }
//        
//        tourTitleLabel.snp.makeConstraints { make in
//            make.horizontalEdges.bottom.equalTo(contentView).inset(12)
//        }
//    }
//}
