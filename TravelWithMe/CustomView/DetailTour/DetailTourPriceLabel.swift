//
//  DetailTourPriceLabel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/6/23.
//

import UIKit

class DetailTourPriceLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUp() {
        font = .boldSystemFont(ofSize: 18)
        textColor = .black
        numberOfLines = 1
        textAlignment = .right
        
        text = "30,000 원"
    }
    
    func updatePrice(_ priceString: String) {
        
        guard let priceInt = Int(priceString) else {
            text = "0 원"
            return
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        text = numberFormatter.string(for: priceInt)! + " 원"
        
    }
}
