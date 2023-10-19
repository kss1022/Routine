//
//  CircularTimerView.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation
import UIKit


class CircularTimerView: UIControl {
    
    
    private var trackLayerStrokeColor: CGColor = UIColor.tertiaryLabel.cgColor
    private var barLayerStrokeColor: CGColor = UIColor.systemOrange.cgColor
    private var lineWidth = 16.0
    
    private lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = trackLayerStrokeColor
        layer.lineWidth = lineWidth
        return layer
    }()
    
    private lazy var barLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = barLayerStrokeColor
        layer.lineWidth = lineWidth
        return layer
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 50.0, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 44.0, weight: .regular)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4.0
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21.0, weight: .regular)
        label.textAlignment = .center
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let descriptoinLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .regular)
        label.textAlignment = .center
        label.textColor = .label
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
        barLayer.frame = bounds
        trackLayer.frame = bounds


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
    
    func bindView(_ viewModel: CircularTimerViewModel){
        emojiLabel.text = viewModel.emoji
        nameLabel.text = viewModel.name
        timeLabel.text = viewModel.time
        descriptoinLabel.text = viewModel.description
    }
    
    private func setLayout() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(barLayer)
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(emojiLabel)
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(bottomStackView)
    
        
        bottomStackView.addArrangedSubview(nameLabel)
        bottomStackView.addArrangedSubview(descriptoinLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8),
        ])
    }
    
    func setTimeLabel(time: String){
        timeLabel.text = time
    }
    
    var strokeAnimation: CABasicAnimation?
    
    private var strokeEnd: CGFloat!
    
    func startProgress(duration: TimeInterval) {
                        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 1.0
        strokeAnimation.toValue = 0.0
        strokeAnimation.beginTime = CACurrentMediaTime()
        //strokeAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
        strokeAnimation.fillMode = .forwards
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.duration = duration
        self.strokeAnimation = strokeAnimation
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
                
        self.strokeAnimation = strokeAnimation
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
