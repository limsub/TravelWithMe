//
//  MakingTourViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit
import RxSwift
import RxCocoa

class MakeTourViewController: BaseViewController {

    let mainView = MakeTourView()
    let viewModel = MakeTourViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        RouterAPIManager.shared.request(
//            type: makePostResponse.self,
//            error: makePostAPIError.self,
//            api: .makePost(sender: makePostRequest(title: "테스트 타이틀", content: "테스트 컨텐츠", tourDates: "20230919", tourLocations: "위도, 경도", locationName: "영등포캠퍼스", maxPeopleCnt: "5", tourPrice: "30000")
//)
//        )
        
        bind()
    }
    
    
    func bind() {
        
//        let input = MakeTourViewModel.Input(
//            tap: mainView.testButton.rx.tap
//        )
//
//        let output = viewModel.tranform(input)
//
//        output.tap
//            .subscribe(with: self) { owner , _ in
//                print("탭 뷰컨")
//            }
//            .disposed(by: disposeBag)
//
        

    }

}
