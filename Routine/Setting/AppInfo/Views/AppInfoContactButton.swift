//
//  AppInfoContactButton.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import UIKit




final class AppInfoContactButton: UIControl{
    
    private var tapHandler: (() -> Void)?

    private var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.font = .systemFont(ofSize: 18.0)
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints =  false
        label.font = .getFont(size: 18.0)
        label.textColor = .black
        return label
    }()
    
    init(_ viewModel: AppInfoContactViewModel){
        super.init(frame: .zero)
        
        setView()
        self.emojiLabel.text = viewModel.emoji
        self.titleLabel.text = viewModel.title
        self.backgroundColor = viewModel.backgroundColor
        self.tapHandler = viewModel.tapHandler
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    
  
    
    private func setView(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)
        
        roundCorners()
        
        addSubview(emojiLabel)
        addSubview(titleLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            emojiLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            
            
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.titleLabel.alpha = 0.7
            self.emojiLabel.alpha = 0.7
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
            self.titleLabel.alpha = 1
            self.emojiLabel.alpha = 1
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
            self.titleLabel.alpha = 1
            self.emojiLabel.alpha = 1
        }
    }
    
    @objc
    private func didTap(){
        self.tapHandler?()
    }
}
