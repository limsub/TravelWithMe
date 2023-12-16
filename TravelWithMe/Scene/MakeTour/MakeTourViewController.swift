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
import Kingfisher

enum MakeOrModifyTour {
    case make
    case modify
    
    var naviagationTitle: String {
        switch self {
        case .make:
            return "여행 제작"
        case .modify:
            return "여행 수정"
        }
    }
    
    var completionButtonTitle: String {
        switch self {
        case .make:
            return "여행 제작 완료"
        case .modify:
            return "여행 수정 완료"
        }
    }
}

class MakeTourViewController: BaseViewController {
    
    // 유입 경로
    // 1. 여행 만들기
    // 2. 여행 수정하기 * -> 초기 데이터를 값전달로 받는다
    var type: MakeOrModifyTour = .make
    
    
    let mainView = MakeTourView()
    let viewModel = MakeTourViewModel()
    let disposeBag = DisposeBag()
    
    weak var delegate: ReloadContentsView?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        selectDatesLocation()
        
        settingCollectionView()
        
        settingCategoryButtons()    // 버튼 토글을 먼저 걸어줘야 하기 때문에 얘가 반드시 bind 함수보다 먼저 실행되어야 함!!
        bind()
        
        setInitData()
        settingViewByType()
    }
    
    // "게시글 수정하기"를 통해서 들어왔다면, 초기 데이터를 세팅해준다
    func setInitData() {
        if type == .make { return }
        
        guard let data = viewModel.initData else { return }
        
        // 1. 이미지 데이터 배열
        let group = DispatchGroup()
        
        data.image.forEach { item in
            
            group.enter()
            
            DispatchQueue.global().async {
                
                let sampleImage = UIImage()
                
                sampleImage.loadImageData(endURLString: item) { response in
                    switch response {
                    case .success(let result):
                        
                        // 이미지 리사이징 시작
                        let sample2Image = UIImage(data: result!)
                        
                        var compressionQuality: Double = 1
                        var imageData: Data? = sample2Image?.jpegData(compressionQuality: compressionQuality)
                        let bytesInMegaByte = 1024.0 * 1024.0
                        
                        while (true) {
                            if let sampleData = sample2Image?.jpegData(compressionQuality: compressionQuality) {
                                
                                let mbSize = Double(sampleData.count) / bytesInMegaByte
                                print("image B size : \(sampleData), image MB Size : \(mbSize), compression quality : \(compressionQuality)")
                                
                                if mbSize < 1 || compressionQuality < 0.01 {
                                    imageData = sampleData
                                    break
                                }
                                
                                compressionQuality /= 2
                            }
                        }

                        self.viewModel.tourImages.append(imageData!)
                        
                        
                    case .failure(let failure):
                        print("페일")
                    }
                    
                    group.leave()
                }
                
                
                
                
                
            }
        }
        
        group.notify(queue: .main) {
            print("dispatchGroup End")
            self.mainView.imageCollectionView.reloadData()
        }
      
        mainView.imageCollectionView.reloadData()
        
        
        // 2. 제목
        mainView.titleTextField.text = data.title
        mainView.titleTextField.sendActions(for: .valueChanged)
        
        
        // 3. 소개
        if let contentStruct = decodingStringToStruct(type: TourContent.self, sender: data.content) {
            mainView.contentTextView.text = contentStruct.content
        }
        
        
        // 4. 유형 선택
        let dict: [String: Int] = [ // 해시태그: 버튼 배열의 인덱스
            "도시": 0,
            "자연": 1,
            "문화": 2,
            "음식": 3,
            "모험": 4,
            "역사": 5,
            "로컬": 6
        ]
        data.hashTags.forEach { item in
            if let index = dict[item] {
                mainView.categoryButtons[index].sendActions(for: .touchUpInside)
                mainView.categoryButtons[index].rx.isSelected.onNext(true)
            }
        }
        
        
        // 5. 최대 모집 인원
        if let maxCntString = data.maxPeopleCnt,
           let maxCntInt = Int(maxCntString) {
            viewModel.tourPeopleCnt.accept(maxCntInt)
        }
        
        
        // 6. 예상 금액
        if let priceText = data.price {
            mainView.priceView.textField.text = priceText
            mainView.priceView.textField.sendActions(for: .valueChanged)
        }
        
        // 7. 여행 일자
        if let tourDatesStruct = decodingStringToStruct(type: TourDates.self, sender: data.dates) {
            // 왜 이렇게 하고 있지,,?
            mainView.tourDatesView.label.rx.text.onNext(calculateDateLabel(tourDatesStruct.dates))
            
            // 그리고 이걸 또해..?
            viewModel.tourDates.onNext(tourDatesStruct)
            
            mainView.tourDatesView.label.textColor = .black
        }
        
        // 8. 여행 장소
        if let tourLocationStruct = decodingStringToStruct(type: TourLocation.self, sender: data.location) {
            mainView.tourLocationView.label.rx.text.onNext(tourLocationStruct.name)
            viewModel.tourLocation.onNext(tourLocationStruct)
            
            mainView.tourLocationView.label.textColor = .black
        }
        
    }
    
    // type에 따라 뷰 세팅
    func settingViewByType() {
        navigationItem.title = type.naviagationTitle
        mainView.makeTourButton.setTitle(type.completionButtonTitle, for: .normal)
    }

    func settingCategoryButtons() {
        // 버튼 클릭할 때마다 isSelected 변수 토글시켜주기.
        
        mainView.categoryButtons.forEach { item  in
            item.rx.tap
                .subscribe(with: self) { owner , _ in
                    item.isSelected.toggle()
                    print("토글 결과 ; ", item.isSelected)
                }
                .disposed(by: disposeBag)
        }
    }
    
    
    
    func bind() {
        
        let input = MakeTourViewModel.Input(
            titleText: mainView.titleTextField.rx.text.orEmpty,
            contentText: mainView.contentTextView.rx.text.orEmpty,
            categoryButtons: mainView.categoryButtons.map { $0.rx.isSelected },
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
                
                owner.mainView.makeTourButton.update(value ? .enabled : .disabled)
            }
            .disposed(by: disposeBag)
        
        output.resultCompleteButtonClicked
            .subscribe(with: self) { owner, value  in
                switch value {
                case .success(_):
                    print("(MakeTour) 네트워크 응답 성공!")
                    print("1. ContentsView reload  2. popView")
                    
                    // 1.
                    owner.delegate?.reload()
                    
                    // 2.
                    owner.navigationController?.popViewController(animated: true)
                    
                case .commonError(let error):
                    print("(MakeTour) 네트워크 응답 실패! - 공통 에러")
                    owner.showAPIErrorAlert(error.description)
                        
                case .makePostError(let error):
                    print("(MakeTour) 네트워크 응답 실패! - 게시글 작성 에러")
                    owner.showAPIErrorAlert(error.description)
                    
                case .modifyPostError(let error):
                    print("(MakeTour) 네트워크 응답 실패! - 게시글 수정 에러")
                    owner.showAPIErrorAlert(error.description)
                    
                case .refreshTokenError(let error):
                    print("(MakeTour) 네트워크 응답 실패! - 토큰 에러")
                    if error == .refreshTokenExpired {
                        print("- 리프레시 토큰 만료!!")
                        owner.goToLoginViewController()
                    } else {
                        owner.showAPIErrorAlert(error.description)
                    }
                }
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
                owner.mainView.tourDatesView.label.textColor = .black
                owner.mainView.tourDatesView.label.rx.text
                    .onNext(owner.calculateDateLabel(value))
                
                owner.viewModel.tourDates
                    .onNext(TourDates(dates: value))
            }
            .disposed(by: disposeBag)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func calculateDateLabel(_ arr: [String]) -> String {
        var ans = ""
        
        // 하루 선택
        if arr.count == 1 {
            ans = arr.first!.toDate(to: .full)!.toString(of: .yearMonthDaySlash)
        }
        
        // 여러 날 선택
        else if arr.count == 2 {
            ans = arr.first!.toDate(to: .full)!.toString(of: .yearMonthDaySlash)
            
            ans += " ~ "
            
            ans += arr.last!.toDate(to: .full)!.toString(of: .yearMonthDaySlash)
        }
        
        return ans
    }
    
    @objc
    func locationButtonClicked() {
        let vc = SelectLocationViewController()
        vc.rx.checkTourLocation
            .subscribe(with: self) { owner , value in
                print("선택한 장소 : ", value)
                owner.mainView.tourLocationView.label.textColor = .black
                owner.mainView.tourLocationView.label.rx.text
                    .onNext(value.name)
                
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
            
            cell.cancelButtonCallBackMethod = { [weak self] in
                print("캔슬 버튼 클릭!! indexPath : \(indexPath)")
                
                
                self?.mainView.imageCollectionView.performBatchUpdates {
                    self?.viewModel.tourImages.remove(at: indexPath.item - 1)
                    
                    self?.mainView.imageCollectionView.deleteItems(at: [IndexPath(item: indexPath.item, section: 0)])
                } completion: { _ in
                    self?.mainView.imageCollectionView.reloadData()
                    print(self?.viewModel.tourImages)
                }
            }
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
                        
                        // 시뮬레이터 맨 첫번째 사진 로드 불가
                        guard let image = image as? UIImage else { return }
                        
                        // image를 jpegData로 변환해서 저장
                        // 파일 제한 사항 : 10MB
                        var compressionQuality: Double = 1
                        var imageData: Data? = image.jpegData(compressionQuality: compressionQuality)
                        let bytesInMegaByte = 1024.0 * 1024.0
                        
                        while (true) {
                            if let sampleData = image.jpegData(compressionQuality: compressionQuality) {
                                
                                let mbSize = Double(sampleData.count) / bytesInMegaByte
                                
                                print("image B size : \(sampleData), image MB Size : \(mbSize), compression quality : \(compressionQuality)")
                                
                                if mbSize < 1 {
                                    imageData = sampleData
                                    break
                                }
                                
                                if compressionQuality < 0.01 {
                                    imageData = sampleData
                                    break
                                }
                                
                                compressionQuality /= 2
                            }
                        }
                        /*
                         Double(image.count)/1024.0)/1024.0
                         
                         imageData : 2275097 bytes, compression quality : 1
                         megabytes : 2.16970157623291
                         imageData : 3425951 bytes, compression quality : 1
                         megabytes : 3.2672414779663086
                         
                         imageData : 185418 bytes, compression quality : 0.1
                         megabytes : 0.17682838439941406
                         imageData : 244981 bytes, compression quality : 0.1
                         megabytes : 0.23363208770751953
                         
                         imageData : 244981 bytes, compression quality : 0.01
                         imageData : 185418 bytes, compression quality : 0.01
                         
                         imageData : 185418 bytes, compression quality : 0.001
                         imageData : 244981 bytes, compression quality : 0.001
                         
                         imageData : 244981 bytes, compression quality : 1e-09
                         imageData : 185418 bytes, compression quality : 1e-09
                         */
                        
                        
                        // 로드되는 순서가 달라서... 이미지가 append되는 순서가 달라진다..ㅠ index로 접근하는 방법이 없을라나
                        if imageData != nil {
                            self?.viewModel.tourImages.append(imageData!)
                        }

                        
                        if self?.viewModel.tourImages.count == results.count {
                            DispatchQueue.main.async {
                                self?.mainView.imageCollectionView.reloadData()
                            }
                        }
                        
                    }
                }
            }
        }
        picker.dismiss(animated: true)
    }
}
