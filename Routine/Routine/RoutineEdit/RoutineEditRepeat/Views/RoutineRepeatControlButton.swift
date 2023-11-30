//
//  RoutineRepeatControlButton.swift
//  Routine
//
//  Created by 한현규 on 10/10/23.
//

import UIKit



final class RoutineRepeatControlButton: UIButton{

    override var isSelected: Bool{
        didSet(isSelected){
            updateTitleColor()
            updateLayer()
        }
    }
            
    //Layer
    private var addedLayer: CAShapeLayer?
    private var fillColor: CGColor = UIColor.primaryGreen.cgColor
       
    
    //TitleLabel
    private let titleColor = UIColor.label
    private let selectedTitleColor = UIColor.white
    
    
    init(){
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setView()
    }
    
    
    private func setView(){
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.textAlignment = .center
        self.backgroundColor = .clear
    }
    
    
    private func updateLayer(){
        if isSelected{
            drawCircle()
            addAnimation()
        }else{
            removeAddedLayer()
        }
    }
    private func updateTitleColor(){
        let titleCOlor: UIColor
        isSelected ? (titleCOlor = selectedTitleColor) : (titleCOlor = titleColor)
        setTitleColor(titleCOlor, for: .normal)
    }
    

}

extension RoutineRepeatControlButton: CAAnimationDelegate{
    
    private func drawCircle(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = fillColor
            
        var width =  self.bounds.width
        if width == 0.0{
            width = 30.0
        }
        let radius = width / 2
        
        
//        let react = CGRect(
//            x: self.bounds.midX - radius,
//            y: self.bounds.midY - radius,
//            width: width,
//            height: width
//        )
        
        let react = CGRect(
            x: 0.0,
            y: 0.0,
            width: width,
            height: width
        )
        
        shapeLayer.path = UIBezierPath(roundedRect: react, cornerRadius: radius).cgPath
        shapeLayer.frame = react
        shapeLayer.cornerRadius = radius
        shapeLayer.masksToBounds = true
        
        self.addedLayer = shapeLayer
        self.layer.addSublayer(shapeLayer)
        
        
        if let titleLabel = self.titleLabel{
            self.bringSubviewToFront(titleLabel)
        }

    }
    
    
    private func addAnimation()
    {
        guard let addedLayer = self.addedLayer else { return }
        
        let layerAnimation = CABasicAnimation(keyPath: "transform.scale")
        layerAnimation.fromValue = 0.0001
        layerAnimation.toValue = 1.0
        layerAnimation.isAdditive = false
        layerAnimation.duration = CFTimeInterval(0.1)
        layerAnimation.fillMode = .backwards
        layerAnimation.isRemovedOnCompletion = true
        
        addedLayer.add(layerAnimation, forKey: "scaleAnimation")
    }
    
    
    private func removeAddedLayer()
    {
        guard let addedLayer = self.addedLayer else { return }
        
        let layerAnimation = CABasicAnimation(keyPath: "transform.scale")
        layerAnimation.fromValue = 1.0
        layerAnimation.toValue = 0.0001
        layerAnimation.isAdditive = false
        layerAnimation.duration = CFTimeInterval(0.1)
        layerAnimation.fillMode = .forwards
        layerAnimation.isRemovedOnCompletion = false
        layerAnimation.delegate = self
        
        addedLayer.add(layerAnimation, forKey: "scaleAnimation")
    }
    
        
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let addedLayer = self.addedLayer, flag {
            addedLayer.removeFromSuperlayer()
        }
    }
    
    
}



// TODO: TODO: FSCalendarCell.m 파일 참고해보기
/**
 *
 *        CGFloat diameter = MIN(MIN(self.fs_width, self.fs_height),FSCalendarMaximumEventDotDiameter);
        for (int i = 0; i < self.eventLayers.count; i++) {
            CALayer *eventLayer = [self.eventLayers pointerAtIndex:i];
            eventLayer.hidden = i >= self.numberOfEvents;
            if (!eventLayer.hidden) {
                eventLayer.frame = CGRectMake(2*i*diameter, (self.fs_height-diameter)*0.5, diameter, diameter);
                if (eventLayer.cornerRadius != diameter/2) {
                    eventLayer.cornerRadius = diameter/2;
                }
            }
        }*
 */
