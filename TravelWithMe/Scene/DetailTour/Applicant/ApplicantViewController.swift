//
//  ApplicantViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/7/23.
//

import UIKit

class ApplicantViewController: BaseViewController {
    
    let smallView = ApplicantView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(smallView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        smallView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view).inset(18)
            make.top.equalTo(view).inset(200)
            make.bottom.equalTo(view).inset(250)
        }
    }
}
