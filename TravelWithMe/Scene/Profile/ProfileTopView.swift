//
//  ProfileTopView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/29.
//

import UIKit

class ProfileTopBackBackView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        let colors: [CGColor] = [
            UIColor.appColor(.main1).cgColor,
            UIColor.appColor(.second1).cgColor
        ]
        gradientLayer.colors = colors

        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

class ProfileTopBackView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        print("----rect : ", rect)
        print("----rect : ", rect)
        
        let path = UIBezierPath()
        
        let width = UIScreen.main.bounds.width
        
        UIColor.white.setFill()
//        UIColor.systemYellow.setStroke()
        path.lineWidth = 0
        
        
        let height = rect.height
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: 140))
        path.addCurve(to: CGPoint(x: width , y: 140),
                      controlPoint1: CGPoint(x: center.x - 50, y: 200),
                      controlPoint2: CGPoint(x: center.x + 50, y: 40)
        )
        path.addLine(to: CGPoint(x: width, y: height))
    
        path.stroke()
        path.fill()
    }
}


class ProfileTopView: BaseView {
    
    let backBackView = ProfileTopBackBackView()
    let backView = ProfileTopBackView()
    
    let profileImageView = ContentsProfileImageView(frame: .zero)
    
    let nameLabel = ContentsTourTitleLabel(.black)

    let modifyButton = ProfileModifyButton()
    
    override func setConfigure() {
        super.setConfigure()
        
        [backBackView, backView, profileImageView, nameLabel, modifyButton].forEach { item  in
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        backBackView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
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
            make.height.equalTo(34)
        }
        
        
    }
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = .white
        profileImageView.image = UIImage(named: "sample")
        
        nameLabel.text = "이름"
        nameLabel.textAlignment = .center
    }
    
    func updateProfileTopView(_ result: LookProfileResponse, userType: UserType) {
        
        // 프로필 이미지뷰
        profileImageView
        
        // 닉네임 넣어주기
        if let nickStruct = decodingStringToStruct(type: ProfileInfo.self, sender: result.nick) {
            nameLabel.text = nickStruct.nick
        }
        
        // 버튼 수정
        modifyButton.updateButton(userType)
    }
}
