//
//  MakeReviewViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import UIKit
import RxSwift
import RxCocoa


enum MakeOrModifyReview {
    case make
    case modify
    
    var navigationTitle: String {
        switch self {
        case .make:
            return "후기 작성"
        case .modify:
            return "후기 수정"
        }
    }
    
    var completionButtonTitle: String {
        switch self {
        case .make:
            return "후기 작성 완료"
        case .modify:
            return "후기 수정 완료"
        }
    }
}


class MakeReviewViewController: BaseViewController {
    
    // 유입 경로
    // 1. 후기 작성하기
    // 2. 후기 수정하기 -> 초기 데이터를 값전달로 받는다
    var type: MakeOrModifyReview = .make
    
    let mainView = MakeReviewView()
    let viewModel = MakeReviewViewModel()
    let disposeBag = DisposeBag()
    
    weak var delegate: ReloadJoinedTourTableViewProtocol?
    
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        settingCategoryButtons()
        bind()
        
        settingView()
        settingViewByType()
        
        setInitData()
    }
    

    func settingView() {
        guard let tourItem = viewModel.tourItem else  { return }
        mainView.tourView.setUp(tourItem)
    }
    
    func settingViewByType() {
        navigationItem.title = type.navigationTitle
        mainView.completeButton.setTitle(type.completionButtonTitle, for: .normal)
    }
    
    func setInitData() {
        print("type : \(type)")
        print("initData : \(viewModel.initData)")
        
        if type == .make { return }
        guard let data = viewModel.initData else { return }
        guard let reviewStruct = decodingStringToStruct(type: ReviewContent.self, sender: data.content) else { return }
        
        // 1. 카테고리 버튼
        reviewStruct.categoryArr.forEach { index in
            mainView.reviewCategoryButtons[index].sendActions(for: .touchUpInside)
            mainView.reviewCategoryButtons[index].rx.isSelected.onNext(true)
        }
        
        // 2. 후기 텍스트
        mainView.writingReviewTextView.text = reviewStruct.content
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
                // * 후기 작성
                // 1. 화면 popView
                // 2. 전 화면 (JoinedTour) reload - delegate
                
                
                // * 후기 수정
                // 1. 화면 popView
                // 2. 전 화면 (CheckReview) 뷰모델 접근해서 데이터 직접 수정(VM) + tableView reload (이건 그냥 viewWillAppear에서 tableView reload 찍어주자)
                // 3. 전전 화면 (JoinedTour) reload - delegate
                

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
                    
                case .modifyReviewError(error: let error):
                    print("(MakeReview) 네트워크 응답 실패 - 후기 수정 에러")
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
