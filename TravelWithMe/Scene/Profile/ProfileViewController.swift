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
    
    // 1. profileView 적용. 2. profileInfoVC의 뷰모델에 전달 적용
    func fetchProfileInfo() {
        
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
            return TMBarItem(title: "나의 여행")
        case 1:
            return TMBarItem(title: "예정된 여행")
        case 2:
            return TMBarItem(title: "정보")
        default:
            return TMBarItem(title: "")
        }
    }
}

