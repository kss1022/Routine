//
//  EmojiStyleButton.swift
//  Routine
//
//  Created by 한현규 on 11/30/23.
//

import UIKit


final class EmojiStyleCell: UICollectionViewCell{
 
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setVew(){
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: widthAnchor)
        ])
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(frame.height / 2)
    }
    
    func bindView(style: EmojiStyle){
        backgroundColor = style.color
    }
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                layer.borderColor = UIColor.secondaryLabel.cgColor
                layer.borderWidth = 1.0
            }else{
                layer.borderColor = UIColor.clear.cgColor
                layer.borderWidth = 0.0
            }
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .clear
        layer.borderColor = UIColor.clear.cgColor
        layer.borderWidth = 0.0
    }
}


extension EmojiStyleCell{
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
}
