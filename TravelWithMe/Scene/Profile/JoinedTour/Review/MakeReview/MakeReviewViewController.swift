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
    
    var delegate: ReloadJoinedTourTableViewProtocol?
    
    
    override func loadView() {
        self.view = mainView
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingCategoryButtons()
        bind()
    }
    
    
    func settingCategoryButtons() {
        
        for (index, item) in mainView.reviewCategoryButtons.enumerated() {
            
            item.rx.tap
                .subscribe(with: self) { owner , _ in
                    do {
                        var arr = try owner.viewModel.selectedButtonIndex.value()
                        
                        if !item.isSelected {
                            if arr.count < 3 {
                                item.isSelected = true
                                
                                arr.append(index)
                                arr.sort()
                                owner.viewModel.selectedButtonIndex.onNext(arr)
                            }
                        }
                        else {
                            item.isSelected = false
                            arr = arr.filter { $0 != index }
                            arr.sort()
                            owner.viewModel.selectedButtonIndex.onNext(arr)
                        }
                        
                    } catch {
                        print("에러났슈")
                    }
                }
                .disposed(by: disposeBag)
        }
    
    }
    
    func bind() {
        let input = MakeReviewViewModel.Input(
            reviewTextViewText: mainView.writingReviewTextView.rx.text.orEmpty,
            completeButtonClicked: mainView.completeButton.rx.tap
        )
        
        let output = viewModel.tranform(input)
        
        output.resultCompleteButtonClicked
            .subscribe(with: self) { owner, value in
                print("-- (VC) 결과 전달 받음")
                switch value {
                case .success(let result):
                    print("-- (VC) 성공! 화면 뒤로 백 해주고, 이전 화면 JoinedTourReload indexPath reload")
                    owner.delegate?.reloadItem(indexPath: owner.viewModel.tourItemIndexPath)
                    owner.navigationController?.popViewController(animated: true)
                default:
                    print("-- (VC) 실패! 아직 예외처리 안했다. 추후 예정")
                }
                
            }
        
        
        output.enabledCompleteButton
            .subscribe(with: self) { owner , value in
                

                owner.mainView.completeButton.update(
                    value ? .enabled : .disabled
                )
                
            }
            .disposed(by: disposeBag)
        
    }
}
