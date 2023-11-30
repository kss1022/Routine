//
//  MemojiStyleCell.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import UIKit


final class MemojiStyleCell: UICollectionViewCell{
    
    private var gradientLayer: CAGradientLayer?
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setLayout() {
        backgroundColor = .clear
        layer.cornerRadius = self.frame.size.height / 2
        clipsToBounds = true
        
        contentView.addSubview(imageView)
        
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.0 / sqrt(2)),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])
    }
    
    
    func bindView(style: MemojiStyle, image: UIImage? = nil){
        imageView.image = image
        setStyle(style)
    }
    
    
    
    func setStyle(_ style: MemojiStyle) {
        if let colorTop =  style.topColor?.cgColor,
           let colorBottom = style.bottomColor?.cgColor{
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [colorTop, colorBottom]
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.frame = self.bounds
            
            self.layer.insertSublayer(gradientLayer, at:0)
            self.gradientLayer = gradientLayer
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientLayer?.removeFromSuperlayer()
        imageView.image = nil
    }
    
    
}
