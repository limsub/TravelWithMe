//
//  MakeTourDatesView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/26.
//

import UIKit

class MakeTourDatesView: UIView {
    
    let label = UILabel()
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(_ imageName: String, placeholder: String) {
        self.init()
        
        setUp(imageName, placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp(_ imageName: String, placeholder: String) {
        // 뷰 세팅
        clipsToBounds = true
        layer.cornerRadius = 10
        backgroundColor = UIColor(hexCode: ConstantColor.textFieldBackground.hexCode)
        
        // 버튼 세팅
        button.setImage(UIImage(systemName: imageName), for: .normal)
        
        // 레이블 세팅
        label.text = placeholder
        label.textColor = UIColor(hexCode: ConstantColor.textFieldPlaceholder.hexCode)
        label.font = .systemFont(ofSize: 14)
        
        // 레이아웃
        addSubview(label)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(self).inset(14)
            make.width.equalTo(button.snp.height)
        }
        label.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(self).inset(14)
            make.trailing.equalTo(button.snp.leading).offset(-8)
        }
    }
}
