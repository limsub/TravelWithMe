//
//  MakingTourViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

class MakeTourViewController: BaseViewController {
    
    let mainView = MakeTourView()
    let viewModel = MakeTourViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        RouterAPIManager.shared.request(
        //            type: makePostResponse.self,
        //            error: makePostAPIError.self,
        //            api: .makePost(sender: makePostRequest(title: "테스트 타이틀", content: "테스트 컨텐츠", tourDates: "20230919", tourLocations: "위도, 경도", locationName: "영등포캠퍼스", maxPeopleCnt: "5", tourPrice: "30000")
        //)
        //        )
        
        bind()
        
        // 여행 일자와 여행 장소 다른 뷰컨에서 받아오는 건 (버튼 탭) Input으로 넣지 말고, 일단 Rx Delegate Pattern만 이용하자.
        
        selectDatesLocation()
        
        settingCollectionView()
    }

    
    
    
    
    func bind() {
        
        let input = MakeTourViewModel.Input(
            titleText: mainView.titleTextField.rx.text.orEmpty,
            contentText: mainView.contentTextView.rx.text.orEmpty,
            peoplePlusTap: mainView.peopleCntView.plusButton.rx.tap,
            peopleMinusTap: mainView.peopleCntView.minusButton.rx.tap,
            priceText: mainView.priceView.textField.rx.text.orEmpty,
            completeButtonClicked: mainView.makeTourButton.rx.tap
        )

        let output = viewModel.tranform(input)
        
        
        // 모집 인원 카운트
        output.peopleCnt
            .subscribe(with: self) { owner , value in
                owner.mainView.peopleCntView.countLabel.text = "\(value)"
            }
            .disposed(by: disposeBag)
        
        
        // 여행 제작 완료 버튼 활성화
        // 초기값 (false)는 직접 넣어줘야 한다. -> View에서 세팅
        output.enabledCompleteButton
            .subscribe(with: self) { owner , value in
                print("여행 제작 버튼 활성화 여부 : ", value)
                owner.mainView.makeTourButton.isEnabled = value
                owner.mainView.makeTourButton.backgroundColor = UIColor(hexCode: value ? ConstantColor.enabledButtonBackground.hexCode : ConstantColor.disabledButtonBackground.hexCode)
            }
            .disposed(by: disposeBag)
        
    

        output.tap
            .subscribe(with: self) { owner , _ in
                print("탭 뷰컨")
            }
            .disposed(by: disposeBag)

        
    }
    
    func selectDatesLocation() {
        // 여행 날짜
        mainView.tourDatesView.button.addTarget(self , action: #selector(dateButtonClicked), for: .touchUpInside)
        
        // 여행 장소
        mainView.tourLocationView.button.addTarget(self , action: #selector(locationButtonClicked), for: .touchUpInside)
    }
    
    @objc
    func dateButtonClicked() {
        let vc = SelectDateViewController()
        vc.rx.checkTourDates
            .subscribe(with: self) { owner , value in
                print("선택한 날짜 : ", value)
                owner.mainView.tourDatesView.label.rx.text
                    .onNext("일단 하나. \(value[0])")
                
                owner.viewModel.tourDates
                    .onNext(TourDates(dates: value))
            }
            .disposed(by: disposeBag)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    func locationButtonClicked() {
        let vc = SelectLocationViewController()
        vc.rx.checkTourLocation
            .subscribe(with: self) { owner , value in
                print("선택한 장소 : ", value)
                owner.mainView.tourLocationView.label.rx.text
                    .onNext("위도경도 따로. \(value.name)")
                
                owner.viewModel.tourLocation
                    .onNext(value)
            }
            .disposed(by: disposeBag)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    func settingCollectionView() {
        
        mainView.imageCollectionView.delegate = self
        mainView.imageCollectionView.dataSource = self
    }
}

extension MakeTourViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tourImages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "여행 만들기 - 이미지 컬렉션뷰", for: indexPath) as? MakeTourImageCollectionViewCell else { return UICollectionViewCell() }
        
        
        if (indexPath.item == 0) {
            cell.designPlusCell()
        }
        else {
            cell.designCell(viewModel.tourImages[indexPath.row - 1])
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard indexPath.item == 0 else { print("선택 불가"); return;}
        
        showPHPicker()
    }
    
    func showPHPicker() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
}

extension MakeTourViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        
        
        if !results.isEmpty {
            
            viewModel.tourImages.removeAll()
            
            for result in results {
                let itemProvider = result.itemProvider
                
                // UIImage로 받을 수 있는 애들을 배열에 저장
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image , error  in
                        
                        print("이미지 : ", image)
                        print("에러 : ", error)
                        
                        // 시뮬레이터 맨 첫번째 사진 로드 불가
                        guard let image = image as? UIImage else { return }
                        print("가드 통과")
                        self?.viewModel.tourImages.append(image)
                        print(self?.viewModel.tourImages)
                        
                        
                        
                        
                        DispatchQueue.main.async {
                            self?.mainView.imageCollectionView.reloadData()
                        }
                            
                        
                        
                    }
                }
            }
            
        }
        
        picker.dismiss(animated: true)
        
    }

    
}
