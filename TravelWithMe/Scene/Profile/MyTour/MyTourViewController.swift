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
        
        
//        bind()
        settingMyTourCollectionView()
    }
    
    func settingMyTourCollectionView() {
        mainView.myTourCollectionView.dataSource = self
        mainView.myTourCollectionView.delegate = self
    }
    

    
    func bind() {
        let input = MyTourViewModel.Input(a: "hi")
        let output = viewModel.tranform(input) 
        
        // 1. items
//        output.myTourItems
//            .bind(to: mainView.myTourCollectionView.rx.items(cellIdentifier: "ProfileMyTourView - tourCollectionView", cellType: AboutTourCollectionViewCell.self)) { (row, element, cell) in
//                
//                print("---")
//                
//                cell.designCell(element)
//                
//                
//                cell.menuButton.rx.tap
//                    .subscribe(with: self) { owner, _ in
//                        owner.showActionSheet(nil, message: nil, firstTitle: "게시글 수정", secondTitle: "게시글 삭제") {
//                            print("게시글 수정하기")
//                            print(element.id)
//                            
//                            
//                        } secondCompletionHandler: {
//                            print("게시글 삭제하기")
//                            print(element.id)
//                            
//                            
//                            RouterAPIManager.shared.requestNormal(
//                                type: DeletePostRespose.self ,
//                                error: DeletePostAPIError.self ,
//                                api: .deletePost(idStruct: DeletePostRequest(id: element.id))) { response  in
//                                    print(response)
//                                    
//                                    switch response {
//                                    case .success(let result):
//                                        print("게시글 삭제 성공")
//                                        
//                                     
//                                    case .failure(let error):
//                                        print("게시글 삭제 실패")
//                                    }
//                                }
//                            
//                            
//                        }
//                        
//                    
//
//                    }
//                    .disposed(by: cell.disposeBag)
//                
//            }
//            .disposed(by: disposeBag)
    }
}

extension MyTourViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.tourItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileMyTourView - tourCollectionView", for: indexPath) as?  AboutTourCollectionViewCell else { return UICollectionViewCell() }
        
        cell.designCell(viewModel.tourItems[indexPath.item])
        
        cell.menuCallBackMethod = { [weak self] in
            
            self?.showActionSheet(
                nil, message: nil, firstTitle: "게시글 수정", secondTitle: "게시글 삭제",
                firstCompletionHandler: {
                    print("게시글 수정하기")
                    
                }, secondCompletionHandler: {
                    print("게시글 삭제하기")
                    
                    RouterAPIManager.shared.requestNormal(
                        type: DeletePostRespose.self,
                        error: DeletePostAPIError.self,
                        api: .deletePost(idStruct: DeletePostRequest(id: self?.viewModel.tourItems[indexPath.item].id ?? ""))) { response in
                            
                            print(response)
                            
                            switch response {
                            case .success(let result):
                                print("게시글 삭제 성공")
                                
                            case .failure(let error):
                                print("게시글 삭제 실패")
                            }
                        }
                    
                })
            
            
        }
        
        return cell
    }
    
    
}
