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
        
        settingNavigation()
        settingCategoryButtons()
        bind()
        
        settingView()
    }
    
    func settingNavigation() {
        navigationItem.title = "후기 작성"
    }
    
    func settingView() {
        guard let tourItem = viewModel.tourItem else  { return }
        mainView.tourView.setUp(tourItem)
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
                case .success(_):
                    print("(MakeReview) 네트워크 응답 성공!")
                    print("1. 화면 popView  2. 이전 화면 reloadItem")
                    
                    owner.delegate?.reloadItem()
                    owner.navigationController?.popViewController(animated: true)
                    
                case .commonError(let error):
                    print("(MakeReview) 네트워크 응답 실패 - 공통 에러")
                    owner.showAPIErrorAlert(error.description)
                    
                case .makeReviewError(let error):
                    print("(MakeReview) 네트워크 응답 실패 - 후기 작성 에러")
                    owner.showAPIErrorAlert(error.description)
                    
                case .refreshTokenError(let error):
                    print("(MakeReview) 네트워크 응답 실패 - 토큰 에러")
                    if error == .refreshTokenExpired {
                        print("- 리프레시 토큰 만료!")
                        owner.goToLoginViewController()
                    } else {
                        owner.showAPIErrorAlert(error.description)
                    }
                }
                
            }
            .disposed(by: disposeBag)
        
        
        output.enabledCompleteButton
            .subscribe(with: self) { owner , value in
                

                owner.mainView.completeButton.update(
                    value ? .enabled : .disabled
                )
                
            }
            .disposed(by: disposeBag)
        
    }
}
