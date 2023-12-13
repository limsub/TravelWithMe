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
        
        
        bind()
    }
    


    
    func bind() {
        let input = MyTourViewModel.Input(
            a: "hi",
            itemSelected: mainView.myTourCollectionView.rx.itemSelected,
            prefetchItem: mainView.myTourCollectionView.rx.prefetchItems
        )
        let output = viewModel.tranform(input)
        
        // 1. items
        output.myTourItems
            .bind(to: mainView.myTourCollectionView.rx.items(cellIdentifier: "ProfileMyTourView - tourCollectionView", cellType: AboutTourCollectionViewCell.self)) { (row, element, cell) in
                
                print("---")
                
                cell.designCell(element)
                
                
                cell.menuButton.rx.tap
                    .subscribe(with: self) { owner, _ in
                        owner.showActionSheet(nil, message: nil, firstTitle: "게시글 수정", secondTitle: "게시글 삭제") {
                            print("게시글 수정하기")
                            print(element.id)
                            
                            
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
                                        print("게시글 삭제 성공")
                                        print(result)
                                        
                                        // 현재 뷰모델에서 가지고 있는 배열에 손을 대자
                                        self.viewModel.deleteItem(result)
                                        

                                    case .failure(let error):
                                        print("게시글 삭제 실패")
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
    }
}

