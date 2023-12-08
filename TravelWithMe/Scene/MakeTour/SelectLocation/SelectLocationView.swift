//
//  SelectLocationView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/6/23.
//

import UIKit
import MapKit
import SnapKit

class SelectLocationView: BaseView {
    
    let searchBar = UISearchBar()
    
    let tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(SelectLocationTableViewCell.self, forCellReuseIdentifier: "SelectLocationTableViewCell")
        view.rowHeight = 66
        return view
    }()
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [searchBar, tableView].forEach { item  in
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(18)
            make.height.equalTo(52)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}
