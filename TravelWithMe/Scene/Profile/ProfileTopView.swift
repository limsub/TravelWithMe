//
//  ProfileTopView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/29.
//

import UIKit

class BezierView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        let width = UIScreen.main.bounds.width
        
        UIColor.systemRed.setFill()
        UIColor.systemYellow.setStroke()
        path.lineWidth = 1

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 140))
        path.addCurve(to: CGPoint(x: width , y: 140),
                      controlPoint1: CGPoint(x: center.x - 50, y: 200),
                      controlPoint2: CGPoint(x: center.x + 50, y: 40)
        )
        path.addLine(to: CGPoint(x: width, y: 0))

        path.stroke()
        path.fill()
    }
}

class ProfileTopView: BaseView {
    
    
    let backView = BezierView()
    
    let profileImageView = ContentsProfileImageView(frame: .zero)
    
    let nameLabel = {
        let view = UILabel()
        view.textColor = .systemPink
        view.font = .boldSystemFont(ofSize: 20)
        view.text = "아아아아아아아"
        view.textAlignment = .center
        view.backgroundColor = .white
        return view
    }()
    
    let modifyButton = ProfileModifyButton()
    
    override func setConfigure() {
        super.setConfigure()
        
        [backView, profileImageView, nameLabel, modifyButton].forEach { item  in
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        backView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        profileImageView.snp.makeConstraints { make in
            make.centerY.equalTo(150)
            make.leading.equalTo(self).inset(24)
            make.size.equalTo(100)
        }
        nameLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self).inset(24)
            make.centerY.equalTo(profileImageView).offset(-10)
            make.width.equalTo(170)
        }
        modifyButton.snp.makeConstraints { make in
            make.centerX.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.width.equalTo(160)
        }
        
        
    }
    
    override func setting() {
        super.setting()
        
        profileImageView.image = UIImage(named: "sample")
    }
}
