//
//  ReviewCategoryType.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/9/23.
//

import Foundation


enum ReviewCategoryType: Int {
    
    case fun
    case tired
    case boring
    case exciting
    case regretful
    case satisfied
    case impressed
    case comfortable
    case informative
    case warm
    
    
    var buttonTitle: String {
        switch self {
        case .fun:
            "  😄 재미  "
        case .tired:
            "  😴 피곤  "
        case .boring:
            "  😐 지루  "
        case .exciting:
            "  🎉 신남  "
        case .regretful:
            "  😔 아쉬움  "
        case .satisfied:
            "  😊 만족  "
        case .impressed:
            "  😍 감동  "
        case .comfortable:
            "  😌 편안  "
        case .informative:
            "  🧠 유익  "
        case .warm:
            "  🔥 따뜻  "
        }
    }
}
