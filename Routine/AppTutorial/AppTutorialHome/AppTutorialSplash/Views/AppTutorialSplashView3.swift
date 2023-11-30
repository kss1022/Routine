//
//  AppTutorialSplashView3.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import UIKit
import Lottie


final class AppTutorailSplashView3: AppTutorailSplashView{
    
    
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
        titleLabel.text = "Check without Pressure."

        let animationView = self.animationView()
        animationView.contentMode = .scaleAspectFit

        
        let animation = LottieAnimation.named("Lottie_Complete")
        animationView.animation = animation
        
        
        view.addSubview(titleLabel)
        view.addSubview(animationView)
                
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            animationView.heightAnchor.constraint(equalTo: view.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            titleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64)
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
