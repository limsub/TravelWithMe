//
//  DetailTourViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import UIKit

class DetailTourViewController: BaseViewController {
    
    let mainView = DetailTourView()
    
    let viewModel = DetailTourViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("뷰모델 데이터 : \(viewModel.tourItem)")
        
        setSwipeImageCollectionViewDataSource()
        
        settingNavigation()
        
        settingMainView()
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
