//
//  ProfileInfoViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import UIKit

class ProfileInfoViewController: BaseViewController {
    
    let mainView = ProfileInfoView()
    let viewModel = ProfileInfoViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        mainView.backgroundColor = .blue
        
            
        settingFollowCollectionView()
        updateView()
    }
    
    func settingFollowCollectionView() {
        mainView.followerCollectionView.delegate = self
        mainView.followerCollectionView.dataSource = self
        
        mainView.followingCollectionView.delegate = self
        mainView.followingCollectionView.dataSource = self
    }
    
    func updateView() {
//        print("-----------------")
//        print(viewModel.profileInfoData)
        // 뷰모델의 데이터를 기반으로 뷰 새로 그리기
        mainView.updateView(viewModel.profileInfoData)
        
        // 컬렉션뷰 2개 reload
        mainView.followerCollectionView.reloadData()
        mainView.followingCollectionView.reloadData()
        
    }
}


extension ProfileInfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func checkFollowerCollectionView(_ collectionView: UICollectionView) -> Bool {
        // 팔로워 : true
        // 팔로잉 : false
        return collectionView == mainView.followerCollectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if checkFollowerCollectionView(collectionView) {
            // 팔로워
            return viewModel.profileInfoData.followers.count
//            return 12  viewModel.profileInfoData.followers.count
            
        } else {
            // 팔로잉
            return viewModel.profileInfoData.following.count
//            return 8  viewModel.profileInfoData.following.count
            
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if checkFollowerCollectionView(collectionView) {
            // 팔로워
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.profileInfoFollowerCollectionView.rawValue, for: indexPath) as? ProfileInfoFollowCollectionViewCell else { return UICollectionViewCell() }
            
            cell.designCell(viewModel.profileInfoData.followers[indexPath.item])
            
            return cell
        } else {
            // 팔로잉
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.profileInfoFollowingCollectionView.rawValue, for: indexPath) as? ProfileInfoFollowCollectionViewCell else { return UICollectionViewCell()}
            
            cell.designCell(viewModel.profileInfoData.following[indexPath.item])
            
            return cell
        }
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
     
        let vc = ProfileViewController()
        if checkFollowerCollectionView(collectionView) {
            print("팔로워 프로필 화면으로 이동. 내 프로필인지 남 프로필인지 체크")
            let userId = viewModel.profileInfoData.followers[indexPath.item]._id
            
            if userId == KeychainStorage.shared._id {
                print("-> 내 프로필 화면으로 이동")
                vc.viewModel.userType = .me
                navigationController?.pushViewController(vc, animated: true)
            } else {
                print("-> 남 프로필 화면으로 이동")
                vc.viewModel.userType = .other(
                    userId: userId, isFollowing: false
                )
                navigationController?.pushViewController(vc, animated: true)
            }
            
        } else {
            print("팔로잉 프로필 화면으로 이동. 내 프로필인지 남 프로필인지 체크")
            let userId = viewModel.profileInfoData.following[indexPath.item]._id
            
            if userId == KeychainStorage.shared._id {
                print("-> 내 프로필 화면으로 이동")
                vc.viewModel.userType = .me
                navigationController?.pushViewController(vc, animated: true)
            } else {
                print("-> 남 프로필 화면으로 이동")
                vc.viewModel.userType = .other(
                    userId: userId, isFollowing: false
                )
                navigationController?.pushViewController(vc, animated: true)
            }
            
        }
    }
}
