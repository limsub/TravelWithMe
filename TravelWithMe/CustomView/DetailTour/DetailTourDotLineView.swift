//
//  DetailTourDotLineView.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/4/23.
//

import UIKit

class DetailTourDotLineView: UIView {
  
  private let borderLayer = CAShapeLayer()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
      borderLayer.strokeColor = UIColor.appColor(.main1).withAlphaComponent(0.6).cgColor
    borderLayer.lineDashPattern = [3,3]
    borderLayer.backgroundColor = UIColor.clear.cgColor
    borderLayer.fillColor = UIColor.clear.cgColor
    
    layer.addSublayer(borderLayer)
    
  }
  override func draw(_ rect: CGRect) {
      
      let path = UIBezierPath()
      
      
//      UIColor.systemRed.setFill()
//      UIColor.systemYellow.setStroke()
      
      path.lineWidth = 1
      
      path.move(to: CGPoint(x: rect.minX, y: 0))
      path.addLine(to: CGPoint(x: rect.maxX, y: 0))
      
//      path.stroke()
//      path.fill()
      
      
      borderLayer.path =  path.cgPath
    
//    borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: 8).cgPath
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
