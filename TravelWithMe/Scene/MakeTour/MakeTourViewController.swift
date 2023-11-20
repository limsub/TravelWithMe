//
//  MakingTourViewController.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/20.
//

import UIKit

class MakeTourViewController: BaseViewController {

    let mainView = MakeTourView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
