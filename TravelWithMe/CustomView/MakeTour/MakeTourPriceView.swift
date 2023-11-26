//
//  MakeTourPriceTextField.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/26.
//

import UIKit

class MakeTourPriceView: UIView {
    
    let textField = UITextField()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        // 뷰 세팅
        clipsToBounds = true
        layer.cornerRadius = 10
        backgroundColor = UIColor(hexCode: ConstantColor.textFieldBackground.hexCode)
        
        // 레이블 세팅
        label.text = "원"
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right

        // 레이아웃
        addSubview(textField)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalTo(self).inset(14)
            make.width.equalTo(label.snp.height)
        }
        textField.snp.makeConstraints { make in
            make.verticalEdges.leading.equalTo(self).inset(14)
            make.trailing.equalTo(label.snp.leading).offset(-8)
        }
        
    }
    
    
    
}
