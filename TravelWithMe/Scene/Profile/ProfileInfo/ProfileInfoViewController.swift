//
//  ProfileInfoViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import UIKit

class ProfileInfoViewController: BaseViewController {
    
    let mainView = ProfileInfoView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        mainView.backgroundColor = .blue
        
        
        RouterAPIManager.shared.requestNormal(
            type: LookProfileResponse.self,
            error: LookProfileAPIError.self,
            api: .lookMyProfile) { response in
                print(" * === 프로필 조회 === * ")
                print(response)
            }
        
        settingFollowCollectionView()
    }
    
    func settingFollowCollectionView() {
        mainView.followerCollectionView.delegate = self
        mainView.followerCollectionView.dataSource = self
        
        mainView.followingCollectionView.delegate = self
        mainView.followingCollectionView.dataSource = self
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
            return 8
            
        } else {
            // 팔로잉
            return 12
            
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if checkFollowerCollectionView(collectionView) {
            // 팔로워
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.profileInfoFollowerCollectionView.rawValue, for: indexPath) as? ProfileInfoFollowCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        } else {
            // 팔로잉
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.profileInfoFollowingCollectionView.rawValue, for: indexPath) as? ProfileInfoFollowCollectionViewCell else { return UICollectionViewCell()}
            
            return cell
        }
        
        
        
    }
    
    
    
}
