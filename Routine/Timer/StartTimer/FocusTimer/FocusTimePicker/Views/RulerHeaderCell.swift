//
//  RulerHeaderCell.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import UIKit


class RulerHeaderCell: UICollectionViewCell {
    
    var headerMinValue = 0
    
    var radius: CGFloat = 2.0
    var round: CGFloat = 4.0
    
    override func draw(_ rect: CGRect) {
        
        let centerY = rect.size.height / 2
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.secondaryLabel.cgColor)
        context?.addEllipse(in: CGRect(x: rect.width - radius, y: centerY - radius , width: round, height: round))
        context?.strokePath()
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -300.0, y: centerY))
        path.addLine(to: CGPoint(x: rect.size.width - 10.0 , y: centerY))
        UIColor.secondaryLabel.setStroke()
        path.lineWidth = 0.5
        path.stroke()
    }
}


