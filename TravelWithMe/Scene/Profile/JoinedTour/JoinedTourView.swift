//
//  JoinedTourView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/8/23.
//

import UIKit

class JoinedTourView: BaseView {
    
    // refreshControl하려면 위에 빈 뷰 하나 공간 차지하게 두는게 낫지 않을까 싶음!!!
    let spacerView = UIView()
    
    lazy var joinedTourTableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        
        view.register(JoinedTourTableViewCell.self, forCellReuseIdentifier: "ProfileJoinedTourView - JoinedTourTableView")
        
        view.showsVerticalScrollIndicator = false
        
        view.rowHeight = 140
        view.contentInset = .zero
        view.separatorInset = .zero
        view.separatorStyle = .none
        
        view.backgroundColor = .white
        
        
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(spacerView)
        addSubview(joinedTourTableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        spacerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self)
            make.height.equalTo(270)
        }
        joinedTourTableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self)
            make.top.equalTo(spacerView.snp.bottom)
        }
    }
    
    override func setting() {
        super.setting()
        
        backgroundColor = .white
    }
}
