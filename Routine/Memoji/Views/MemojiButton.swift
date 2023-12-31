//
//  MemojiButton.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import Foundation
import UIKit



final class MemojiButton: UIControl{
    
    private var gradientLayer: CAGradientLayer?
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    public init() {
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLayout()
    }

    
    private func setLayout() {
        backgroundColor = .clear
        
        self.addSubview(imageView)
        
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / sqrt(2)),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])
    }
    
    
    func setType(type: MemojiType){
        switch type {
        case .memoji(let image): imageView.image = image
        case .emoji(let string): imageView.image = string.toImage()
        case .text(let string): imageView.image = string.toImage()
        }
    }
    
    func setStyle(style: MemojiStyle){
        if let colorTop = style.topColor?.cgColor,
           let colorBottom = style.bottomColor?.cgColor{
            self.gradientLayer?.removeFromSuperlayer()
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = self.bounds
            
            self.layer.insertSublayer(gradientLayer, at:0)
            self.gradientLayer = gradientLayer
        }
    }

    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        
        self.gradientLayer?.frame = self.bounds
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.7
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.alpha = 1.0
        }
    }
}



