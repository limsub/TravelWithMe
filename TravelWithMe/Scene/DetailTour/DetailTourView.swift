//
//  DetailTourView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import UIKit
import MapKit


class HideHalfDetailTourImageBezierView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white.withAlphaComponent(0.00001)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let hitView: UIView? = super.hitTest(point, with: event)
        if (self == hitView) { return nil }
        return hitView
    }

    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        let width = UIScreen.main.bounds.width
        
    
        UIColor.white.setFill()
        path.lineWidth = 0
        
        path.move(to: CGPoint(x: 0, y: 100))
        path.addLine(to: CGPoint(x: 0, y: 60))
        path.addCurve(to: CGPoint(x: width, y: 30),
                      controlPoint1: CGPoint(x: center.x - 50, y: 150),
                      controlPoint2: CGPoint(x: center.x + 50, y: -50)
        )
        path.addLine(to: CGPoint(x: width, y: 100))
        
        path.stroke()
        path.fill()
    }
}

class DetailTourView: BaseView {
    
    // * 스크롤뷰
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    
    
    // 1. 이미지 스와이프해서 넘길 컬렉션뷰
    lazy var swipeImagesCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createSwipeImageLayout())
        
        view.register(DetailTourSwipeImageCollectionViewCell.self , forCellWithReuseIdentifier: "DetailTourView - DetailTourSwipeImageCollectionViewCell")
        
        view.showsHorizontalScrollIndicator = false
        
        view.isPagingEnabled = true
    
        view.backgroundColor = .red
        
        return view
    }()
    
    // 2. 곡선 뷰 (이미지 컬렉션뷰 위에 덮어씌우기)
    let curveView = HideHalfDetailTourImageBezierView()
    
    // 3. 이미지 PageControl
    lazy var swipeImagesPageControl = {
        let view = UIPageControl()
        view.numberOfPages = 4
        view.hidesForSinglePage = true
        view.currentPageIndicatorTintColor = UIColor.appColor(.second1)
        view.pageIndicatorTintColor = UIColor.appColor(.second1).withAlphaComponent(0.3)
        view.isEnabled = false
        
        return view
    }()
    
    // 4. 투어 카테고리 컬렉션뷰
    lazy var tourCategoryCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: self.createDetailTourCategoryCollectionViewLayout())
        
        view.register(DetailTourCategoryCollectionViewCell.self , forCellWithReuseIdentifier: "DetailTourView - DetailTourCategoryCollectionViewCell")
        
        view.showsHorizontalScrollIndicator = false
//        view.backgroundColor = .orange
        
        view.isScrollEnabled = false
        
        return view
    }()
    
    // 5. 투어 타이틀 레이블
    let tourTitleLabel = ContentsTourTitleLabel(.black)
    
    // 6. 투어 제작자 이미지뷰
    let tourProfileImageView = ContentsProfileImageView(frame: .zero)
    
    // 7. 투어 제작자 레이블
    let tourProfileLabel = ContentsTourProfileNameLabel(.black)
    
    // 7.5 투어 제작자 프로필 화살표
    let tourProfileChevronImageView = {
        let view = UIImageView()
        view.tintColor = .black
        view.image = UIImage(systemName: "chevron.right")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    // 6 ~ 7.5 덮어쓰고 있는 투어 제작자 프로필 화면 이동 버튼
    let goToProfileButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        return view
    }()
    
    // 8. 투어 정보 - 투어 일자
    let tourDatesInfoView = DetailTourInfoView()
    
    // 9. 투어 정보 - 최대 인원
    let tourMaxPeopleInfoView = DetailTourInfoView()
    
    // 10. 투어 소개 - 이름 레이블
    let contentNameLabel = SignUpSmallLabel("여행 소개")
    
    // 11. 투어 소개 - 내용
    let contentLabel = {
        let view = UILabel()
        
        view.font = .systemFont(ofSize: 14)
        view.textColor = .black
        view.numberOfLines = 0
        view.textAlignment = .left
        
        view.text = "안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일안녕하세요 도쿄 여행 3박 4일"
        
        return view
    }()
    
    // 12. 투어 비용 - 이름 레이블
    let priceNameLabel = SignUpSmallLabel("예상 비용")
    
    // 12.5 투어 비용 점선
    let priceDotLineView = DetailTourDotLineView()
    
    // 13. 투어 비용 - 내용
    let priceLabel = DetailTourPriceLabel()
    
    // 14. 투어 위치 - 이름 레이블
    let locationNameLabel = SignUpSmallLabel("대표 여행지")
    
    // 14.25 투어 위치 점선
    let locationDotLineView = DetailTourDotLineView()
    
    // 14.5 투어 위치 장소 이름
    let locationLabel = DetailTourLocationLabel()
    
    // 15. 투어 위치 - 지도 뷰
    let locationView = {
        let view = MKMapView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    // * 맨 아래 bottom view (고정)
    let bottomView = DetailTourBottomView()

    override func setConfigure() {
        super.setConfigure()
        
        bottomView.layer.applyShadow()
        
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [swipeImagesCollectionView, curveView, swipeImagesPageControl, tourCategoryCollectionView, tourTitleLabel, tourProfileImageView, tourProfileLabel, tourProfileChevronImageView, goToProfileButton, tourMaxPeopleInfoView, tourDatesInfoView, contentNameLabel, contentLabel, priceNameLabel, priceDotLineView, priceLabel, locationNameLabel, locationDotLineView, locationLabel, locationView].forEach { item  in
            contentView.addSubview(item)
        }
        
        addSubview(bottomView)

    }
    
    override func setConstraints() {
        super.setConstraints()
        
//        scrollView.backgroundColor = .blue
//        contentView.backgroundColor = .yellow
     
        
        // * 스크롤뷰
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.horizontalEdges.equalTo(scrollView.contentLayoutGuide)
//            make.top.equalTo(scrollView.snp.top)
//            make.top.equalTo(self)
//            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.top.equalTo(scrollView).inset(-100)
            
            
            make.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }
        
        
        // * 인스턴스
        swipeImagesCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.height.equalTo(360)
        }
        
        curveView.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(260)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        swipeImagesPageControl.snp.makeConstraints { make in
            make.centerY.equalTo(curveView).inset(30)
            make.centerX.equalTo(contentView.snp.centerX).offset(120)
        }
        
        tourCategoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(curveView.snp.bottom)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(30)
        }
        
        tourTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(tourCategoryCollectionView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        tourProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(tourTitleLabel.snp.bottom).offset(20)
            make.leading.equalTo(contentView).inset(18)
            make.size.equalTo(40)
        }
        tourProfileLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tourProfileImageView)
            make.leading.equalTo(tourProfileImageView.snp.trailing).offset(12)
        }
        tourProfileChevronImageView.snp.makeConstraints { make in
            make.centerY.equalTo(tourProfileImageView)
            make.leading.equalTo(tourProfileLabel.snp.trailing).offset(4)
            make.size.equalTo(20)
        }
        goToProfileButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(tourProfileImageView)
            make.leading.equalTo(tourProfileImageView)
            make.trailing.equalTo(tourProfileChevronImageView)
        }
        
        tourMaxPeopleInfoView.snp.makeConstraints { make in
            make.top.equalTo(tourProfileImageView.snp.bottom).offset(20)
            make.height.equalTo(92)
            make.leading.equalTo(contentView).inset(18)
            make.trailing.equalTo(contentView.snp.centerX).inset(10)
        }
        
        tourDatesInfoView.snp.makeConstraints { make in
            make.height.equalTo(92)
            make.top.equalTo(tourProfileImageView.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.centerX).offset(10)
            make.trailing.equalTo(contentView).inset(18)
        }
        
        contentNameLabel.snp.makeConstraints { make in
            make.top.equalTo(tourDatesInfoView.snp.bottom).offset(40)
            make.leading.equalTo(contentView).inset(18)
        }
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(contentNameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        
        priceNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(40)
            make.leading.equalTo(contentView).inset(18)
        }
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceNameLabel)
            make.trailing.equalTo(contentView).inset(18)
        }
        priceDotLineView.snp.makeConstraints { make in
            make.leading.equalTo(priceNameLabel.snp.trailing).offset(12)
            make.trailing.equalTo(priceLabel.snp.leading).offset(-12)
            make.height.equalTo(1)
            make.centerY.equalTo(priceNameLabel)
        }
        
        
        locationNameLabel.snp.makeConstraints { make in
            make.top.equalTo(priceNameLabel.snp.bottom).offset(40)
            make.leading.equalTo(contentView).inset(18)
        }
        locationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(locationNameLabel)
            make.trailing.equalTo(contentView).inset(18)
        }
        locationDotLineView.snp.makeConstraints { make in
            make.leading.equalTo(locationNameLabel.snp.trailing).offset(12)
            make.trailing.equalTo(locationLabel.snp.leading).offset(-12)
            make.height.equalTo(1)
            make.centerY.equalTo(locationNameLabel)
        }
        locationView.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.height.equalTo(150)
            make.bottom.equalTo(contentView).inset(120)
        }
        
        
        
        bottomView.snp.makeConstraints { make in
            make.height.equalTo(105)
            make.bottom.horizontalEdges.equalTo(self)
        }
    }
    
    func setUp(_ sender: Datum) {
        
        swipeImagesPageControl.numberOfPages = sender.image.count
        
        // collectionView 데이터는 VC에서 DataSource로 관리
        
        tourTitleLabel.text = sender.title ?? ""
        
        tourProfileImageView
        
        tourProfileLabel.text = sender.creator.nick
        
        let cntString = sender.maxPeopleCnt ?? "0"
        let cntInt = Int(cntString) ?? 0
        tourMaxPeopleInfoView.setUp(.maxPeople(cnt: cntInt))
        
        let datesStruct = decodingStringToStruct(type: TourDates.self , sender: sender.dates) ?? TourDates(dates: [])
        let datesArr = datesStruct.dates
        tourDatesInfoView.setUp(.tourDates(dates: datesArr))
        
        let contentStruct = decodingStringToStruct(type: TourContent.self , sender: sender.content) ?? TourContent(content: "", hashTags: "")
        let contentString = contentStruct.content
        contentLabel.text = contentString
        
        priceLabel.updatePrice(sender.price ?? "")
        
        
        setUpMapView(sender: sender)
        setUpBottomApplyButton(sender: sender)
    }
    
    func setUpBottomApplyButton(sender: Datum) {
        
        // 버튼 타입 잡아주기
        // 1. 내가 만든 투어인지
        let isMine = sender.creator._id == KeychainStorage.shared._id
        // 2. 내가 신청한 투어인지
        let isApplied = sender.likes.contains(KeychainStorage.shared._id ?? "-1")
        // 3. 신청 수 / 최대 인원 수
        let likesCnt = sender.likes.count
        let cntString = sender.maxPeopleCnt ?? "0"
        let cntInt = Int(cntString) ?? 0
        let maxCnt = cntInt
        bottomView.applyButton.updateButton(
            likesCnt,
            maxCnt: maxCnt,
            isMine: isMine,
            isApplied: isApplied
        )
        
        print("isMine : \(isMine), isApplied: \(isApplied)")
    }
    
    func setUpMapView(sender: Datum) {
        let locationStruct = decodingStringToStruct(
            type: TourLocation.self,
            sender: sender.location
        ) ?? TourLocation(name: "", address: "", latitude: 0, longtitude: 0)
        let centerLocation = CLLocationCoordinate2D(
            latitude: locationStruct.latitude,
            longitude: locationStruct.longtitude
        )
        let region = MKCoordinateRegion(
            center: centerLocation,
            latitudinalMeters: 100,
            longitudinalMeters: 100
        )
        let annotation = MKPointAnnotation()
        annotation.title = locationStruct.name
        annotation.coordinate = centerLocation
        locationView.addAnnotation(annotation)
        locationView.setRegion(region, animated: true)
        locationLabel.updateLocation(locationStruct.name)
    }
}
