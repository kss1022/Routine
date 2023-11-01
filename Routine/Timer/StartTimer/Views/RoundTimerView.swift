//
//  RoundTimer.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import UIKit



class RoundTimerView: UIControl {
    
    
    var trackLayerStrokeColor: CGColor = UIColor.tertiaryLabel.cgColor
    var barLayerStrokeColor: CGColor = UIColor.systemOrange.cgColor
    var lineWidth = 16.0
    
    private lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor        
        layer.lineWidth = lineWidth
        return layer
    }()
    
    private lazy var barLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = lineWidth
        return layer
    }()
    
    
    init(){
        super.init(frame: .zero)
        
        setLayer()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        
        setLayer()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        barLayer.frame = bounds
        barLayer.strokeColor = barLayerStrokeColor
        
        trackLayer.frame = bounds
        trackLayer.strokeColor = trackLayerStrokeColor


        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        var radius: CGFloat { (bounds.height - lineWidth) / 2 }
        let startAngle = -90.degreesToRadians
        let basePath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: CGFloat.pi * 2,
            clockwise: true
        )
        let progressPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: CGFloat.pi * 2 + startAngle, //CGFloat.pi * 2,
            //endAngle: CGFloat.pi * 2,,
            clockwise: true
        )
        
        trackLayer.path = basePath.cgPath
        barLayer.path = progressPath.cgPath
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
    

    private func setLayer() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(barLayer)
    }
    
    
    func startProgress(duration: TimeInterval) {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 1.0
        strokeAnimation.toValue = 0.0
        strokeAnimation.beginTime = CACurrentMediaTime()
        //strokeAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        strokeAnimation.fillMode = .forwards
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.duration = duration

        barLayer.beginTime = 0.0
        barLayer.add(strokeAnimation, forKey: "strokeAnimation")
        //barLayer.strokeEnd = to
    }
    
    func updateProgress(from: CGFloat, remainDuration: TimeInterval) {
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = from
        strokeAnimation.toValue = 0.0
        strokeAnimation.beginTime = CACurrentMediaTime()
        //strokeAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        strokeAnimation.fillMode = .forwards
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.duration = remainDuration
                
        barLayer.add(strokeAnimation, forKey: "strokeAnimation")
        
        suspendProgress()
    }
    
    func resumeProgress(){
        let pausedTime = barLayer.timeOffset
        barLayer.speed = 1.0
        barLayer.timeOffset = 0.0
        barLayer.beginTime = 0.0
        let timeSincePause = barLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        barLayer.beginTime = timeSincePause
    }
    
    func suspendProgress(){
        let pausedTime = barLayer.convertTime(CACurrentMediaTime(), from: nil)
        barLayer.speed = 0.0
        barLayer.timeOffset = pausedTime
    }
        

}


private extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
