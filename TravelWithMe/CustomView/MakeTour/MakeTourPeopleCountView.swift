//
//  MakeTourPeopleCountView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit
import SnapKit


class MakeTourPeopleCountView: BaseView {
    
    let minusButton = {
        let view = UIButton()
        view.setTitle("-", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 24)
        view.setTitleColor(.black, for: .normal)
        return view
    }()
    
    let countLabel = {
        let view = UILabel()
        view.text = "3"
        return view
    }()
    
    let plusButton = {
        let view = UIButton()
        view.setTitle("+", for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 24)
        view.setTitleColor(.black, for: .normal)
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        [minusButton, countLabel, plusButton].forEach { item in
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        minusButton.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
        
        plusButton.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(12)
        }
        
        countLabel.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = UIColor(hexCode: ConstantColor.textFieldBackground.hexCode)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
}
