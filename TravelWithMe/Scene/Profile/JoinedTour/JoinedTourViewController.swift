//
//  JoinedTourViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import UIKit

class JoinedTourViewController: BaseViewController {
    
    let matrix = [[Int]](repeating: [Int](repeating: 0, count: 10), count: 4)

    
    let mainView = JoinedTourView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView()
    }
    
    
    func settingTableView() {
        mainView.joinedTourTableView.delegate = self
        mainView.joinedTourTableView.dataSource = self
    }
}


extension JoinedTourViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return matrix.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matrix[section].count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = JoinedTourTableViewHeaderView()
        
        headerView.monthLabel.text = "\(Int.random(in: 1...100)) 하이"
        
        return headerView
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileJoinedTourView - JoinedTourTableView", for: indexPath) as? JoinedTourTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    
    
    
}
