//
//  SelectDateViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/26.
//

import UIKit
import RxSwift
import RxCocoa

@objc
protocol SecondViewControllerDelegate {
    @objc optional func printDates(value: [String])
}


class SelectDateViewController: BaseViewController {
    
    let mainView = SelectDateView()
    
    var delegate: SelectTourDatesDelegate?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.completeButton.addTarget(self , action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    @objc
    func completeButtonClicked() {
        // 선택한 날짜 배열 -> sort -> "M/DD" 변환
        delegate?.sendDates?(
            value: mainView.calendar.selectedDates.sorted()
                .map { $0.toString(of: .monthSlashDay) }
        )
        
        navigationController?.popViewController(animated: true)
    }
}
