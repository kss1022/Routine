//
//  AppTutorailSplashView.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import Foundation
import UIKit
import Lottie


class AppTutorailSplashView: UIViewController{
    
    func titleLabel() ->UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 48.0)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    func emojiLabel() -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 48.0)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        return label
    }
        
    
    func animationView() -> LottieAnimationView{
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }
}
