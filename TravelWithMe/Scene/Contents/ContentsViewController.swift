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
        
        output.sampleItems
            .bind(to: mainView.tourCollectionView.rx.items(cellIdentifier: "ContentsView - tourCollectionView", cellType: AboutTourCollectionViewCell.self)) { (row, element, cell) in
                
                print("hiih")
//                cell.backgroundColor = .purple
                
                cell.designCell()
            }
            .disposed(by: disposeBag)
    }
}
