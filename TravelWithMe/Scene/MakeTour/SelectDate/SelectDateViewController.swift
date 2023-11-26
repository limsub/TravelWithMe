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
    
    var delegate: SecondViewControllerDelegate?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.completeButton.addTarget(self , action: #selector(b), for: .touchUpInside)
    }
    
    @objc
    func b() {
        
        delegate?.printDates?(value: mainView.calendar.selectedDates.map { $0.toString(of: .full) })
        navigationController?.popViewController(animated: true)
    }
}

class RxSecondViewControllerDelegateProxy: DelegateProxy<SelectDateViewController, SecondViewControllerDelegate>, DelegateProxyType, SecondViewControllerDelegate {
    static func registerKnownImplementations() {
        self.register { (vc) -> RxSecondViewControllerDelegateProxy in
            RxSecondViewControllerDelegateProxy(parentObject: vc , delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: SelectDateViewController) -> SecondViewControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: SecondViewControllerDelegate?, to object: SelectDateViewController) {
        object.delegate = delegate
    }
    
    func printDates(value: [String]) {
        print(value)
    }
    
    
}


extension Reactive where Base: SelectDateViewController {
    var delegate: DelegateProxy<SelectDateViewController, SecondViewControllerDelegate> {
        return RxSecondViewControllerDelegateProxy.proxy(for: self.base)
    }
    
    var plusButtonClicked: Observable<[String]> {
        return delegate.methodInvoked(#selector(SecondViewControllerDelegate.printDates(value: ))).map { $0.first as? [String] ?? []}
    }
}
