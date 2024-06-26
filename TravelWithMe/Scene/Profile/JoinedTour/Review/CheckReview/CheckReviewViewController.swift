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
    
    weak var delegate: ReloadJoinedTourTableViewProtocol?
    
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingNavigation()
        settingTableView()
        settingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.checkReviewTableView.reloadData()
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
        
        cell.menuButtonCallBackMethod = { [weak self] in
            
            self?.showActionSheet(nil, message: nil, firstTitle: "후기 수정", secondTitle: "후기 삭제", firstCompletionHandler: {
                print("후기 수정")
                                
                // 후기 확인하는 창의 데이터는 값전달로 받아옴. 네트워크 콜 x. 그래서 reload를 할 수가 없음
                // 1. 그래서 직접 viewModel에 접근해서 값을 바꿔버리고, 뷰를 다시 그리는 방법으로 구현하기
                // 2. 또한, 결국 JoinedTour는 reload를 해줘야 하기 때문에 MakeReview에서 전전화면을 reload하게 함. 즉, delegate를 그대로 전달시킴
                
                
                // 화면 전환!!
                let vc = MakeReviewViewController()
                vc.viewModel.tourItem = self?.viewModel.tourItem
                vc.type = .modify
                // 1.
                vc.viewModel.initData = commentItem
                vc.viewModel.checkReviewData = self?.viewModel
                // 2.
                vc.delegate = self?.delegate
                self?.navigationController?.pushViewController(vc, animated: true)
                
                // 1. 네트워크 콜
                
                // 2. (200) viewModel 데이터 수정
                
                // 3. (200) collectionView reload
                
                // 4. (200) 이전 화면 (JoinedTour) reload
                
                
            }, secondCompletionHandler: {
                
                print("후기 삭제")
                
                // 1. 네트워크 콜
                self?.viewModel.deleteReview(indexPath: indexPath) { response  in
                    switch response {
                    case .success(_):
                        print("(후기 삭제) 네트워크 응답 성공")
                        self?.mainView.checkReviewTableView.performBatchUpdates({
                            // 2. (200) viewModel의 데이터 삭제
                            self?.viewModel.tourItem?.comments.remove(at: indexPath.item)
                            
                            // 3. (200) collectionView deleteItem
                            self?.mainView.checkReviewTableView.deleteRows(at: [IndexPath(row: indexPath.item, section: 0)], with: .automatic)
                        })

                        // 4. (200) 이전 화면 (JoinedTour) reload
                        self?.delegate?.reloadItem()
                        
                    case .failure(let error):
                        print("(후기 삭제) 네트워크 응답 실패")
                        
                        // 1. 공통 에러
                        if let commonError = error as? CommonAPIError {
                            print("(후기 삭제) 네트워크 응답 실패 - 공통 에러")
                            self?.showAPIErrorAlert(commonError.description)
                        }
                        
                        // 2. 댓글 삭제 에러
                        if let deleteReviewError = error as? DeleteReviewAPIError {
                            print("(후기 삭제) 네트워크 응답 실패 - 댓글 삭제 에러")
                            self?.showAPIErrorAlert(deleteReviewError.description)
                        }
                        
                        // 3. 토큰 에러
                        if let refreshTokenError = error as? RefreshTokenAPIError {
                            print("(후기 삭제) 네트워크 응답 실패 - 토큰 에러")
                            if refreshTokenError == .refreshTokenExpired {
                                print("- 리프레시 토큰 만료!!")
                                self?.goToLoginViewController()
                            } else {
                                self?.showAPIErrorAlert(refreshTokenError.description)
                            }
                        }
                        
                        // 4. 알 수 없는 에러
                        print("(후기 삭제) 알 수 없는 에러")
                        self?.showAPIErrorAlert(error.localizedDescription)
                    }
                }
                
            })
        }
        
        return cell
    }
}

