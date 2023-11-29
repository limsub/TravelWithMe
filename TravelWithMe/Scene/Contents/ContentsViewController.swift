//
//  TourListViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit
import RxSwift
import RxCocoa

class ContentsViewController: BaseViewController {
    
    let mainView = ContentsView()
    let viewModel = ContentsViewModel()
    
    let disposeBag = DisposeBag()
    
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        
        let input = ContentsViewModel.Input(a: "hi")
        
        let output = viewModel.tranform(input)
        
        // 데이터 로딩할 때마다, 토스트 메세지 띄워주기
        // - 데이터 로딩에 성공했습니다
        // - 데이터 로딩에 실패했습니다 - 에러 :
        
        
        // 1. items에 테이블뷰 엮어두기
        output.tourItems
            .bind(to: mainView.tourCollectionView.rx.items(cellIdentifier: "ContentsView - tourCollectionView", cellType: AboutTourCollectionViewCell.self)) { (row, element, cell) in
                
                
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
                                }
                            
                            
                        }
                        
                    

                    }
                    .disposed(by: cell.disposeBag)
    
            }
            .disposed(by: disposeBag)
    
       
    }
}
