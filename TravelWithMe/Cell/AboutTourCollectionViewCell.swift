//
//  AboutTourCollectionViewCell.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/27.
//

import UIKit
import SnapKit
import Kingfisher
import SkeletonView

class AboutTourCollectionViewCell: BaseCollectionViewCell {
    
    // 이미지 뷰 얹고, 코너레디우스 주기. 굳이 패딩 안줘도 될듯
    let backImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.image = UIImage(named: "sample")
//        view.backgroundColor = .systemGray6
        
        view.isSkeletonable = true
        
        return view
    }()
    let shadowView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.layer.cornerCurve = .continuous
        view.backgroundColor = .black.withAlphaComponent(0.5)
        return view
    }()
    
    let tourTitleLabel = {
        let view = UILabel()
        
//        view.backgroundColor = .purple
        view.font = .boldSystemFont(ofSize: 20)
        view.textColor = .white
        view.text = "3박 4일 도쿄 여행 같이 가실분sadjfl;kjasd;lfkjas;dlfkja;slkdfja;sldkjf"
        view.numberOfLines = 2
        return view
    }()
    
    let profileNameLabel = {
        let view = UILabel()
//        view.backgroundColor = .purple
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        view.text = "임승섭입니다"
        
        return view
    }()
    
    let lineView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let maxPeopleView = ContentsTourInfoView()
    let tourDatesView = ContentsTourInfoView()
    
    let profileImageView = ContentsProfileImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    
    override func setConfigure() {
        super.setConfigure()
        
        
        [backImageView, shadowView, maxPeopleView, tourDatesView, profileImageView, profileNameLabel, lineView, tourTitleLabel].forEach { item  in
            contentView.addSubview(item)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        backImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        shadowView.snp.makeConstraints { make in
            make.edges.equalTo(backImageView)
        }
        
        maxPeopleView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(15)
            make.leading.equalTo(contentView).inset(15)
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
        
        tourDatesView.snp.makeConstraints { make in
            make.leading.equalTo(maxPeopleView.snp.trailing).offset(20)
            make.height.equalTo(30)
            make.bottom.equalTo(contentView).inset(15)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).inset(15)
            make.trailing.equalTo(contentView).inset(15)
            make.size.equalTo(54)
        }
        
        profileNameLabel.snp.makeConstraints { make in
            make.bottom.equalTo(maxPeopleView.snp.top).offset(-12)
            make.leading.equalTo(maxPeopleView)
        }
        
        lineView.snp.makeConstraints { make in
            make.trailing.equalTo(profileImageView.snp.leading).inset(2)
            make.leading.equalTo(profileNameLabel.snp.trailing).offset(8)
            make.centerY.equalTo(profileNameLabel)
            make.height.equalTo(1)
        }
        
        tourTitleLabel.snp.makeConstraints { make in
            make.bottom.equalTo(profileNameLabel.snp.top).offset(-12)
            make.leading.equalTo(maxPeopleView)
            make.trailing.equalTo(profileImageView)
        }
    }
    
    
    func designCell(_ sender: Datum) {
        
//        let url = URL(string: "http://lslp.sesac.kr:27820/uploads/posts/1701081002540.jpeg")
//        
//        var urlRequest = URLRequest(url: url!)
//        
//        urlRequest.method = .get
//        urlRequest.headers = [
//            "Authorization": KeychainStorage.shared.accessToken ?? "",
//            "SesacKey": SeSACAPI.subKey
//        ]
//        
//        backImageView.af.setImage(withURLRequest: urlRequest)
//        
        
        
        // 1. 배경 이미지 (아직)
        if !sender.image.isEmpty {
//            let url = URL(string: SeSACAPI.baseURL + sender.image[0])
            
            let imageURL = sender.image[0]
            
            print("--- 이미지 캐싱 확인 ---")
            let cacheKey = NSString(string: imageURL)
            if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                print("-- 캐싱된 이미지")
                self.backImageView.image = cachedImage
            } else {
                print("-- 캐싱되지 않은 이미지")
                print(" * 스켈레톤 뷰 띄우기 : ", Date())
                backImageView.showAnimatedSkeleton()
                RouterAPIManager.shared.requestImage(api: .imageDownload(sender: imageURL)) { response  in
                    
                    switch response {
                    case .success(let image):
                        print("- 이미지 다운 완료 -> 이미지 설정 및 이미지 캐싱")
                        ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                        self.backImageView.hideSkeleton()
                        self.backImageView.image = image
                        
                    case .failure(let error):
                        print("에러 발생 : ", error)
                    }
                    
                }
            }

//            print("==== 이미지 네트워크 통신 진행 ====")
//            RouterAPIManager.shared.requestImage(api: .imageDownload(sender: sender.image[0])) { response in
//
//                switch response {
//                case .success(let image):
//                    self.backImageView.image = image
//
//                case .failure(let error):
//                    print(error)
//                }
//            }

        } else {
            print("이미지 없으면 기본 이미지 띄워주기. 이거 만들어야 함")

        }
        
        // 2. 타이틀
        tourTitleLabel.text = sender.title
        
        // 3. 닉네임
        profileNameLabel.text = sender.creator.nick
        
            // 닉네임 길이에 따라 라인 길이 조절
        lineView.snp.makeConstraints { make in
            make.leading.equalTo(profileNameLabel.snp.trailing).offset(8)
        }
        
        // 4. 유저 프로필 이미지 (아직)
        profileImageView.image = UIImage(named: "sample")
        
        // 5. 최대 인원
        // JSON String -> Struct
        let cnt = Int(sender.maxPeopleCnt ?? "0") ?? 0
        maxPeopleView.setUp(.maxPeople(cnt: cnt))
        
        // 6. 날짜
        let dates = decodingStringToStruct(
            type: TourDates.self,
            sender: sender.dates
        )
        tourDatesView.setUp(.tourDates(dates: dates?.dates ?? []))
        
        
        
        
    }
    
}
