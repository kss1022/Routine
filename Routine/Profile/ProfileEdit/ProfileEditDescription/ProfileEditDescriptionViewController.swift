//
//  ProfileEditDescriptionViewController.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import ModernRIBs
import UIKit

protocol ProfileEditDescriptionPresentableListener: AnyObject {
    func didMove()
    func doneButtonDidTap(description: String?)
}

final class ProfileEditDescriptionViewController: UIViewController, ProfileEditDescriptionPresentable, ProfileEditDescriptionViewControllable {
    
    weak var listener: ProfileEditDescriptionPresentableListener?
    
    private lazy var doneBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonTap))
        return barButtonItem
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 34.0)
        label.numberOfLines = 2
        label.text = "Enter the description you want to change"
        return label
    }()
    
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4.0
        return stackView
    }()
    
    
    private lazy var descriptionTextFeild: UITextField = {
        let textFeild = PaddingTextFeild(inset: .init(top: 16.0, left: 8.0, bottom: 16.0, right: 8.0))
        
        textFeild.setFont(style: .headline)
        textFeild.textColor = .label
        
        textFeild.borderStyle = .roundedRect
        textFeild.layer.cornerCurve = .circular
        
        textFeild.backgroundColor = .secondarySystemBackground
        textFeild.returnKeyType = .done
        
        
        textFeild.placeholder = "Description"
        textFeild.delegate = self
        
        return textFeild
    }()
    
    
    
    private let descriptionHelpLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption2)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.text = "0/50"
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
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(descriptionTextFeild)
        stackView.addArrangedSubview(descriptionHelpLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
        ])
        
        
        descriptionTextFeild.becomeFirstResponder()
    }
    
    func setDescription(description: String) {
        descriptionTextFeild.text = description
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent == nil{
            listener?.didMove()
        }
    }
    
    @objc
    private func doneBarButtonTap(){
        descriptionTextFeild.resignFirstResponder()
        listener?.doneButtonDidTap(description: descriptionTextFeild.text)
    }
    
}



extension ProfileEditDescriptionViewController: UITextFieldDelegate{
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let before = textField.text{
            let textCount = string.count + before.count
            
            if textCount > 50{
                return false
            }
            
            self.descriptionHelpLabel.text = "\(textCount)/50"
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        listener?.doneButtonDidTap(description: textField.text)
        return true
    }
}
