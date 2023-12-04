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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KeychainStorage.shared.printTokens()
        
   
        
        [button1, button2, button3, button4, button5, button6].forEach { item in
            view.addSubview(item)
            item.backgroundColor = .gray
        }
        button1.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(50)
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
        
        button1.addTarget(self, action: #selector(button1Clicked), for: .touchUpInside)
        button2.addTarget(self, action: #selector(button2Clicked), for: .touchUpInside)
        button3.addTarget(self, action: #selector(button3Clicked), for: .touchUpInside)
        button4.addTarget(self, action: #selector(button4Clicked), for: .touchUpInside)
        button5.addTarget(self , action: #selector(button5Clicked), for: .touchUpInside)
        button6.addTarget(self , action: #selector(button6Clicked), for: .touchUpInside)
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
        let vc = DetailTourViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
