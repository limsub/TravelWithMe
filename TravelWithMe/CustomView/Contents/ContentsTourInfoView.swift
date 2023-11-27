//
//  ContentsTourInfoView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit
import SnapKit

enum TourInfoType {
    case maxPeople(cnt: Int)
    case tourDates(dates: [String])
    
    var imageName: String {
        switch self {
        case .maxPeople:
            return "person"
        case .tourDates:
            return "calendar"
        }
    }
    
    var infoLabelText: String {
        switch self {
        case .maxPeople(let cnt):
            return "최대 \(cnt)명"
        case .tourDates(let dates):
            // 말도 안되지만, 배열이 비었을 때 예외처리 (index OutofBounds 대비)
            if dates.isEmpty { return "" }
            
            guard let firstDate = dates[0].toDate(to: .full)?.toString(of: .monthSlashDay) else { return "" }
            
            if dates.count == 1 {
                return firstDate
            } else {
                return firstDate + " 외 \(dates.count - 1)일"
            }
        }
    }
}

class ContentsTourInfoView: BaseView {
    
    func setUp(_ info: TourInfoType) {
        imageView.image = UIImage(systemName: info.imageName)
        infoLabel.text = info.infoLabelText
    }
    
    let imageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person")
        return view
    }()
    
    let infoLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        view.text = "최대 3명"
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
//        self.backgroundColor = .purple
        
        [imageView, infoLabel].forEach { item  in
            addSubview(item)
        }
    }
    
    // 뷰 height 20으로 고정
    override func setConstraints() {
        super.setConstraints()
        
        imageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(self)
            make.width.equalTo(imageView.snp.height)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.centerY.equalTo(self)
            make.trailing.equalTo(self)
        }
    }
}
