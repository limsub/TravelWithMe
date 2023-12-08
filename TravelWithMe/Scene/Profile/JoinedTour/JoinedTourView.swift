//
//  JoinedTourView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/8/23.
//

import UIKit

class JoinedTourView: BaseView {
    
    // refreshControl하려면 위에 빈 뷰 하나 공간 차지하게 두는게 낫지 않을까 싶음!!!
    
    lazy var joinedTourTableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        
        view.register(JoinedTourTableViewCell.self, forCellReuseIdentifier: "ProfileJoinedTourView - JoinedTourTableView")
        
        view.showsVerticalScrollIndicator = false
        
        view.rowHeight = 140
        view.contentInset = .zero
        view.separatorInset = .zero
        view.separatorStyle = .none
        
        
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(joinedTourTableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        joinedTourTableView.snp.makeConstraints { make in
            make.top.equalTo(self).inset(270)
            make.horizontalEdges.bottom.equalTo(self)
        }
    }
    
    override func setting() {
        super.setting()
        
        backgroundColor = .white
    }
}
