//
//  DetailTourSwipeImageCollectionViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import UIKit

class DetailTourSwipeImageCollectionViewCell: BaseCollectionViewCell {
    
    
    let mainImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(mainImageView)
    }
    override func setConstraints() {
        super.setConstraints()
        
        mainImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImageView.image = nil
    }
    
}
