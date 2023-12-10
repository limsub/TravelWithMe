//
//  CheckReviewViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/10/23.
//

import UIKit

class CheckReviewViewController: BaseViewController {
    
    let mainView = CheckReviewView()
    
    
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView()
    }
    
    func settingTableView() {
        mainView.checkReviewTableView.delegate = self
        mainView.checkReviewTableView.dataSource = self
    }
}

extension CheckReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.checkReviewTableView.rawValue, for: indexPath) as? CheckReviewTableViewCell else { return UITableViewCell() }
        
        return cell
    }
    
    
}
