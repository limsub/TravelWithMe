//
//  CheckReviewView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/10/23.
//

import UIKit

class CheckReviewView: BaseView {
    
    let tourView = ReviewSmallTourView()
    
    let checkReviewTableView = {
        let view = UITableView()
        view.register(CheckReviewTableViewCell.self, forCellReuseIdentifier: Identifier.checkReviewTableView.rawValue)
        
//        view.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        view.layoutMargins = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        
        view.showsVerticalScrollIndicator = false
        
        view.estimatedRowHeight = 60
        view.rowHeight = UITableView.automaticDimension
        
        view.contentInset = .zero
        view.separatorInset = .zero
        view.separatorStyle = .none
        view.allowsSelection = false
        
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        [checkReviewTableView, tourView].forEach { item in
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tourView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(self).inset(18)
            make.height.equalTo(90)
        }
        
        checkReviewTableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(self)
            make.top.equalTo(tourView.snp.bottom).offset(5)
//            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func setting() {
        super.setting()
        
        backgroundColor = .blue
    }
}
