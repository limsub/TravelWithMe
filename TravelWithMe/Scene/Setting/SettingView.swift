//
//  SettingView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/15/23.
//

import UIKit

class SettingView: BaseView {
    
    lazy var settingTableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.isScrollEnabled = false
        view.contentInset.left = 0
        view.contentInset.right = 0
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(settingTableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        settingTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func setting() {
        super.setting()
        
        
        
    }
}
