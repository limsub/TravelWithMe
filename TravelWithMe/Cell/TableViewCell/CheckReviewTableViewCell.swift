//
//  CheckReviewTableViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/10/23.
//

import UIKit
import SnapKit

class CheckReviewTableViewCell: BaseTableViewCell {
    
    let profileImageView = ContentsProfileImageView(frame: .zero)
    let profileNameLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 14)
        view.textColor = .black
        view.text = "임승섭입니다"
        return view
    }()
    
    let seperateLineView = UIView()
    
    // 리뷰 카테고리 개수가 정해져있지 않기 때문에 (1 ~ 3) 컬렉션뷰로 구성한다
    let reviewCategoryCollectionView = {
//        let view = UICollectionView(frame: <#T##CGRect#>, collectionViewLayout: <#T##UICollectionViewLayout#>)
        let view = UIView()
        return view
    }()
    
    let reviewContentsLabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 14)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .left
        
        view.text = ["안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일", "aaaaaaaaaaaaaaaaaaaaaaaaa", "bbbb", "cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc", "d"].randomElement()!
        
        return view
    }()
    
    let reviewDateLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = UIColor.appColor(.gray1)
        view.textAlignment = .left
        view.numberOfLines = 1
        
        view.text = "2023.10.23"
        return view
    }()
    
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [profileImageView, profileNameLabel, seperateLineView, reviewCategoryCollectionView, reviewContentsLabel, reviewDateLabel].forEach { item in
            contentView.addSubview(item)
            item.backgroundColor = .red
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        let padding = 18 + 5
        
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.top.leading.equalTo(contentView).inset(padding)
        }
        profileNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.centerY.equalTo(profileImageView)
        }
        
        seperateLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(padding)
            make.top.equalTo(profileImageView.snp.bottom).offset(5)
            make.height.equalTo(1)
        }
        
        reviewCategoryCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(padding)
            make.top.equalTo(seperateLineView.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
        reviewContentsLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(padding)
            make.top.equalTo(reviewCategoryCollectionView.snp.bottom).offset(5)
        }
        reviewDateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(padding)
            make.top.equalTo(reviewContentsLabel.snp.bottom).offset(8)
            make.bottom.equalTo(contentView).inset(5)
        }
        
    }
    
    
    override func setting() {
        super.setting()
        
        
    }
}
