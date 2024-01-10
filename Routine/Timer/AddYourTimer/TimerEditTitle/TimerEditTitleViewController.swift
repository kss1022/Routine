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
    
    private let timerNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        return stackView
    }()
    
    
    private lazy var timeNameTextFeild: UITextField = {
        let textFeild = PaddingTextFeild()
        textFeild.padding = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        textFeild.translatesAutoresizingMaskIntoConstraints = false
        textFeild.borderStyle = .roundedRect
        textFeild.backgroundColor = .label
        
        textFeild.setFont(style: .title1)
        textFeild.textColor = .systemBackground
        
        textFeild.attributedPlaceholder = NSAttributedString(
            string: "give_it_a_name".localized(tableName: "Timer"),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        
        textFeild.textAlignment = .center
        textFeild.placeholder = "give_it_a_name".localized(tableName: "Timer")
        textFeild.delegate = self
        
        
        return textFeild
    }()
    
    
    private let timerNameHelpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let timerNameMinimumLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption1)
        label.textColor = .red
        label.text = "minumum_chracters".localizedWithFormat(tableName: "Timer", arguments: 2)
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    
    private let timerNameCountLabel: UILabel = {
        let label = UILabel()
        
        label.setFont(style: .caption1)
        label.textColor = .systemGray
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
        view.addSubview(timerNameStackView)
        
        timerNameStackView.addArrangedSubview(timeNameTextFeild)
        timerNameStackView.addArrangedSubview(timerNameHelpStackView)
        
        timerNameHelpStackView.addArrangedSubview(timerNameMinimumLabel)
        timerNameHelpStackView.addArrangedSubview(timerNameCountLabel)
        
        
        let inset: CGFloat = 8.0
        
        NSLayoutConstraint.activate([
            timerNameStackView.topAnchor.constraint(equalTo: view.topAnchor),
            timerNameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            timerNameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            timerNameStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension TimerEditTitleViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != timeNameTextFeild{
            return
        }
        
        if let name = textField.text{
            timerNameMinimumLabel.isHidden = name.count >= 2
            listener?.setTimerName(name: name)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let before = textField.text as? NSString{
            let text = before.replacingCharacters(in: range, with: string)
            let textCount = text.count
            
            if textCount > 50{
                return false
            }
            
            self.timerNameCountLabel.text = "\(textCount)/50"
        }
        
        timerNameMinimumLabel.isHidden = true
        return true
    }
    
}

