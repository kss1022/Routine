//
//  AppTutorailSplashView1.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import UIKit


final class AppTutorailSplashView1: AppTutorailSplashView{
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    func setLayout() {
        let titleLabel = self.titleLabel()
        titleLabel.numberOfLines = 2
        titleLabel.text = "Promise to myself."
        
        let emojiLabel = self.emojiLabel()
        emojiLabel.text = "🤙"
        
        
        view.addSubview(titleLabel)
        view.addSubview(emojiLabel)
        
        let emojiSize: CGFloat = 60.0
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: emojiSize + inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(emojiSize + inset)),
            
            
            
            emojiLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            emojiLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: emojiSize),
            emojiLabel.heightAnchor.constraint(equalToConstant: emojiSize)
        ])
        
        
        topAnimation()
    }
    
    private func topAnimation(){
        self.view.alpha = 0.0
        self.view.frame.origin.y += 50
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y -= 50
            self.view.alpha = 1.0
        }
    }
    
}
