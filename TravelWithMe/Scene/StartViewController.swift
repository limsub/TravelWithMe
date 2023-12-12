//
//  StartViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/21.
//

import UIKit


class StartViewController: BaseViewController {
    
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    let button4 = UIButton()
    let button5 = UIButton()
    let button6 = UIButton()
    let button7 = UIButton()
    let button8 = UIButton()
    let button9 = UIButton()
    
    let a = {
        let view = ContentsProfileImageView(frame: .zero)
        view.loadImage(endURLString: "hihi")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KeychainStorage.shared.printTokens()
        
   
        
        [button1, button2, button3, button4, button5, button6, button7, button8, button9, a].forEach { item in
            view.addSubview(item)
            item.backgroundColor = .gray
        }
        button1.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
        button2.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalTo(view)
            make.top.equalTo(button1.snp.bottom).offset(50)
        }
        button3.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalTo(view)
            make.top.equalTo(button2.snp.bottom).offset(50)
        }
        button4.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalTo(view)
            make.top.equalTo(button3.snp.bottom).offset(50)
        }
        button5.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalTo(view)
            make.top.equalTo(button4.snp.bottom).offset(50)
        }
        button6.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalTo(view)
            make.top.equalTo(button5.snp.bottom).offset(50)
        }
        
        button7.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.leading.equalTo(button1.snp.trailing).offset(20)
            make.top.equalTo(button1)
        }
        button8.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.leading.equalTo(button7)
            make.top.equalTo(button7.snp.bottom).offset(50)
        }
        button9.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.leading.equalTo(button8)
            make.top.equalTo(button8.snp.bottom).offset(50)
        }
        a.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(60)
            make.leading.equalTo(button9)
            make.top.equalTo(button9.snp.bottom).offset(50)
        }
        print("0000000")
        
        print(a.frame.width)
        print(a.frame.height)
        
        button1.addTarget(self, action: #selector(button1Clicked), for: .touchUpInside)
        button2.addTarget(self, action: #selector(button2Clicked), for: .touchUpInside)
        button3.addTarget(self, action: #selector(button3Clicked), for: .touchUpInside)
        button4.addTarget(self, action: #selector(button4Clicked), for: .touchUpInside)
        button5.addTarget(self , action: #selector(button5Clicked), for: .touchUpInside)
        button6.addTarget(self , action: #selector(button6Clicked), for: .touchUpInside)
        button7.addTarget(self , action: #selector(button7Clicked), for: .touchUpInside)
        button8.addTarget(self , action: #selector(button8Clicked), for: .touchUpInside)
        button9.addTarget(self, action: #selector(button9Clicked), for: .touchUpInside)
        
    }
    
    @objc
    func button1Clicked() {
        print("hi")
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    func button2Clicked() {
        let vc = MakeTourViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    func button3Clicked() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    func button4Clicked() {
        let vc = ContentsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    func button5Clicked() {
        let vc = ProfileViewController()
        navigationController?.pushViewController(vc , animated: true)
    }
    @objc
    func button6Clicked() {
        let vc = SelectLocationViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    func button7Clicked() {
        let vc = MakeReviewViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    func button8Clicked() {
        let vc = CheckReviewViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc
    func button9Clicked() {
        let vc = ModifyProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
