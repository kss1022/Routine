//
//  TimerSectionEditTitleViewController.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs
import UIKit

protocol TimerSectionEditTitlePresentableListener: AnyObject {
    func sectionNameDidEndEditing(name: String)
    func sectionDescriptionDidEndEditing(description: String)
}

final class TimerSectionEditTitleViewController: UIViewController, TimerSectionEditTitlePresentable, TimerSectionEditTitleViewControllable {

    weak var listener: TimerSectionEditTitlePresentableListener?
        
    
    private let emojiButton : UIButton = {
        let button = TouchesButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .label
        
        button.setFont(style: .subheadline)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.contentEdgeInsets.top = 8.0
        button.contentEdgeInsets.left = 8.0
        button.contentEdgeInsets.right = 8.0
        button.contentEdgeInsets.bottom = 8.0
        button.roundCorners()
        return button
    }()
    
    private let sectionNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 24.0
        return stackView
    }()
    
    private let sectionNameTitleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "Name"
        return label
    }()
    
    private lazy var sectionNameTextFeild: UITextField = {
        let textFeild = BottomLineTextField()
        textFeild.setStrokeColor(strokeColor: UIColor.systemGray.cgColor)
        
        textFeild.setFont(style: .title1)
        textFeild.textColor = .label
        textFeild.placeholder = "Give it a name"
        textFeild.textAlignment = .center
        textFeild.delegate = self
        return textFeild
    }()
    
    private let sectionNameHelpLabel: UILabel = {
        let label = UILabel()
        
        label.setFont(style: .caption1)
        label.textColor = .secondaryLabel
        label.text = "0/50"
        label.textAlignment = .right
        
        return label
    }()
    
    
    private let sectionDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 24.0
        return stackView
    }()
    
    private let sectionDescriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "Description"
        return label
    }()
    
    private lazy var sectionDescriptionTextFeild: UITextField = {
        let textFeild = BottomLineTextField()
        textFeild.setStrokeColor(strokeColor: UIColor.systemGray.cgColor)
        
        textFeild.setFont(style: .title1)
        textFeild.textColor = .label
        textFeild.placeholder = "Give it a name"
        textFeild.textAlignment = .center
        textFeild.delegate = self
        return textFeild
    }()
    
    private let sectionDescriptionHelpLabel: UILabel = {
        let label = UILabel()
        
        label.setFont(style: .caption1)
        label.textColor = .secondaryLabel
        label.text = "0/50"
        label.textAlignment = .right
        
        return label
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
        view.addSubview(emojiButton)
        view.addSubview(sectionNameStackView)
        view.addSubview(sectionDescriptionStackView)
        
        
        sectionNameStackView.addArrangedSubview(sectionNameTitleLabel)
        sectionNameStackView.addArrangedSubview(sectionNameTextFeild)
        sectionNameStackView.addArrangedSubview(sectionNameHelpLabel)
                        
        
        sectionDescriptionStackView.addArrangedSubview(sectionDescriptionTitleLabel)
        sectionDescriptionStackView.addArrangedSubview(sectionDescriptionTextFeild)
        sectionDescriptionStackView.addArrangedSubview(sectionDescriptionHelpLabel)
                
        
        NSLayoutConstraint.activate([
            emojiButton.topAnchor.constraint(equalTo: view.topAnchor),
            emojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiButton.widthAnchor.constraint(equalToConstant: 80.0),
            emojiButton.heightAnchor.constraint(equalToConstant: 80.0),
            
            sectionNameStackView.topAnchor.constraint(equalTo: emojiButton.bottomAnchor, constant: 50.0),
            sectionNameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sectionNameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            sectionDescriptionStackView.topAnchor.constraint(equalTo: sectionNameStackView.bottomAnchor, constant: 32.0),
            sectionDescriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sectionDescriptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sectionDescriptionStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
        ])                
    }
    
    func setTitle(emoji: String, name: String, description: String) {
        emojiButton.setTitle(emoji, for: .normal)
        sectionNameTextFeild.text = name
        sectionDescriptionTextFeild.text = description
    }
        

}



extension TimerSectionEditTitleViewController : UITextFieldDelegate{
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if textField == sectionNameTextFeild{
            listener?.sectionNameDidEndEditing(name: text)
        }else if textField == sectionDescriptionTextFeild{
            listener?.sectionDescriptionDidEndEditing(description: text)
        }
    }
        
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.sectionNameTextFeild{
            self.sectionDescriptionTextFeild.becomeFirstResponder()
        }else{
            self.view.endEditing(true)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let before = textField.text{
            let textCount = string.count + before.count
            
            if textCount > 50{
                return false
            }
            
            if textField == sectionNameTextFeild{
                self.sectionNameHelpLabel.text = "\(textCount)/50"
            }else if textField == sectionDescriptionTextFeild{
                self.sectionDescriptionHelpLabel.text = "\(textCount)/50"
            }
        }
        
        return true
    }
    
}

