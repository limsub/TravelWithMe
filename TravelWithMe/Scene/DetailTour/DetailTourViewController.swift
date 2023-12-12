//
//  DetailTourViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import UIKit
import RxSwift
import RxCocoa

class DetailTourViewController: BaseViewController {
    
    let mainView = DetailTourView()
    
    let viewModel = DetailTourViewModel()
    
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("뷰모델 데이터 - 상세 투어 정보 : \(viewModel.tourItem)")
//        print("기존 화면의 뷰모델 데이터 - 전체 투어 정보 : \(try! viewModel.wholeContentsViewModel?.tourItems.value())")
        
        setSwipeImageCollectionViewDataSource()
        
        settingNavigation()
        
        settingMainView()
        
        bind()
        
        print(viewModel.tourItem.location)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    func setSwipeImageCollectionViewDataSource() {
        mainView.swipeImagesCollectionView.dataSource = self
        mainView.swipeImagesCollectionView.delegate = self
        
        mainView.tourCategoryCollectionView.dataSource = self
    }
    
    func settingNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    func settingMainView() {
        mainView.setUp(viewModel.tourItem)
    }
    
    func bind() {
        let input = DetailTourViewModel.Input(
            applyButtonClicked: mainView.bottomView.applyButton.rx.tap,
            goToProfileButtonClicked: mainView.goToProfileButton.rx.tap
        )
        
        let output = viewModel.tranform(input)
        
        // 1. 여행 제작자 프로필 화면으로 이동
        output.goToProfileButtonClicked
            .subscribe(with: self) { owner , _ in
                print("프로필 화면으로 이동. 나의 프로필인지 남의 프로필인지 체크")
                
                if owner.viewModel.tourItem.creator._id == KeychainStorage.shared._id {
                    print(" -> 나의 프로필 화면으로 이동합니다")
                    let vc = ProfileViewController()
                    vc.viewModel.userType = .me
                    owner.navigationController?.pushViewController(vc, animated: true)
                    
                } else {
                    let vc = ProfileViewController()
                    vc.viewModel.userType = .other(userId: owner.viewModel.tourItem.creator._id, isFollowing: false)
                    // (isFollowing: false) 일단 모르니까 false로 전달하고, DetailView에서 직접 네트워크 콜 해서 확인할 예정
                    owner.navigationController?.pushViewController(vc, animated: true)
                    print(" -> 남의 프로필 화면으로 이동합니다")
                }
                
//                let vc = ProfileViewController()
//                owner.navigationController?.pushViewController(vc, animated: true)
                
            }
            .disposed(by: disposeBag)
        
        
        // 2. 좋아요 기능 구현
        output.resultApplyTour
            .subscribe(with: self) { owner , value in
                print(value)
                
                switch value {
                case .sucees(result: let result):
                    // 1. 성공
                    // 버튼 카운트 업데이트
                    owner.mainView.setUpBottomApplyButton(sender: owner.viewModel.tourItem)
                    
                default:
                    print("에러났슴당")
                }
                
                
                
                // 2. 실패
                // 얼럿 띄워주기
                
                
                
            }
            .disposed(by: disposeBag)
        // (1). 네트워크 쏘기
        
        
        
        // (2). ContentsVC에서 물고있는 데이터 변경해주기
        
        

    }
    

}

extension DetailTourViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case mainView.swipeImagesCollectionView:
            return viewModel.tourItem.image.count
            
        case mainView.tourCategoryCollectionView:
            return viewModel.tourItem.hashTags.count
            
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case mainView.swipeImagesCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailTourView - DetailTourSwipeImageCollectionViewCell", for: indexPath) as? DetailTourSwipeImageCollectionViewCell else { return UICollectionViewCell() }
            
            
            cell.mainImageView.image = UIImage(named: "sample")
            
            cell.mainImageView.loadImage(endURLString: viewModel.tourItem.image[indexPath.item])
            
            return cell
            
        case mainView.tourCategoryCollectionView:
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"DetailTourView - DetailTourCategoryCollectionViewCell", for: indexPath) as? DetailTourCategoryCollectionViewCell else { return UICollectionViewCell() }
            
            cell.mainLabel.text = viewModel.tourItem.hashTags[indexPath.item]
                
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    
    // paging control
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print(#function)
        
        
        let nextPage = Int(targetContentOffset.pointee.x / self.view.frame.width)
        
        mainView.swipeImagesPageControl.currentPage = nextPage
    }
    
}
