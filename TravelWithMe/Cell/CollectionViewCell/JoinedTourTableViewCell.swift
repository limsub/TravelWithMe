//
//  JoinedTourTableViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/8/23.
//

import UIKit
import SkeletonView

class JoinedTourTableViewCell: BaseTableViewCell {
    
    let dateLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.text = "1st"
        view.textColor = .lightGray
        return view
    }()
    
    // 샘플 사이즈 = 10
    let dotView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 3
        view.backgroundColor = UIColor.appColor(.main1)
        return view
    }()
    let topLineView = {
        let view = UIView()
        view.backgroundColor = UIColor.appColor(.main2)
        return view
    }()
    let bottomLineView = {
        let view = UIView()
        view.backgroundColor = UIColor.appColor(.main2)
        return view
    }()
    
    let backImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.isSkeletonable = true
        return view
    }()
    let imageButton = {
        let view = UIButton()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    let tourTitleLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .boldSystemFont(ofSize: 18)
        view.text = "투어 제목"
        return view
    }()
    let tourMakerLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 14)
        view.text = "투어 제작자"
        return view
    }()
    let reviewButton = ReviewButton()
    
    
    override func setConfigure() {
        super.setConfigure()
        
        [dateLabel, topLineView, bottomLineView, dotView, backImageView, imageButton, tourTitleLabel, tourMakerLabel, reviewButton].forEach { item in
            contentView.addSubview(item)
//            item.backgroundColor = [.red, .blue, .black, .purple].randomElement()!
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(24)
            make.top.equalTo(contentView).inset(26)
            make.width.equalTo(36)
        }
        dotView.snp.makeConstraints { make in
            make.size.equalTo(6)
            make.leading.equalTo(dateLabel.snp.trailing).offset(12)
            make.centerY.equalTo(dateLabel)
        }
        topLineView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.centerX.equalTo(dotView)
            make.bottom.equalTo(dotView.snp.centerY)
            make.width.equalTo(1)
        }
        bottomLineView.snp.makeConstraints { make in
            make.top.equalTo(dotView.snp.centerY)
            make.centerX.equalTo(dotView)
            make.bottom.equalTo(contentView)
            make.width.equalTo(1)
        }
        
        backImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(dotView.snp.centerX).offset(14)
            make.height.equalTo(130)    // 셀 높이 140으로 맞출 예정
            make.trailing.equalTo(contentView).inset(18)
        }
        imageButton.snp.makeConstraints { make in
            make.edges.equalTo(backImageView)
        }
        
        tourTitleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(backImageView).inset(20)
        }
        tourMakerLabel.snp.makeConstraints { make in
            make.top.equalTo(tourTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(tourTitleLabel)
        }
        
        reviewButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(90)
            make.trailing.bottom.equalTo(backImageView).inset(12)
        }
    }
    
    override func setting() {
        super.setting()
        
        
    }
    
    func setUp(_ sender: Datum, pos: TopMiddleBottom) {
        
        // 1. dateLabel
        if let firstDateString = decodingStringToStruct(type: TourDates.self, sender: sender.dates)?.dates.first, let firstDateDayString = firstDateString.toDate(to: .full)?.toString(of: .day), let firstDateDayInt = Int(firstDateDayString) {
            
            var text = firstDateDayString
            let suffix: String
            switch firstDateDayInt % 10 {
            case 1:
                suffix = "st"
            case 2:
                suffix = "nd"
            case 3:
                suffix = "rd"
            default:
                suffix = "th"
            }
            text += suffix
            
            dateLabel.text = text
        }
        
        // 2. top / bottom line
        topLineView.isHidden = (pos == .top) ? true : false
        bottomLineView.isHidden = (pos == .bottom) ? true : false
        
        
        // 3. backImageView
        if !sender.image.isEmpty {
            let imageEndString = sender.image[0]
            backImageView.loadImage(endURLString: imageEndString)
        } else {
            print("이미지 없으면 기본 이미지 띄워주기. 이거 만들어야 함 - 2")
        }
        
        
        // 4. tourTitleLabel
        tourTitleLabel.text = sender.title ?? ""
        
        
        // 5. tourMakerLabel
        tourMakerLabel.text = sender.creator.nick
        
        
        // 6. reviewButton
        // * firstDate과 lastDate 뽑아내기 (.full string)
        guard let datesStruct = decodingStringToStruct(type: TourDates.self, sender: sender.dates), let firstDateString = datesStruct.dates.first, let lastDateString = datesStruct.dates.last else { return }
        let todayDateString = Date().toString(of: .full)
        
        // 오늘 날짜 기반으로 후기 버튼 디자인
        if todayDateString < firstDateString {
            reviewButton.update(.beforeTravel)
        } else if todayDateString >= firstDateString && todayDateString <= lastDateString {
            reviewButton.update(.duringTravel)
        } else if todayDateString > lastDateString && !checkAlreadyReviewed() {
            reviewButton.update(.writeReview)
        } else {
            reviewButton.update(.checkReview)
        }
    }
    
    // sender.comments가 현재 어떤 식인지 잘 모르겠다. 여기에 KeychainStorage.shared.id가 포함되어 있으면 이미 후기를 작성했다고 간주하고, true를 반환한다
    func checkAlreadyReviewed() -> Bool {
        
        return true
    }
}



