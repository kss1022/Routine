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
    private var fillColor: CGColor = UIColor.primaryColor.cgColor
       
    
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        updateForLayoutIfNeed()
//    }
    
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
    
//    private func updateForLayoutIfNeed(){
//        Log.v("UpdateForLayoutIfNeed")
//                
//        if isSelected {
//            removeAddedLayer()
//            drawCircle()
//        }
//    }
    
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
            
        let width =  self.bounds.width
        let radius = width / 2
        
        
        let react = CGRect(
            x: self.bounds.midX - radius,
            y: self.bounds.midY - radius,
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
