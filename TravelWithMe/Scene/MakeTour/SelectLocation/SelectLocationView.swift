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
    
    let searchBar = {
        let view = UISearchBar()
        view.placeholder = "떠나고 싶은 장소를 검색하세요"
//        view.searchBarStyle = .minimal
//        view.backgroundColor = UIColor.appColor(.inputGray)
        view.backgroundImage = UIImage()
        view.searchTextField.backgroundColor = UIColor.appColor(.inputGray)
        return view
    }()
    
    let tableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(SelectLocationTableViewCell.self, forCellReuseIdentifier: "SelectLocationTableViewCell")
        view.rowHeight = 66
        view.separatorInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        view.contentMode = .scaleAspectFill

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
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(18)
//            make.height.equalTo(52)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalTo(self).inset(18)
            make.bottom.equalTo(self)
        }
    }
}
