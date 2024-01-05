//
//  ProfileEditNameViewController.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import ModernRIBs
import UIKit

protocol ProfileEditNamePresentableListener: AnyObject {
    func didMove()
    func doneButtonDidTap(name: String?)
}

final class ProfileEditNameViewController: UIViewController, ProfileEditNamePresentable, ProfileEditNameViewControllable {

    weak var listener: ProfileEditNamePresentableListener?
    
    
    private lazy var doneBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonTap))
        return barButtonItem
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 34.0)
        label.numberOfLines = 2
        label.text = "add_your_name".localized(tableName: "Profile")
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
    
    
    private lazy var nameTextFeild: UITextField = {
        let textFeild = PaddingTextFeild(inset: .init(top: 16.0, left: 8.0, bottom: 16.0, right: 8.0))
        
        textFeild.setFont(style: .headline)
        textFeild.textColor = .label
        
        textFeild.borderStyle = .roundedRect
        textFeild.layer.cornerCurve = .circular
        
        textFeild.backgroundColor = .secondarySystemBackground
        textFeild.returnKeyType = .done

        
        textFeild.placeholder = "name".localized(tableName: "Profile")
        textFeild.delegate = self
        
        return textFeild
    }()
    
    private let nameHelpLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption2)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.text = "0/30"
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
                
        stackView.addArrangedSubview(nameTextFeild)
        stackView.addArrangedSubview(nameHelpLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
        ])
        
        
        nameTextFeild.becomeFirstResponder()
    }
    
    func setName(name: String) {
        nameTextFeild.text = name
        nameHelpLabel.text = "\(name.count)/30"
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent == nil{
            listener?.didMove()
        }
    }
    
    @objc
    private func doneBarButtonTap(){
        nameTextFeild.resignFirstResponder()
        listener?.doneButtonDidTap(name: nameTextFeild.text)
    }
    
}



extension ProfileEditNameViewController: UITextFieldDelegate{
    
 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let before = textField.text{
            let textCount = string.count + before.count
            
            if textCount > 30{
                return false
            }
            
            self.nameHelpLabel.text = "\(textCount)/30"
        }
                
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        listener?.doneButtonDidTap(name: textField.text)
        return true
    }
}
