//
//  TimerStartButton.swift
//  Routine
//
//  Created by 한현규 on 10/25/23.
//

import UIKit


class TimerStartButton: UIControl {
    
    private var fillLayerStrokeColor: CGColor = UIColor.systemOrange.withAlphaComponent(0.6).cgColor
    private var dashLayerStrokeColor: CGColor = UIColor.systemOrange.withAlphaComponent(0.6).cgColor
    
    
    private var lineWidth = 16.0
    
    
    private lazy var fillLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        //layer.strokeColor = fillLayerStrokeColor
        layer.fillColor = fillLayerStrokeColor
        layer.lineWidth = lineWidth
        return layer
    }()
    
    private lazy var dashLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = dashLayerStrokeColor
        layer.lineWidth = 2.0
        layer.lineJoin = .round
        layer.lineDashPattern = [3, 4, 5, 4]

        return layer
    }()

    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 44.0, weight: .regular)
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    init(){
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        fillLayer.frame = bounds
        dashLayer.frame = bounds

        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        var radius: CGFloat { (bounds.height - lineWidth) / 2 }
        
        let fillPath = UIBezierPath(
            arcCenter: center,
            radius: radius - 8.0,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: true
        )
                
        
        let dashPath = UIBezierPath(
            arcCenter: center,
            radius: radius + 8.0,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,    // + startAngle, //CGFloat.pi * 2,
            clockwise: true
        )
        
        
        fillLayer.path = fillPath.cgPath
        dashLayer.path = dashPath.cgPath
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.7
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
            self.alpha = 0.7
        }
    }
    
    
    func setTime(time: String){
        timeLabel.text = time
    }
    
    private func setLayout() {
        layer.addSublayer(fillLayer)
        layer.addSublayer(dashLayer)
                
        addSubview(timeLabel)
               
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
        ])
        
        
        startDashAnimation()
    }
    
    func setTimeLabel(time: String){
        timeLabel.text = time
    }

    
    func startDashAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = dashLayer.lineDashPattern?.reduce(0) { $0 + $1.intValue } // pattern lenght sum
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = .infinity
        dashLayer.add(rotationAnimation, forKey: "lineDashPhaseAnimation")
    }

}


private extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}




