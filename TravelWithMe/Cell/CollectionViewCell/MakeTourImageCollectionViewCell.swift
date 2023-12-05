//
//  MakeTourImageCollectionViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/26.
//

import UIKit


class MakeTourImageCollectionViewCell: BaseCollectionViewCell {
    
    
    // indexPath.row가 0일 때, plus만 띄워주고, cell 선택 가능
    // 0일 때 이미지뷰 plus, 아닐 때 사진 띄워주기
    
    let imageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.image = UIImage(systemName: "plus")
        return view
    }()
    
    let cancelButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(imageView)
        contentView.addSubview(cancelButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(8)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView)
            make.size.equalTo(24)
        }
    }
    
    func designPlusCell() {
        imageView.backgroundColor = UIColor(hexCode: ConstantColor.textFieldBackground.hexCode)
        imageView.image = UIImage(systemName: "plus")
        cancelButton.isHidden = true
        cancelButton.isEnabled = false
    }
    
    func designCell(_ imageData: Data) {
        imageView.image = UIImage(data: imageData)
        cancelButton.isHidden = false
        cancelButton.isEnabled = true
    }
}