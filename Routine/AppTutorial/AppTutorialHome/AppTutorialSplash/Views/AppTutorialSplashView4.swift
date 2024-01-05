//
//  AppTutorialSplashView4.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import UIKit
import Lottie


final class AppTutorailSplashView4: AppTutorailSplashView{
    
    
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
        titleLabel.text = "splash_3".localized(tableName: "Tutorial")

        let animationView = self.animationView()
        animationView.contentMode = .scaleAspectFit

        
        let animation = LottieAnimation.named("Lottie_Confetti")
        animationView.animation = animation
        
        
        view.addSubview(animationView)
        view.addSubview(titleLabel)
        
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor),
   
            
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
        ])
        
        
        topAnimation()
        animationView.play()
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
