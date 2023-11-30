//
//  AppTutorialMainViewController.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs
import UIKit

protocol AppTutorialMainPresentableListener: AnyObject {
    func continueButtonDidTap()
}

final class AppTutorialMainViewController: UIViewController, AppTutorialMainPresentable, AppTutorialMainViewControllable {

    weak var listener: AppTutorialMainPresentableListener?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 48.0)
        label.textColor = .white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 32.0)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var continueButton: TouchesRoundButton = {
        let button = TouchesRoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .getFont(size: 24.0)
        button.setTitle("Continue", for: .normal)
                        
        button.contentEdgeInsets = .init(top: 16.0, left: 32.0, bottom: 16.0, right: 32.0)
        button.addTarget(self, action: #selector(continueButtonTap), for: .touchUpInside)
        return button
    }()
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    private func setLayout(){        
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(continueButton)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -inset),
            
            
            subTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: inset),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -inset),
            subTitleLabel.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -inset),
            
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        titleLabel.text = "Hello there 👋"
        subTitleLabel.text = "Let's embark on a journey together to form new habits and achieve your goals."
    }

    
    @objc
    private func continueButtonTap(){
        listener?.continueButtonDidTap()
    }
}
