//
//  RullerCell.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import UIKit



//MARK: BaseCell
class RullerCell: UICollectionViewCell {
    var rulerSpacing: CGFloat = 10.0
    var minValue:CGFloat = 0.0
    var maxValue:CGFloat = 0.0
    var step:CGFloat = 0.0
    var num = 0
    
    var radius: CGFloat = 1.0
    var bigRaidus: CGFloat = 2.0
    
    
    var round: CGFloat = 2.0
    var bigRound: CGFloat = 4.0
    
    
    override func draw(_ rect: CGRect) {
        let centerY = rect.size.height / 2
        
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.secondaryLabel.cgColor)
        for i in 0...num {
            if i % num == 0 {
                context?.addEllipse(
                    in: CGRect(
                        x: rulerSpacing * CGFloat(i) - bigRaidus,
                        y: centerY - bigRaidus,
                        width: bigRound,
                        height: bigRound
                    )
                )
            }else{
                context?.addEllipse(
                    in: CGRect(
                        x: rulerSpacing * CGFloat(i) - radius,
                        y: centerY  - radius,
                        width: round,
                        height: round
                    )
                )
            }
            
            context?.strokePath()
        }
        
    }
}
