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
        
        settingCategoryButtons()
        bind()
    }
    
    func settingCategoryButtons() {
        
//        mainView.categoryButtons[3].rx.tap
//            .subscribe(with: self) { owner , value in
//                owner.mainView.categoryButtons[0].isSelected = false
//                
//                owner.mainView.categoryButtons[3].isSelected = true
//                
//                //                owner.mainView.categoryButtons[3].rx.isSelected.onNext(true)
//                //
//                //                owner.mainView.categoryButtons[0].rx.isSelected.onNext(false)
//                //            }
//            }
//            .disposed(by: disposeBag)
//        
//        mainView.categoryButtons[5].rx.tap
//            .subscribe(with: self) { owner , value in
//                owner.mainView.categoryButtons[1].isSelected = true
//                
//                owner.mainView.categoryButtons[5].isSelected = true
//                
//                //                owner.mainView.categoryButtons[3].rx.isSelected.onNext(true)
//                //
//                //                owner.mainView.categoryButtons[0].rx.isSelected.onNext(false)
//                //            }
//            }
//            .disposed(by: disposeBag)
//        
//        mainView.categoryButtons[3].rx.isSelected.onNext(false)
//        
//        mainView.categoryButtons[0].isSelected = true
        
        
        // ----
//        mainView.categoryButtons[3].isSelected = false
        
        for (index, item) in mainView.categoryButtons.enumerated() {
            item.rx.tap
                .subscribe(with: self) { owner , _ in
                    // false -> tap -> true
                    if !item.isSelected {
                        // 1. 해당 버튼 isSelected true
//                        item.isSelected = true
                        item.rx.isSelected.onNext(true)
                        
//                        owner.mainView.categoryButtons[0].isSelected = false
                        
                        // 2. 다른 버튼 isSelected false
                        for (i, button) in owner.mainView.categoryButtons.enumerated() {
                            if (i == index) { continue }
                            
                            print("다른\(i) 버튼 false 처리해주기")
                            
//                            button.isSelected = false
                            
                            owner.mainView.categoryButtons[i].rx.isSelected.onNext(false)
//                            button.rx.isSelected.onNext(false)
                        }
                    }
                    
                    // true -> tap -> x
                }
                .disposed(by: disposeBag)
        }
        
        // 뷰가 처음 나올 때 "전체" 버튼만 isSelected true
//        mainView.categoryButtons[0].isSelected = true
    }
    
    func bind() {
        
//        let input = ContentsViewModel.Input(
//            categoryButtons: mainView.categoryButtons.map { $0.rx.isSelected }
//        )
        
        let input = ContentsViewModel.Input(
            categoryButtons: [],
            categoryButton1: mainView.categoryButtons[0].rx.tap,
            categoryButton2: mainView.categoryButtons[1].rx.isSelected,
            categoryButton3: mainView.categoryButtons[2].rx.isSelected,
            categoryButton4: mainView.categoryButtons[3].rx.isSelected
        )
        
        let output = viewModel.tranform(input)
        
        // 데이터 로딩할 때마다, 토스트 메세지 띄워주기
        // - 데이터 로딩에 성공했습니다
        // - 데이터 로딩에 실패했습니다 - 에러 :
        
        
        // 1. items에 테이블뷰 엮어두기
        output.tourItems
            .bind(to: mainView.tourCollectionView.rx.items(cellIdentifier: "ContentsView - tourCollectionView", cellType: AboutTourCollectionViewCell.self)) { (row, element, cell) in
                
                
                cell.designCell(element)
                
                cell.disabledMenuButton()
            }
            .disposed(by: disposeBag)
    
       
    }
}
