//
//  SettingFontStepLayer.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import Foundation
import UIKit


class SettingFontStepLayer: CALayer{
    weak var slider: SettingFontSlider?
    
    
    override func draw(in ctx: CGContext) {
        guard let slider = slider else {
            return
        }
        
        
        let imageWidth = self.bounds.height
        let lineHeight = slider.lineHeight
        let strokeColor = slider.strokeColor.cgColor
        
        let x = bounds.minX + imageWidth / 2
        let y = bounds.minY
        
        let width = bounds.width - imageWidth
        let height = bounds.height
                                
        ctx.setLineWidth(lineHeight)
        ctx.setStrokeColor(strokeColor)
        
        let midY = height / 2
        
        ctx.move(to: CGPoint(x: x, y:  midY))
        ctx.addLine(to: CGPoint(x: x + width, y: midY))
        ctx.strokePath()
        
        if slider.stepCount != 0{
            let frame = CGRect(x: x, y: y, width: width, height: height)
            ctx.setSeperator(count: slider.stepCount, bounds: frame, strokeColor: strokeColor)
        }
        
        ctx.strokePath()
    }
    
    
    
}


private extension CGContext{
    func setSeperator( count : Int , bounds : CGRect, strokeColor: CGColor){
        self.setFillColor(UIColor.label.cgColor)
        
        let interval : CGFloat = bounds.width / CGFloat( count - 1)
        let width = 3.0
        let lineHeight = 10.0
        
        self.setLineWidth(width)
        
        for i in 0..<count{
            let start = CGFloat(i) * interval
            
            let x = start + bounds.minX
            let y =  (bounds.height / 2 - lineHeight / 2)
            
            self.setStrokeColor(strokeColor)
            
            self.move(to: CGPoint(x: x, y: y))
            self.addLine(to: CGPoint(x: x, y: y + lineHeight))
            self.strokePath()
        }
    }
}
