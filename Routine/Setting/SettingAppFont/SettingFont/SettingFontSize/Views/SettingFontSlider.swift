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
    var strokeColor : CGColor
    
    private let stepLayer = SettingFontStepLayer()
    public var valueChanged: ((AppFontSize) -> ())?
    
    
    init(){
        self.stepCount = 7
        self.lineHeight = 4.0
        self.strokeColor = UIColor.label.cgColor
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        self.stepCount = 7
        self.lineHeight = 4.0
        self.strokeColor = UIColor.label.cgColor
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
        addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

        layer.sublayers?.first?.addSublayer(stepLayer)
                        
        minimumValue = 10
        maximumValue = 70
        value = 50
        isContinuous = false
        self.tintColor = UIColor.label
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

    override func layoutSubviews() {
        super.layoutSubviews()                
        updateLayerFrames()
    }
    
    public func setFontSize(_ appFontSize: AppFontSize){
        switch appFontSize {
        case .xSmall: value = 10
        case .Small: value = 20
        case .Medium: value = 30
        case .Large: value = 40
        case .xLarge: value = 50
        case .xxLarge: value = 60
        case .xxxLarge: value = 70
        }
    }
    
    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        stepLayer.setNeedsDisplay()
        
        CATransaction.commit()
    }
    
    private func positionForValue(_ value: Float) -> CGFloat {
        return bounds.width * CGFloat((  ( value - minimumValue ) / ( maximumValue - minimumValue ) ))
    }
    
    
    @objc
    private func sliderValueChanged(_ sender: UISlider) {
        let step: Float = 10.0
        let roundedValue = round(sender.value / step) * step
        value = roundedValue
        
        let fontSize: AppFontSize
        switch value{
        case 10: fontSize = .xSmall
        case 20: fontSize = .Small
        case 30: fontSize = .Medium
        case 40: fontSize = .Large
        case 50: fontSize = .xLarge
        case 60: fontSize = .xxLarge
        case 70: fontSize = .xxxLarge
        default : fatalError("Invalid slider value")
        }
        
        self.valueChanged?(fontSize)
    }
    
    
    
}



