//
//  AppTutorialSplashView2.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import UIKit



final class AppTutorailSplashView2: AppTutorailSplashView{
    
    
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
        titleLabel.text = "splash_1".localized(tableName: "Tutorial")
        
        view.addSubview(titleLabel)
                
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
        ])
        
        
        topAnimation()
    }
    
    private func topAnimation(){
        self.view.alpha = 0.0
        self.view.frame.origin.x += 50
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.x -= 50
            self.view.alpha = 1.0
        }
    }
    
}
