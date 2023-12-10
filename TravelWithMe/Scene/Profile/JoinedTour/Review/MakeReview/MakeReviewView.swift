//
//  MakeReviewView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import UIKit

class MakeReviewView: BaseView {

    
    let tourView = ReviewSmallTourView()
    
    let categoryNameLabel = SignUpSmallLabel("여행이 어땠나요? (최대 3개의 항목을 선택할 수 있습니다)")
    
    let reviewCategoryButtons = [
        ReviewCategoryButton(.fun),
        ReviewCategoryButton(.tired),
        ReviewCategoryButton(.boring),
        ReviewCategoryButton(.exciting),
        ReviewCategoryButton(.regretful),
        ReviewCategoryButton(.satisfied),
        ReviewCategoryButton(.impressed),
        ReviewCategoryButton(.comfortable),
        ReviewCategoryButton(.informative),
        ReviewCategoryButton(.warm),
    ]
    
    let writingReviewNameLabel = SignUpSmallLabel("직접 후기를 작성해주세요")
    let writingReviewTextView = MakeTourTextView()
    
    let completeButton = SignUpCompleteButton("후기 작성")
    
    override func setConfigure() {
        super.setConfigure()
        
        [tourView, categoryNameLabel, writingReviewNameLabel, writingReviewTextView, completeButton].forEach { item in
            addSubview(item)
//            item.backgroundColor = .red
        }
        reviewCategoryButtons.forEach { item in
            addSubview(item)
//            item.backgroundColor = .red
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        tourView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.horizontalEdges.equalTo(self).inset(18)
            make.height.equalTo(90)
        }
        
        categoryNameLabel.snp.makeConstraints { make in
            make.top.equalTo(tourView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(self).inset(18)
        }
        
        reviewCategoryButtons[0].snp.makeConstraints { make in
            make.top.equalTo(categoryNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(self).inset(18)
            make.height.equalTo(40)
        }
        reviewCategoryButtons[5].snp.makeConstraints { make in
            make.top.equalTo(reviewCategoryButtons[0].snp.bottom).offset(8)
            make.leading.equalTo(self).inset(18)
            make.height.equalTo(40)
        }
        for i in 1...9 {
            if (i == 5) { continue }
            reviewCategoryButtons[i].snp.makeConstraints { make in
                make.top.equalTo(reviewCategoryButtons[i-1])
                make.leading.equalTo(reviewCategoryButtons[i-1].snp.trailing).offset(8)
                make.height.equalTo(40)
            }
        }
        
        writingReviewNameLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewCategoryButtons[5].snp.bottom).offset(40)
            make.horizontalEdges.equalTo(self).inset(18)
        }
        writingReviewTextView.snp.makeConstraints { make in
            make.top.equalTo(writingReviewNameLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(self).inset(18)
            make.height.equalTo(200)
        }
        
        completeButton.snp.makeConstraints { make in
//            make.top.equalTo(writingReviewTextView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(self).inset(18)
            make.height.equalTo(52)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(50)
        }
        
        
    }
    
    override func setting() {
        super.setting()
        
        backgroundColor = .white
    }
}
