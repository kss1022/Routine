//
//  AppTutorialProfileViewController.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs
import UIKit

protocol AppTutorialProfilePresentableListener: AnyObject {
    func memojiButtonDidTap()
    func continueButtonDidTap()
}

final class AppTutorialProfileViewController: UIViewController, AppTutorialProfilePresentable, AppTutorialProfileViewControllable {

    weak var listener: AppTutorialProfilePresentableListener?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 48.0)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        return label
    }()
    
    
    private lazy var memojiButton: MemojiButton = {
        let memoji = MemojiButton()
        memoji.translatesAutoresizingMaskIntoConstraints = false
        memoji.addTarget(self, action: #selector(memojiButtonTap), for: .touchUpInside)
        return memoji
    }()
    
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    
    private let nameLable: UILabel = {
        let label = UILabel()
        label.font =  .getBoldFont(size: 24.0)
        label.textColor = .label
        return label
    }()
    
    private let descriptoinLable: UILabel = {
        let label = UILabel()
        label.font =  .getFont(size: 18.0)
        label.textColor = .secondaryLabel
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
        view.backgroundColor = .primaryColor

        view.addSubview(titleLabel)
        view.addSubview(memojiButton)
        view.addSubview(labelStackView)
        view.addSubview(continueButton)
        
        labelStackView.addArrangedSubview(nameLable)
        labelStackView.addArrangedSubview(descriptoinLable)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -inset),
                                    
            memojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memojiButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            memojiButton.widthAnchor.constraint(equalToConstant: 240.0),
            memojiButton.heightAnchor.constraint(equalToConstant: 240.0),
            
            labelStackView.topAnchor.constraint(equalTo: memojiButton.bottomAnchor, constant: 16.0),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            
            
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        titleLabel.text = "Set a profile memoji that represents you"
    }
    

    func setType(type: MemojiType) {
        memojiButton.setType(type: type)
    }
    

    func setStyle(style: MemojiStyle) {
        memojiButton.setStyle(style: style)
    }
    

    @objc
    private func memojiButtonTap(){
        listener?.memojiButtonDidTap()
    }

    @objc
    private func continueButtonTap(){
        listener?.continueButtonDidTap()
    }
}
