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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        KeychainStorage.shared.printTokens()
        
        
        [button1, button2, button3, button4].forEach { item in
            view.addSubview(item)
            item.backgroundColor = .gray
        }
        button1.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.equalTo(view)
            make.top.equalTo(view).inset(50)
        }
        button2.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.equalTo(view)
            make.top.equalTo(button1.snp.bottom).offset(50)
        }
        button3.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.equalTo(view)
            make.top.equalTo(button2.snp.bottom).offset(50)
        }
        button4.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.centerX.equalTo(view)
            make.top.equalTo(button3.snp.bottom).offset(50)
        }
        
        button1.addTarget(self, action: #selector(button1Clicked), for: .touchUpInside)
        button2.addTarget(self, action: #selector(button2Clicked), for: .touchUpInside)
        button3.addTarget(self, action: #selector(button3Clicked), for: .touchUpInside)
        button4.addTarget(self, action: #selector(button4Clicked), for: .touchUpInside)
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
        let vc = SelectDateViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

}
