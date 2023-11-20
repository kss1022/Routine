//
//  SettingFontSlider.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import UIKit




final class SettingFontSlider: UISlider{
    
    var stepCount: Int
    var lineHeight: CGFloat
    var strokeColor : UIColor
    
    private let stepLayer = SettingFontStepLayer()
    
    
    
    init(){
        self.stepCount = 7
        self.lineHeight = 4.0
        self.strokeColor = .secondaryLabel
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        self.stepCount = 7
        self.lineHeight = 4.0
        self.strokeColor = .secondaryLabel
        super.init(coder: coder)
        
        setView()
    }
    
    override var frame: CGRect{
        didSet{
            updateLayerFrames()
        }
    }
    
    private func setView(){
        stepLayer.slider = self
                
        layer.sublayers?.first?.addSublayer(stepLayer)
                        
        minimumValue = 10
        maximumValue = 70
        value = 50
        isContinuous = false
        self.tintColor = strokeColor
        self.minimumTrackTintColor = .clear
        self.maximumTrackTintColor = .clear
        
        self.minimumValueImage = UIImage(systemName: "textformat.size.smaller.ko")
        self.maximumValueImage = UIImage(systemName: "textformat.size.larger.ko")
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let trackRect = super.trackRect(forBounds: bounds)
        stepLayer.frame = CGRect(x: trackRect.minX, y: bounds.minY, width: trackRect.width, height: bounds.height)
        return trackRect
    }

    
    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        stepLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    func positionForValue(_ value: Float) -> CGFloat {
        return bounds.width * CGFloat((  ( value - minimumValue ) / ( maximumValue - minimumValue ) ))
    }
    

    
    func sliderValueChanged(_ sender: UISlider) {
        let step: Float = 10.0
        let roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
    }
}



