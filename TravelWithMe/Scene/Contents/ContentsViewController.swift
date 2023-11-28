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
    
            }
            .disposed(by: disposeBag)
    
       
    }
}
