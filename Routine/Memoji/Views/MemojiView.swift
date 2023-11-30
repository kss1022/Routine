//
//  MemojiView.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//


import UIKit


public class MemojiView: UIView {
    
    
    public var onChange: ((UIImage, MemojiType) -> Void)?    
    public var onFocus: (() -> Void)?
    
    private var gradientLayer: CAGradientLayer?
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textView: MemojiTextField = {
        let tv = MemojiTextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.emojiDelegate = self
        return tv
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
        self.addSubview(textView)
        
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0 / sqrt(2)),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setType(_ type: MemojiType){
        switch type {
        case .memoji(let image): imageView.image = image
        case .emoji(let string): imageView.image = string.toImage()
        case .text(let string): imageView.image = string.toImage()            
        }
        
    }
    
    func setStyle(_ style: MemojiStyle) {
        if let colorTop =  style.topColor?.cgColor,
           let colorBottom = style.bottomColor?.cgColor{
            gradientLayer?.removeFromSuperlayer()
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = self.bounds
            
            self.layer.insertSublayer(gradientLayer, at:0)
            self.gradientLayer = gradientLayer
        }
    }
    
    func setEditable(isEditable: Bool){
        textView.isUserInteractionEnabled = isEditable
    }
    
    
    func focus(){
        self.textView.becomeFirstResponder()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        
        self.gradientLayer?.frame = self.bounds
    }

}

//MARK: -MemojiTextFieldDelegate
extension MemojiView: MemojiTextFieldDelegate {
    func didUpdateEmoji(emoji: UIImage?, type: MemojiType) {
        self.imageView.image = emoji
        
        guard let image = emoji else {return}
        self.onChange?(image, type)
    }
    
    func didBeginEditing() {
        self.onFocus?()
    }
}
