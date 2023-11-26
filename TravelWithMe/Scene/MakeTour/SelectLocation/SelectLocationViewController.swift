//
//  SelectLocationViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/26.
//

import UIKit

class SelectLocationViewController: BaseViewController {
    
    var delegate: SelectTourLocationDelegate?
    
    let button = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        button.backgroundColor = .red
        view.addSubview(button)
        button.snp.makeConstraints { make in
            make.size.equalTo(300)
            make.center.equalTo(view)
        }
        
        button.addTarget(self , action: #selector(clicked), for: .touchUpInside)
    }
    
    @objc
    func clicked() {
        delegate?.sendLocation?(name: "하이", latitude: 1.2, longitude: 1.2)
    }
}
