//
//  ReviewBackView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/10/23.
//

import UIKit
import SnapKit

class ReviewNotMeBackView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let w = rect.width
        let h = rect.height
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: w, height: h - 10), cornerRadius: 20)
        UIColor.blue.setFill()
        
        path.lineWidth = 0
        
        path.stroke()
        path.fill()
        
        let path2 = UIBezierPath()
        path2.lineWidth = 0
        path2.move(to: CGPoint(x: 0, y: h))
        path2.addQuadCurve(to: CGPoint(x: 30, y: h - 10), controlPoint: CGPoint(x: 0, y: h - 10))
        path2.addLine(to: CGPoint(x: 0, y: h - 60))
        path2.close()
        
        path2.stroke()
        path2.fill()
    }
}

class ReviewForMeBackView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let w = rect.width
        let h = rect.height
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: w, height: h - 10), cornerRadius: 20)
        UIColor.blue.setFill()
        
        path.lineWidth = 0
        
        path.stroke()
        path.fill()
        
        let path2 = UIBezierPath()
        path2.lineWidth = 0
        path2.move(to: CGPoint(x: w, y: h))
        path2.addQuadCurve(to: CGPoint(x: w-30, y: h - 10), controlPoint: CGPoint(x: w, y: h - 10))
        path2.addLine(to: CGPoint(x: w, y: h - 60))
        path2.close()
        
        path2.stroke()
        path2.fill()
    }
}
