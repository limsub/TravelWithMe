//
//  SelectTourInfoDelegate.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/26.
//

import Foundation
import RxSwift
import RxCocoa


@objc
protocol SelectTourDatesDelegate {
    @objc
    optional func sendDates(value: [String])
}

@objc
protocol SelectTourLocationDelegate {
    @objc
    optional func sendLocation(name: String, latitude: Double, longitude: Double)
}

class RxSelectTourDatesDelegateProxy: DelegateProxy<SelectDateViewController, SelectTourDatesDelegate>, DelegateProxyType, SelectTourDatesDelegate {
    static func registerKnownImplementations() {
        self.register { (vc) -> RxSelectTourDatesDelegateProxy in
            RxSelectTourDatesDelegateProxy(parentObject: vc , delegateProxy: self)
        }
    }
    
    static func currentDelegate(for object: SelectDateViewController) -> SelectTourDatesDelegate? {
        object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: SelectTourDatesDelegate?, to object: SelectDateViewController) {
        object.delegate = delegate
    }
}

class RxSelectLocationDelegateProxy: DelegateProxy<SelectLocationViewController, SelectTourLocationDelegate>, DelegateProxyType, SelectTourLocationDelegate {
    static func registerKnownImplementations() {
        self.register { (vc) -> RxSelectLocationDelegateProxy in
            RxSelectLocationDelegateProxy(parentObject: vc , delegateProxy: self )
        }
    }
    
    static func currentDelegate(for object: SelectLocationViewController) -> SelectTourLocationDelegate? {
        object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: SelectTourLocationDelegate?, to object: SelectLocationViewController) {
        object.delegate = delegate
    }
}


extension Reactive where Base: SelectDateViewController {
    var tourDatesDelegate: DelegateProxy<SelectDateViewController, SelectTourDatesDelegate> {
        return RxSelectTourDatesDelegateProxy.proxy(for: self.base)
    }
    
    var checkTourDates: Observable<[String]> {
        return tourDatesDelegate.methodInvoked(#selector(SelectTourDatesDelegate.sendDates(value:)))
            .map { $0.first as? [String] ?? [] }
    }
}

extension Reactive where Base: SelectLocationViewController {
    var tourLocationDelegate: DelegateProxy<SelectLocationViewController, SelectTourLocationDelegate> {
        return RxSelectLocationDelegateProxy.proxy(for: self.base)
    }
    
    var checkTourLocation: Observable<TourLocation> {
        return tourLocationDelegate.methodInvoked(#selector(SelectTourLocationDelegate.sendLocation(name:latitude:longitude:)))
            .map { value in
                // 위에 매개변수 세개가 배열 형태로 저장됨!
                
                let locationInfo = TourLocation(
                    name: value[0] as? String ?? ""  ,
                    latitude: value[1] as? Double ?? 0,
                    longtitude: value[2] as? Double ?? 0
                )
                
                return locationInfo
                
            }
            
            
    }
}
