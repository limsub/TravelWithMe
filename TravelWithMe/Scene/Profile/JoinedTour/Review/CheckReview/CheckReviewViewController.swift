//
//  CheckReviewViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/10/23.
//

import UIKit

class CheckReviewViewController: BaseViewController {
    
    let mainView = CheckReviewView()
    
    let viewModel = CheckReviewViewModel()
    
    
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingNavigation()
        settingTableView()
        settingView()
    }
    
    func settingNavigation() {
        navigationItem.title = "후기 확인"
    }
    
    func settingTableView() {
        mainView.checkReviewTableView.delegate = self
        mainView.checkReviewTableView.dataSource = self
    }
    
    func settingView() {
        if let tourItem = viewModel.tourItem {
            mainView.tourView.setUp(tourItem)
        }
    }
    
}

extension CheckReviewViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.tourItem?.comments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.checkReviewTableView.rawValue, for: indexPath) as? CheckReviewTableViewCell else { return UITableViewCell() }
        
        guard let commentItem = viewModel.tourItem?.comments[indexPath.row] else { return UITableViewCell() }
        
        cell.designCell(commentItem)
        
        return cell
    }
    
    
}
