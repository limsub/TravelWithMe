//
//  ProfileViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/29.
//

import UIKit
import Tabman
import Pageboy

protocol RetryNetworkAndUpdateView {
    func reload()
}

class ProfileViewController: TabmanViewController {
    
    // 탭바에서 바로 보는 프로필 화면 -> 설정 버튼을 달아준다
    var fromTabBar = false
    
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
        

        settingTabman()
        
        settingDataTabman()
        settingModifyButtonAction()
        settingSettingButtonAction()
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
                print("네트워크 응답 성공!")
                
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
                            self?.viewModel.userType = UserType.other(userId: result._id, isFollowing: true)
                            self?.settingDataProfileTopView(result, userType: self?.viewModel.userType ?? .me)
                            
                        } else {
                            print("얘 팔로우 안함")
                            self?.viewModel.userType = UserType.other(userId: result._id, isFollowing: false)
                            self?.settingDataProfileTopView(result, userType: self?.viewModel.userType ?? .me)
                            
                        }
                    })
                    
                }
                
                // info View는 받는 데이터가 동일하다
                self?.settingDataProfileInfoView(result)
                
                // myTourView에 데이터 새로 로드되게 하기
                self?.settingDataMyTourView(result)
                
            case .failure(let error):
                // 1. 공통 에러
                if let commonError = error as? CommonAPIError {
                    print("네트워크 응답 실패! - 공통 에러")
                    self?.showAPIErrorAlert(commonError.description)
                    return
                }
                
                // 2. 프로필 조회 에러
                if let lookProfileError = error as? LookProfileAPIError {
                    print("네트워크 응답 실패! - 프로필 조회 에러")
                    self?.showAPIErrorAlert(lookProfileError.description)
                    return
                }
                
                // 3. 토큰 관련 에러
                if let refreshTokenError = error as? RefreshTokenAPIError {
                    print("네트워크 응답 실패! - 토큰 에러")
                    if refreshTokenError == .refreshTokenExpired {
                        print("- 리프레시 토큰 만료!!")
                        self?.goToLoginViewController()
                    } else {
                        self?.showAPIErrorAlert(refreshTokenError.description)
                    }
                    
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
        profileView.updateProfileTopView(result, userType: userType, fromTabBar: fromTabBar)
    }
    
    func settingDataProfileInfoView(_ result: LookProfileResponse) {
        profileInfoVC.viewModel.profileInfoData = result
        profileInfoVC.updateView()
    }
    
    func settingDataMyTourView(_ result: LookProfileResponse) {
        let pastId = myTourVC.viewModel.userId
        myTourVC.viewModel.userId = result._id
        myTourVC.viewModel.nextCursor.onNext("")
//        // myTourVC의 viewDidLoad가 아니라, 여기서 bind 함수를 실행시킨다!
        if pastId == "" { myTourVC.bind() }
    }
    
    func settingDataTabman() {
        
        if viewModel.userType != .me {
            VCs = VCs.filter { $0 != joinedTourVC }
            
            self.reloadData()
        }
    }
    
    func settingModifyButtonAction() {
        profileView.modifyButton.addTarget(self, action: #selector(modifyButtonClicked), for: .touchUpInside)
    }
    @objc
    func modifyButtonClicked() {
        print("버튼 클릭")
        print("현재 유저 타입 : \(viewModel.userType)")
        
        switch viewModel.userType {
        case .me:
            print("수정하기 기능 넣어주기")
            let vc = ModifyProfileViewController()
            vc.viewModel.profileInfo = viewModel.profileData
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
            
        case .other(let _, let isFollowing):
            // 네트워크 통신
            viewModel.followOrUnfollow(
                follow: !isFollowing) { response in
                    
                    // 네트워크 콜 성공했다면 (200)
                    // 프로필 정보에 대한 콜을 다시 해서 뷰를 한 번에 업데이트하자
                    // 1. viewModel의 userType 바꿔주기
                    // (func fetchProfileInfo)
                    // 2. viewModel의 profileData의 follower에 내 아이디 추가하기
                    // (func fetchProfileInfo - viewModel.fetchData)
                    // 3. modifyButton update 해주기
                    // (func fetchProfileInfo - settingDataProfileTopView)
                    
                    switch response {
                    case .success(_):
                        print("네트워크 응답 성공!")
                        print("팔로우/언팔로우 네트워크 통신 성공. 프로필 정보 불러오는 네트워크 재통신 및 뷰 업데이트")
                        self.fetchProfileInfo()
                    case .failure(let error):
                        // 1. 공통 에러
                        if let commonError = error as? CommonAPIError {
                            print("네트워크 응답 실패! - 공통 에러")
                            self.showAPIErrorAlert(commonError.description)
                            return
                        }
                        
                        // 2. 팔로우 에러
                        if let followError = error as? FollowAPIError {
                            print("네트워크 응답 실패! - 팔로우 에러")
                            self.showAPIErrorAlert(followError.description)
                            return
                        }
                        
                        // 3. 언팔로우 에러
                        if let unfollowError = error as? UnFollowAPIError {
                            print("네트워크 응답 실패! - 언팔로우 에러")
                            self.showAPIErrorAlert(unfollowError.description)
                            return
                        }
                        
                        // 4. 토큰 관련 에러
                        if let refreshTokenError = error as? RefreshTokenAPIError {
                            print("네트워크 응답 실패! - 토큰 에러")
                            if refreshTokenError == .refreshTokenExpired {
                                print("- 리프레시 토큰 만료!!")
                                self.goToLoginViewController()
                            } else {
                                self.showAPIErrorAlert(refreshTokenError.description)
                            }
                            return
                        }
                        
                        // 4. 알 수 없음
                        print("네트워크 응답 실패! - 알 수 없는 에러")
                        self.showAPIErrorAlert(error.localizedDescription)
                    }
                    
                }
            
        
            
        }
        
        
    }
    
    
    lazy var settingButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "trash.circle", withConfiguration: imageConfig)
        
        let view = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(settingButtonClicked))
        
        view.tintColor = .white
        return view
    }()
    
    func settingSettingButtonAction() {
        navigationItem.rightBarButtonItem = settingButton
        navigationItem.rightBarButtonItem?.isHidden = !fromTabBar
    }
    @objc
    func settingButtonClicked() {
        print("hhi")
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func settingTabman() {
        self.dataSource = self
        
        view.backgroundColor = .white
        
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
        
        if viewModel.userType == .me {
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
            
        } else {
            switch index {
            case 0:
                return TMBarItem(title: "만든거")
            case 1:
                return TMBarItem(title: "정보")
            default:
                return TMBarItem(title: "")
            }
        }
        
        
    }
}

extension ProfileViewController: RetryNetworkAndUpdateView {
    func reload() {
        self.fetchProfileInfo()
    }
}
