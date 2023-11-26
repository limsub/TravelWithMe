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
        
        // 여행 일자와 여행 장소 다른 뷰컨에서 받아오는 건 (버튼 탭) Input으로 넣지 말고, 일단 Rx Delegate Pattern만 이용하자.
        
        selectDatesLocation()
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
    
    func selectDatesLocation() {
        
        // 여행 날짜
        mainView.tourDatesView.button.addTarget(self , action: #selector(dateButtonClicked), for: .touchUpInside)
        
        // 여행 장소
        mainView.tourLocationView.button.addTarget(self , action: #selector(locationButtonClicked), for: .touchUpInside)
        
    }
    
    @objc
    func dateButtonClicked() {
        let vc = SelectDateViewController()
        vc.rx.checkTourDates
            .subscribe(with: self) { owner , value in
                print("선택한 날짜 : ", value)
            }
            .disposed(by: disposeBag)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func locationButtonClicked() {
        let vc = SelectLocationViewController()
        vc.rx.checkTourLocation
            .subscribe(with: self) { owner , value in
                print("선택한 장소 : ", value)
            }
            .disposed(by: disposeBag)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
