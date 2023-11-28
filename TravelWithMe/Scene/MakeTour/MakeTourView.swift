//
//  MakeTourView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit

class MakeTourView: BaseView {
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    lazy var imageCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createImageCollectionViewLayout())
        
        view.register(MakeTourImageCollectionViewCell.self, forCellWithReuseIdentifier: "여행 만들기 - 이미지 컬렉션뷰")
        
//        view.backgroundColor = .purple
        
        
        view.showsHorizontalScrollIndicator = false
        
        return view
    }()
    
    func createImageCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 100, height: 100)
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 24
        
        layout.scrollDirection = .horizontal
        
        return layout
    }
    
    
//    let imagePickerView = { // 임시
//        let view = UIImageView()
//        view.backgroundColor = .green
//        return view
//    }()

    let imageLabel = SignUpSmallLabel("사진")
    let titleLabel = SignUpSmallLabel("제목")
    let contentLabel = SignUpSmallLabel("소개")
    let typeLabel = SignUpSmallLabel("유형")
    let peopleCntLabel = SignUpSmallLabel("최대 모집 인원")
    let priceLabel = SignUpSmallLabel("예상 금액")
    let dateLabel = SignUpSmallLabel("여행 날짜")
    let locationLabel = SignUpSmallLabel("여행 장소")
    
    let titleTextField = SignUpTextField("제목을 입력하세요")
    let contentTextView = MakeTourTextView()
    let peopleCntView = MakeTourPeopleCountView()
//    let priceTextField = SignUpTextField("10,000 원")
    let priceView = MakeTourPriceView()
    
    let tourDatesLabel = SignUpSmallLabel("여행 일자")
    let tourLocationLabel = SignUpSmallLabel("여행 장소")
    let tourDatesView = MakeTourDatesView("calendar", placeholder: "언제 여행을 떠나고 싶으신가요?")
    let tourLocationView = MakeTourDatesView("map", placeholder: "가고 싶은 장소 한 곳을 골라주세요")
    
    let makeTourButton = SignUpCompleteButton("여행 제작 완료")
    
    
    override func setConfigure() {
        super.setConfigure()
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [imageCollectionView, imageLabel, titleLabel, contentLabel, typeLabel, peopleCntLabel, priceLabel, titleTextField, contentTextView, peopleCntView, priceView, dateLabel, locationLabel, tourDatesLabel, tourLocationLabel, tourDatesView, tourLocationView, makeTourButton].forEach { item in
            contentView.addSubview(item)
        }
        
        
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.height.greaterThanOrEqualTo(self.snp.height).priority(.low)
            make.width.equalTo(scrollView.snp.width)
        }

        imageLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).inset(40)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }

        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(imageLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView)
            make.height.equalTo(100)
        }
        

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        titleTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(18)
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.height.equalTo(150)
        }
        
        typeLabel.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        
        peopleCntLabel.snp.makeConstraints { make in
            make.top.equalTo(typeLabel.snp.bottom).offset(40)
            make.leading.equalTo(contentView).inset(18)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleCntLabel)
            make.leading.equalTo(contentView.snp.centerX).offset(8)
        }
        peopleCntView.snp.makeConstraints { make in
            make.leading.equalTo(contentView).inset(18)
            make.top.equalTo(peopleCntLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
            make.trailing.equalTo(contentView.snp.centerX)
        }
        priceView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.centerX).offset(8)
            make.top.equalTo(peopleCntView)
            make.height.equalTo(52)
            make.trailing.equalTo(contentView).inset(18)
        }
        
        tourDatesLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleCntView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        tourDatesView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.top.equalTo(tourDatesLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
        }
        
        tourLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(tourDatesView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(contentView).inset(18)
        }
        tourLocationView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.top.equalTo(tourLocationLabel.snp.bottom).offset(8)
            make.height.equalTo(52)
        }
        
        makeTourButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(contentView).inset(18)
            make.top.equalTo(tourLocationView.snp.bottom).offset(40)
            make.height.equalTo(52)
            make.bottom.equalTo(contentView).inset(20)
        }

        
        
    }
    
    override func setting() {
        super.setting()
        
        makeTourButton.isEnabled = false
        makeTourButton.backgroundColor = UIColor(hexCode:  ConstantColor.disabledButtonBackground.hexCode)
    }
    
    
}
