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
        view.backgroundColor = UIColor.appColor(.disabledGray1)
        return view
    }()
    let plusImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "plus")
        view.contentMode = .scaleAspectFill
        view.tintColor = UIColor.appColor(.gray1)
        return view
    }()
    
    lazy var cancelButton = {
        let view = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .light)
        let image = UIImage(systemName: "x.circle.fill", withConfiguration: imageConfig)
        view.setImage(image, for: .normal)
        view.tintColor = UIColor.appColor(.gray1)
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 15
        
        view.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        
        return view
    }()
    
    var cancelButtonCallBackMethod: ( () -> Void )?
    
    @objc
    func cancelButtonClicked() {
        if let closure = cancelButtonCallBackMethod {
            closure()
        }
    }
    
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(imageView)
        contentView.addSubview(plusImageView)
        contentView.addSubview(cancelButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(8)
        }
        plusImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.center.equalTo(imageView)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView)
            make.size.equalTo(30)
        }
    }
    
    func designPlusCell() {
        imageView.image = UIImage()
        cancelButton.isHidden = true
        cancelButton.isEnabled = false
        plusImageView.isHidden = false
    }
    
    func designCell(_ imageData: Data) {
        imageView.image = UIImage(data: imageData)
        cancelButton.isHidden = false
        cancelButton.isEnabled = true
        plusImageView.isHidden = true
    }
}
