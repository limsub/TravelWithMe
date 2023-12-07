//
//  ApplicantView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/7/23.
//

import UIKit
import RxSwift
import RxCocoa

class ApplicantView: BaseView {
    
    let mainLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 20)
        view.text = "신청 현황 1/3"
        return view
    }()
    
    let applicantCollectionView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    let closeButton = {
        let view = UIButton()
        view.backgroundColor = .blue
        return view
    }()
    
    
    
    override func setConfigure() {
        super.setConfigure()
        
        backgroundColor = .white
        
        [mainLabel, applicantCollectionView, closeButton].forEach { item  in
            addSubview(item)
        }
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(self).inset(25)
            make.leading.equalTo(self).inset(20)
        }
        
        applicantCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(self).inset(15)
        }
        
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(applicantCollectionView.snp.bottom).offset(15)
            make.horizontalEdges.bottom.equalTo(self).inset(15)
            make.height.equalTo(52)
        }
    }
}
