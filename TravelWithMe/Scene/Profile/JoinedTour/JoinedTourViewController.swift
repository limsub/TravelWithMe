//
//  JoinedTourViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import UIKit

protocol ReloadJoinedTourTableViewProtocol {
    func reloadItem()
}

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
        
        headerView.setUp(viewModel.items[section].month)

        return headerView
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileJoinedTourView - JoinedTourTableView", for: indexPath) as? JoinedTourTableViewCell else { return UITableViewCell() }
        
        let tourItem = viewModel.items[indexPath.section].tours[indexPath.item]
        
        if indexPath.item == 0 {
            
            if viewModel.items[indexPath.section].tours.count == 1 {
                cell.setUp(tourItem, pos: .single)
            } else {
                cell.setUp(tourItem, pos: .top)
            }
            
            
        }
        else if indexPath.item == viewModel.items[indexPath.section].tours.count - 1 {
            cell.setUp(tourItem, pos: .bottom)
        }
        else {
            cell.setUp(tourItem, pos: .middle)
        }
        
        cell.reviewButtonCallBackMethod = { [weak self] in
            
            print("이미 후기를 작성했는가 : \(self?.checkAlreadyReviewed((tourItem.comments)))")
            
            
            
            // 1. 후기 확인 화면
            guard let self else { return }
            if self.checkAlreadyReviewed(tourItem.comments) {
                print("이미 후기를 작성했습니다. 후기 확인 화면으로 전환합니다")
                
                let vc = CheckReviewViewController()
                vc.viewModel.tourItem = tourItem
                navigationController?.pushViewController(vc, animated: true)
                
            }
            
            // 2. 후기 작성 화면
            else {
                print("아직 후기를 작성하지 않았습니다. 후기 작성 화면으로 전환합니다")
                
                let vc = MakeReviewViewController()
                vc.viewModel.tourItem = tourItem
//                vc.viewModel.tourItemIndexPath = indexPath
                vc.delegate = self
                navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
        
        
        
        
//        cell.tourTitleLabel.text = viewModel.items[indexPath.section].tours[indexPath.item].title
        
        return cell
    }
    
    // [Comment] 배열에 현재 사용자의 id(KeychainStorage.shared._id) 가 있는지 확인. 있으면 true
    func checkAlreadyReviewed(_ sender: [Comment]) -> Bool {
        
        return sender.contains { comment in
            comment.creator._id == KeychainStorage.shared._id
        }
    }
}


extension JoinedTourViewController: ReloadJoinedTourTableViewProtocol {
    // 원래 reloadItem을 하려고 했는데, 어차피 네트워크 통신이 이루어지지 않기 때문에 여기서는 데이터의 변화가 없다
    // 그냥 네트워크 통신을 새로 받는 걸로 한다
    
    func reloadItem() {
        callRequest()
    }
    
    
}
