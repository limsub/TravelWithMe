//
//  ProfileViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/29.
//

import UIKit
import Tabman
import Pageboy

class ProfileViewController: TabmanViewController {
    
    let profileView = ProfileTopView()
    let viewModel = ProfileViewModel()
    
    let myTourVC = MyTourViewController()
    let joinedTourVC = JoinedTourViewController()
    let profileInfoVC = ProfileInfoViewController()
    
    
    private lazy var VCs = [myTourVC, joinedTourVC, profileInfoVC]
    
    let customBarView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setConfigure()
        setConstraints()
        
        fetchProfileInfo()
        
//        view.backgroundColor = .white
        
        settingCustomBarView()
        settingTabman()
    }
    
    // BaseVC를 상속하지 않아서, 따로 만든다
    func setConfigure() {
        view.addSubview(profileView)
        view.addSubview(customBarView)
    }
    func setConstraints() {
        profileView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view)
            make.height.equalTo(220)
        }
        customBarView.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom)
            make.horizontalEdges.equalTo(view).inset(18)
            make.height.equalTo(50)
        }
    }
    
    
    
    // 1. profileView 적용. 2. profileInfoVC의 뷰모델에 전달
    func fetchProfileInfo() {

        viewModel.fetchData { [weak self] response  in
            switch response {
            case .success(let result):
                
                /* == 프로필 관련 (topView, infoVC) 데이터는 여기서 정리해서 뷰에 반영한다 ==*/
                print("프로필 정보 뷰에 반영")
//                print(result)
                // 1. 내 프로필
                if self?.viewModel.userType == .me {
                    print("- 내 프로필")
                    self?.settingDataProfileTopView(result, userType: .me)
                }
                // 2. 남 프로필
                else {
                    print("- 남 프로필")
                    self?.viewModel.checkFollowOrNot(result._id, completionHandler: { value in
                        if value {
                            print("애 팔로우 함")
                            self?.settingDataProfileTopView(result, userType: .other(userId: result._id, isFollowing: true))
                            
                        } else {
                            print("얘 팔로우 안함")
                            self?.settingDataProfileTopView(result, userType: .other(userId: result._id, isFollowing: false))
                            
                        }
                    })
                    
                }
                
                // info View는 받는 데이터가 동일하다
                self?.settingDataProfileInfoView(result)
                
            case .failure(let error):
                // 1. 공통 에러
                if let commonError = error as? CommonAPIError {
                    print("-- 공통 에러")
                    return
                }
                
                // 2. 프로필 조회 에러
                if let lookProfileError = error as? LookProfileAPIError {
                    print("-- 프로필 조회 에러")
                    return
                }
                
                // 3. 토큰 관련 에러
                if let refreshTokenError = error as? RefreshTokenAPIError {
                    print("-- 토큰 관련 에러")
                    return
                }
                
                // 4. 알 수 없음
                print("-- 알 수 없는 에러")
            }
        }
    }
    
    // topView는 직접 업데이트, infoVC에는 VM에 전달 후, infoVC 업데이트 실행
    func settingDataProfileTopView(_ result: LookProfileResponse, userType: UserType) {
        // 얘가 profileTopView임
        profileView.updateProfileTopView(result, userType: userType)
    }
    func settingDataProfileInfoView(_ result: LookProfileResponse) {
        profileInfoVC.viewModel.profileInfoData = result
        profileInfoVC.updateView()
    }
    
    
    func settingCustomBarView() {
        customBarView.backgroundColor = .purple
    }
    
    func settingTabman() {
        self.dataSource = self
        
        let bar = TMBar.ButtonBar()
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .leading
        bar.layout.contentMode = .intrinsic
        bar.layout.interButtonSpacing = 20
        bar.backgroundView.style = .clear
        bar.indicator.overscrollBehavior = .none
        bar.indicator.tintColor = UIColor.appColor(.main1)
//        bar.indicator.weight = .custom(value: 1)
        bar.indicator.weight = .light
//        bar.indicator.cornerStyle = .square
        bar.indicator.cornerStyle = .rounded
        bar.buttons.customize { button in
            button.tintColor = .lightGray
            button.selectedTintColor = UIColor.appColor(.main1)
        }
        bar.spacing = CGFloat(4)
        
        bar.backgroundColor = .white
        
        addBar(bar, dataSource: self, at: .custom(view: customBarView, layout: nil))
    }

}

extension ProfileViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return VCs.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return VCs[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "만든거")
        case 1:
            return TMBarItem(title: "신청한거")
        case 2:
            return TMBarItem(title: "정보")
        default:
            return TMBarItem(title: "")
        }
    }
}

