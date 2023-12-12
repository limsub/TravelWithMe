//
//  ReviewSmallTourView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import UIKit

class ReviewSmallTourView: BaseView {
    
    let tourImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.image = UIImage(named: "sample")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let tourNameLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 14)
        view.textColor = .black
        view.text = "제주의 비밀, 자연 속으로의 숨은 여정"
        view.numberOfLines = 2
        return view
    }()
    
    let tourMaxPeopleView = {
        let view = ContentsTourInfoView()
        view.infoLabel.textColor = UIColor.appColor(.gray1)
        view.setUp(.maxPeople(cnt: 3))
        return view
    }()
    
    let tourDatesView = {
        let view = ContentsTourInfoView()
        view.infoLabel.textColor = UIColor.appColor(.gray1)
        view.setUp(.tourDates(dates: ["20231010", "20240102"]))
        return view
    }()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [tourImageView, tourNameLabel, tourMaxPeopleView, tourDatesView].forEach { item in
            addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tourImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(self).inset(5)
            make.width.equalTo(tourImageView.snp.height)
        }
        
        tourNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(tourImageView.snp.trailing).offset(15)
            make.top.equalTo(self).inset(10)
            make.trailing.equalTo(self).inset(15)
        }
        
        tourMaxPeopleView.snp.makeConstraints { make in
            make.leading.equalTo(tourImageView.snp.trailing).offset(15)
            make.bottom.equalTo(self).inset(20)
        }
        
        tourDatesView.snp.makeConstraints { make in
            make.leading.equalTo(tourMaxPeopleView.snp.trailing).offset(10)
            make.centerY.equalTo(tourMaxPeopleView)
        }
        
        
    }
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = .white
        
        self.layer.cornerRadius = 20

        self.layer.shadowOpacity = 0.5
        self.layer.shadowColor = UIColor.appColor(.main2).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
    }
    
    func setUp(_ sender: Datum) {
        // 1. imageView
        if !sender.image.isEmpty {
            let imageEndString = sender.image[0]
            tourImageView.loadImage(endURLString: imageEndString)
        } else {
            print("===== 이미지 배열이 비어서 보여줄 썸네일이 없다!!")
        }
        
        // 2. tourTitle
        tourNameLabel.text = sender.title ?? ""
        
        // 3. tourMaxPeopleView
        let maxCnt = Int(sender.maxPeopleCnt ?? "0") ?? 0
        tourMaxPeopleView.setUp(.maxPeople(cnt: maxCnt))
        
        // 4. tourDateView
        let dates = decodingStringToStruct(
            type: TourDates.self,
            sender: sender.dates
        )
        tourDatesView.setUp(.tourDates(dates: dates?.dates ?? []))
    }
    
    
}
