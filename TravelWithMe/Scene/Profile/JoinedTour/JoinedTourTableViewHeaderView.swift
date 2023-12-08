//
//  JoinedTourTableViewHeaderView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/8/23.
//

import UIKit

class JoinedTourTableViewHeaderView: BaseView {
    
    let monthLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18)
        view.text = "2023 Oct"
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(monthLabel)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        monthLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self).inset(20)
        }
    }
    
    override func setting() {
        super.setting()
        
        backgroundColor = .white
    }
}
