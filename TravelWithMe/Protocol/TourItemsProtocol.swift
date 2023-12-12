//
//  TourItemsProtocol.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/12/23.
//

import Foundation
import RxSwift
import RxCocoa

protocol TourItemsProtocol1 {
    var tourItems: BehaviorSubject<[Datum]> { get set }
}

protocol TourItemsProtocol2 {
    var tourItems: [JoinedTourForMonth] { get set }
}
