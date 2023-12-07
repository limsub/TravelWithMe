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
        
        print("뷰모델 데이터 : \(viewModel.tourItem)")
        
        setSwipeImageCollectionViewDataSource()
        
        settingNavigation()
        
        settingMainView()
        
        bind()
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
                let vc = ProfileViewController()
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        // 2. 좋아요 기능 구현
        
        

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
