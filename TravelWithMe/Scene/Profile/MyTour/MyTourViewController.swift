//
//  MyTourViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/30.
//

import UIKit
import RxSwift
import RxCocoa


class MyTourViewController: BaseViewController {
    
    let mainView = MyTourView()
    let viewModel = MyTourViewModel()
    let disposeBag = DisposeBag()
    

    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 무작정 bind를 해버리면 아직 viewModel.userId를 값전달로 받지 못했기 때문에 에러가 발생한다
        // 상위 뷰컨(ProfileVC)에서 값 전달이 완료된 후 bind 함수를 실행시킨다
//        bind()
    }
    
    func bind() {
        let input = MyTourViewModel.Input(
            a: "hi",
            itemSelected: mainView.myTourCollectionView.rx.itemSelected,
            prefetchItem: mainView.myTourCollectionView.rx.prefetchItems,
            refreshControlValueChanged: mainView.myTourRefreshControl.rx.controlEvent(.valueChanged)
        )
        let output = viewModel.tranform(input)
        
        // 1. items
        output.myTourItems
            .bind(to: mainView.myTourCollectionView.rx.items(cellIdentifier: "ProfileMyTourView - tourCollectionView", cellType: AboutTourCollectionViewCell.self)) { (row, element, cell) in
                
                cell.designCell(element)
                
                if self.viewModel.userId != KeychainStorage.shared._id {
                    cell.disabledMenuButton()
                }
                
                cell.menuButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        owner.showActionSheet(nil, message: nil, firstTitle: "게시글 수정", secondTitle: "게시글 삭제") {
                            print("게시글 수정하기")
//                            print(element.id)
                            print(element)
                            
                            
                            // 만약 신청한 사람이 있다면, 게시글 수정은 불가능하다
                            if !element.likes.isEmpty {
                                self.showSingleAlert("수정 불가", message: "이미 신청한 사람이 있는 여행 컨텐츠는 수정할 수 없습니다") {
                                    print("hi")
                                }
                                return
                            }
                            
                            
                            let vc = MakeTourViewController()
                            vc.delegate = self
                            vc.type = .modify
                            vc.viewModel.initData = element
                            owner.navigationController?.pushViewController(vc, animated: true)
                            
                            
                        } secondCompletionHandler: {
                            print("게시글 삭제하기")
                            print(element.id)
                            
                            
                            RouterAPIManager.shared.requestNormal(
                                type: DeletePostRespose.self ,
                                error: DeletePostAPIError.self ,
                                api: .deletePost(idStruct: DeletePostRequest(id: element.id))) { response  in
                                    print(response)
                                    
                                    switch response {
                                    case .success(let result):
                                        print("(게시글 삭제) 성공")
                                        print("배열의 요소 삭제. rx이기 때문에 알아서 뷰 업데이트")
                                        // 현재 뷰모델에서 가지고 있는 배열에 손을 대자
                                        self.viewModel.deleteItem(result)
                                        
                                    case .failure(let error):
                                        if let commonError = error as? CommonAPIError {
                                            print("(게시글 삭제) 네트워크 응답 실패! - 공통 에러")
                                            owner.showAPIErrorAlert(commonError.description)
                                        }
                                        
                                        if let deletePostError = error as? DeletePostAPIError {
                                            print("(게시글 삭제) 네트워크 응답 실패! - 게시글 삭제 에러")
                                            owner.showAPIErrorAlert(deletePostError.description)
                                        }
                                        
                                        if let refreshTokenError = error as? RefreshTokenAPIError {
                                            print("(게시글 삭제) 네트워크 응답 실패! - 토큰 에러")
                                            if refreshTokenError == .refreshTokenExpired {
                                                print("-- 리프레시 토큰 만료!!")
                                                owner.goToLoginViewController()
                                            } else {
                                                owner.showAPIErrorAlert(refreshTokenError.description)
                                            }
                                        }
                                        
                                        // 4. 알 수 없음
                                        print("(게시글 삭제) 네트워크 응답 실패! - 알 수 없는 에러")
                                        owner.showAPIErrorAlert(error.localizedDescription)
                                    }
                                }
                            
                            
                        }
                        
                    

                    }
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        
        output.itemSelected
            .withLatestFrom(output.nextTourInfo)
            .subscribe(with: self) { owner , value in
                let vc = DetailTourViewController()
                vc.viewModel.tourItem = value
                vc.viewModel.tourItemsDelegate1 = owner.viewModel
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 리프레시가 끝나는 시점을 잡아줌
        output.refreshLoading
            .bind(to: mainView.myTourRefreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        
        // result
        output.resultLookPost
            .subscribe(with: self) { owner , response  in
                switch response {
                case .success(_):
                    print("(만든 게시글 조회) 네트워크 응답 성공!")
                case .commonError(let error):
                    print("(만든 게시글 조회) 네트워크 응답 실패! - 공통 에러")
                    owner.showAPIErrorAlert(error.description)
                case .lookPostError(let error):
                    print("(만든 게시글 조회) 네트워크 응답 실패! - 내가 작성한 게시글 조회 에러")
                    owner.showAPIErrorAlert(error.description)
                case .refreshTokenError(let error):
                    print("(만든 게시글 조회) 네트워크 응답 실패! - 토큰 에러")
                    if error == .refreshTokenExpired {
                        print("- 리프레시 토큰 만료!")
                        owner.goToLoginViewController()
                    } else {
                        owner.showAPIErrorAlert(error.description)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

extension MyTourViewController: ReloadContentsView {
    func reload() {
        viewModel.nextCursor.onNext("")
        
        mainView.myTourCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
}
