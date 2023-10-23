//
//  TimerEditTitleViewController.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import ModernRIBs
import UIKit

protocol TimerEditTitlePresentableListener: AnyObject {
    func setTimerName(name: String)
}

final class TimerEditTitleViewController: UIViewController, TimerEditTitlePresentable, TimerEditTitleViewControllable {

    weak var listener: TimerEditTitlePresentableListener?
    
    private lazy var timeNameTextFeild: UITextField = {
        let textFeild = PaddingTextFeild()
        textFeild.padding = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        textFeild.translatesAutoresizingMaskIntoConstraints = false
        textFeild.borderStyle = .roundedRect
        textFeild.backgroundColor = .label
        
        textFeild.setFont(style: .title1)
        textFeild.textColor = .systemBackground
        
        textFeild.attributedPlaceholder = NSAttributedString(
            string: "Give it a name",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        
        textFeild.textAlignment = .center
        textFeild.placeholder = "Give it a name"
        textFeild.delegate = self
        
        
        return textFeild
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
        view.addSubview(timeNameTextFeild)
        
        let inset: CGFloat = 8.0
        
        NSLayoutConstraint.activate([
            timeNameTextFeild.topAnchor.constraint(equalTo: view.topAnchor),
            timeNameTextFeild.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            timeNameTextFeild.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            timeNameTextFeild.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TimerEditTitleViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != timeNameTextFeild{
            return
        }
        
        if let name = textField.text{
            listener?.setTimerName(name: name)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let before = textField.text{
            let textCount = string.count + before.count
            
            if textCount > 50{
                return false
            }
        }
        
        return true
    }
    
}

