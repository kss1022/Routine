//
//  RoutineEditTitleViewController.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs
import UIKit

protocol RoutineEditTitlePresentableListener: AnyObject {
    func didSetRoutineName(name : String)
    func didSetRoutineDescription(description: String)
    func didSetEmoji(emoji: String)
}

final class RoutineEditTitleViewController: UIViewController, RoutineEditTitlePresentable, RoutineEditTitleViewControllable {

    weak var listener: RoutineEditTitlePresentableListener?
    
    
    private lazy var emojiButton : UIButton = {
        let button = TouchesButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.contentEdgeInsets.top = 8.0
        button.contentEdgeInsets.left = 8.0
        button.contentEdgeInsets.right = 8.0
        button.contentEdgeInsets.bottom = 8.0
        button.roundCorners()
        
        button.addTarget(self, action: #selector(emojiButtonTap), for: .touchUpInside)
        return button
    }()
    
    private let routineNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 24.0
        return stackView
    }()
    
    private lazy var routineNameTextFeild: UITextField = {
        let textFeild = BottomLineTextField()
        textFeild.setStrokeColor(strokeColor: UIColor.systemGray.cgColor)
        
        textFeild.setFont(style: .title1)
        textFeild.textColor = .black
        
        textFeild.attributedPlaceholder = NSAttributedString(
            string: "give_it_a_name".localized(tableName: "Routine"),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        
        textFeild.textAlignment = .center
        textFeild.delegate = self
        return textFeild
    }()
    
    private let routineNameHelpStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let routineNameMinimumLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption1)
        label.textColor = .red
        label.text = "minumum_chracters".localizedWithFormat(tableName: "Routine", arguments: 2)
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    
    private let routineNameCountLabel: UILabel = {
        let label = UILabel()
        
        label.setFont(style: .caption1)
        label.textColor = .systemGray
        label.text = "0/50"
        label.textAlignment = .right
        
        return label
    }()
    
    
    private let routineDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let routineDescriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .headline)
        label.textColor = .black
        label.text = "description".localized(tableName: "Routine")
        return label
    }()
    
    private lazy var routineDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.setFont(style: .callout)
        textView.textColor = .label
                            
        textView.roundCorners()
        textView.textContainerInset = .init(top: 16.0, left: 8.0, bottom: 16.0, right: 8.0)
        textView.delegate = self
        return textView
    }()
    
    private let routineDescriptionHelpLabel: UILabel = {
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
        
        view.addSubview(emojiButton)
        view.addSubview(routineNameStackView)
        view.addSubview(routineDescriptionStackView)
        
        routineNameStackView.addArrangedSubview(routineNameTextFeild)
        routineNameStackView.addArrangedSubview(routineNameHelpStackView)
        
        routineNameHelpStackView.addArrangedSubview(routineNameMinimumLabel)
        routineNameHelpStackView.addArrangedSubview(routineNameCountLabel)
        
        routineDescriptionStackView.addArrangedSubview(routineDescriptionTitleLabel)
        routineDescriptionStackView.addArrangedSubview(routineDescriptionTextView)
        routineDescriptionStackView.addArrangedSubview(routineDescriptionHelpLabel)
                
        
        NSLayoutConstraint.activate([
            emojiButton.topAnchor.constraint(equalTo: view.topAnchor),
            emojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiButton.widthAnchor.constraint(equalToConstant: 80.0),
            emojiButton.heightAnchor.constraint(equalToConstant: 80.0),
            
            routineNameStackView.topAnchor.constraint(equalTo: emojiButton.bottomAnchor, constant: 50.0),
            routineNameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            routineNameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            routineDescriptionStackView.topAnchor.constraint(equalTo: routineNameStackView.bottomAnchor, constant: 32.0),
            routineDescriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            routineDescriptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            routineDescriptionStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
            
            routineDescriptionTextView.heightAnchor.constraint(equalToConstant: 120.0)
        ])
    }
    
    func setTitle(emoji: String, routineName: String?, routineDescription: String?) {
        emojiButton.setTitle(emoji, for: .normal)
        routineNameTextFeild.text = routineName
        routineDescriptionTextView.text = routineDescription
        
        if let nameCount = routineName?.count,
           let descriptionCount = routineDescription?.count{
            routineNameCountLabel.text = "\(nameCount)/50"
            routineDescriptionHelpLabel.text = "\(descriptionCount)/50"
        }
        
    }
    
    
    func setEmoji(_ emoji: String) {
        emojiButton.setTitle(emoji, for: .normal)
    }
    
    
    @objc
    private func emojiButtonTap(){
        let viewController = EmojiPickerViewController()
        viewController.delegate = self
        viewController.sourceView = emojiButton
        present(viewController, animated: true)
    }
    
    
}

extension RoutineEditTitleViewController: EmojiPickerDelegate{
    func didGetEmoji(emoji: String) {        
        listener?.didSetEmoji(emoji: emoji)
    }
}


extension RoutineEditTitleViewController : UITextFieldDelegate{
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != self.routineNameTextFeild{
            return
        }
        
        if let name = textField.text{
            routineNameMinimumLabel.isHidden = name.count >= 2
            listener?.didSetRoutineName(name: name)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.routineDescriptionTextView.becomeFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let before = textField.text as? NSString{
            let text = before.replacingCharacters(in: range, with: string)
            let textCount = text.count
            
            if textCount > 50{
                return false
            }
            
            self.routineNameCountLabel.text = "\(textCount)/50"
        }
        
        routineNameMinimumLabel.isHidden = true        
        return true
    }
}

extension RoutineEditTitleViewController : UITextViewDelegate{
    

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView != self.routineDescriptionTextView{
            return
        }
        
        if let description = textView.text{
            listener?.didSetRoutineDescription(description: description)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textCount = text.count + textView.text.count
        
        if textCount > 50{
            return false
        }
        
        self.routineDescriptionHelpLabel.text = "\(textCount)/50"
        
        return true
    }

}
