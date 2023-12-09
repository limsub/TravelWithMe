//
//  MakeReviewViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import UIKit
import RxSwift
import RxCocoa

class MakeReviewViewController: BaseViewController {
    
    let mainView = MakeReviewView()
    let viewModel = MakeReviewViewModel()
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
        mainView.reviewCategoryButtons.forEach { item in
            item.rx.tap
                .subscribe(with: self) { owner , _ in

                    if (!item.isSelected) {
                        if  (owner.viewModel.selectedButtonCnt < 3)  {
                            // 선택
                            item.isSelected = true
                            owner.viewModel.selectedButtonCnt += 1
                        }
                    }
                    else {
                        // 선택 해제
                        item.isSelected = false
                        owner.viewModel.selectedButtonCnt -= 1
                    }
                    
                    print(owner.viewModel.selectedButtonCnt)
                    
                }
                .disposed(by: disposeBag)
        }
    }
    
    func bind() {
        let input = MakeReviewViewModel.Input(
            reviewCategoryButtons: mainView.reviewCategoryButtons.map { $0.rx.isSelected },
            completeButtonClicked: mainView.completeButton.rx.tap
        )
        
        let output = viewModel.tranform(input)
        
        
    }
}
