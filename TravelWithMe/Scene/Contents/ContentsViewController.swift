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
        
        settingNavigation()
        settingCategoryButtons()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func settingNavigation() {
        navigationItem.title = "Travel With Me"
        navigationItem.largeTitleDisplayMode = .always
    }
    
    func settingCategoryButtons() {
        
        // 버튼의 탭에 bind로 버튼 별 isSelected 값 넣어주기
        // (-> (클릭하지 않은 버튼에 대해) UI 적으로는 작동되지만, rx 이벤트 방출은 안된다)
        // 여기선 단순 UI 작동 용. Input을 위한 값은 아래 bind 함수에서 결정한다
        // *** 컬렉션뷰 스크롤 맨 위로 올려주기!!!
        for (index, item) in mainView.categoryButtons.enumerated() {
            item.rx.tap
                .subscribe(with: self) { owner , _ in
                    // false -> tap -> true
                    if !item.isSelected {
                        // 1. 해당 버튼 isSelected true
                        item.isSelected = true
                        
                        // 2. 다른 버튼 isSelected false
                        for (i, button) in owner.mainView.categoryButtons.enumerated() {
                            if (i == index) { continue }
                            button.isSelected = false
                        }
                    }
                    
                    // true -> tap -> x
                    
                    // 컬렉션뷰 스크롤 맨 위로 올려주기
                    owner.mainView.tourCollectionView.setContentOffset(.zero, animated: true)
                    
                    
//                    owner.mainView.tourCollectionView.setContentOffset(CGPoint(x: 0, y: 50), animated: true)
                    
                    
                }
                .disposed(by: disposeBag)
        }
        
        // 뷰가 처음 나올 때 "전체" 버튼만 isSelected true
        mainView.categoryButtons[0].isSelected = true
    }
    
    func bind() {
        
        // 어떤 카테고리로 검색할지 이벤트 발생. (초기값 all)
        // 1.
        let searchCategory = BehaviorSubject(value: TourCategoryType.all)
        
        let searchedButtonIdx = BehaviorSubject(value: 0)
        
        // 2. 카테고리 버튼 클릭 시, 인덱스만 먼저 이벤트 전달
        for (index, button) in mainView.categoryButtons.enumerated() {
            button.rx.tap
                .subscribe(with: self) { owner , _ in
                    searchedButtonIdx.onNext(index)
                }
                .disposed(by: disposeBag)
        }
        
        // 3. 인덱스에 대한 이벤트 발생 시, 값이 변했다면 카테고리 값 변경
        searchedButtonIdx
            .distinctUntilChanged()
            .subscribe(with: self) { owner , value in
                // enum의 rawValue 활용
                searchCategory.onNext(
                    TourCategoryType(rawValue: value) ??  TourCategoryType.all
                )
            }
            .disposed(by: disposeBag)
        
        // 4. searchCategory를 Input으로 넣어서, 다른 버튼 클릭 시 네트워크 새로 요총
        
        let input = ContentsViewModel.Input(
            searchCategory: searchCategory,
            itemSelected: mainView.tourCollectionView.rx.itemSelected,
            prefetchItem: mainView.tourCollectionView.rx.prefetchItems,
            refreshControlValueChanged: mainView.tourRefreshControl.rx.controlEvent(.valueChanged)
        )
    
    
        
        let output = viewModel.tranform(input)
        
        // 데이터 로딩할 때마다, 토스트 메세지 띄워주기
        // - 데이터 로딩에 성공했습니다
        // - 데이터 로딩에 실패했습니다 - 에러 :
        
        
        // 1. items에 컬렉션뷰 엮어두기
        output.tourItems
            .bind(to: mainView.tourCollectionView.rx.items(cellIdentifier: "ContentsView - tourCollectionView", cellType: AboutTourCollectionViewCell.self)) { (row, element, cell) in
                
//                print("------------------")
//                print(element)
                
                cell.designCell(element)
                
                cell.disabledMenuButton()
            }
            .disposed(by: disposeBag)
        
        output.itemSelected
            .withLatestFrom(output.nextTourInfo)
            .subscribe(with: self) { owner , value in
                let vc = DetailTourViewController()
                vc.viewModel.tourItem = value
                vc.viewModel.tourItemsDelegate1 = owner.viewModel
//                vc.viewModel.wholeContentsViewModel = owner.viewModel
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        
        // 리프레시가 끝나는 시점을 잡아줌
        output.refreshLoading
            .bind(to: mainView.tourRefreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    
    
}
