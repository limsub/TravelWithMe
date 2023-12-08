//
//  JoinedTourViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import UIKit

class JoinedTourViewController: BaseViewController {
    
    let matrix = [[Int]](repeating: [Int](repeating: 0, count: 10), count: 4)
    
    let viewModel = JoinedTourViewModel()
    
    let mainView = JoinedTourView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView()
        callRequest()
    }
    
    
    func settingTableView() {
        mainView.joinedTourTableView.delegate = self
        mainView.joinedTourTableView.dataSource = self
    }
    
    func callRequest() {
        viewModel.fetchData { response in
            switch response {
            case .success(_):
                self.mainView.joinedTourTableView.reloadData()
                
            case .failure(let error):
                // 1. 공통 에러
                if let commonError = error as? CommonAPIError {
                    print("-- 공통 에러")
                    return
                }
                
                // 2. 게시글 조회 에러
                if let lookPostError = error as? LookPostAPIError {
                    print("-- 게시글 조회 에러")
                    return
                }
                
                // 3. 토큰 관련 에러
                if let refreshTokenError = error as? RefreshTokenAPIError {
                    print("-- 토큰 관련 에러")
                    return
                    
                }
                
                // 4. 알 수 없음
                print("-- 알 수 없음")
                return
            }
        }
    }
}


extension JoinedTourViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items[section].tours.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = JoinedTourTableViewHeaderView()
        
        headerView.monthLabel.text = viewModel.items[section].month
        
//        headerView.monthLabel.text = "\(Int.random(in: 1...100)) 하이"
        
        return headerView
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileJoinedTourView - JoinedTourTableView", for: indexPath) as? JoinedTourTableViewCell else { return UITableViewCell() }
        
        cell.tourTitleLabel.text = viewModel.items[indexPath.section].tours[indexPath.item].title
        
        return cell
    }
    
    
    
    
}
