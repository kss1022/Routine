//
//  TimerEditTitleViewController.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import ModernRIBs
import UIKit

protocol TimerEditTitlePresentableListener: AnyObject {
    func didSetName(name: String)
    func didSetEmoji(emoji: String)
}

final class TimerEditTitleViewController: UIViewController, TimerEditTitlePresentable, TimerEditTitleViewControllable {

    weak var listener: TimerEditTitlePresentableListener?
    
    private lazy var emojiButton : UIButton = {
        let button = TouchesButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .label

        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        button.contentEdgeInsets.top = 8.0
        button.contentEdgeInsets.left = 8.0
        button.contentEdgeInsets.right = 8.0
        button.contentEdgeInsets.bottom = 8.0
        button.roundCorners()
        
        button.addTarget(self, action: #selector(emojiButtonTap), for: .touchUpInside)
        return button
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 24.0
        return stackView
    }()
    

    private lazy var nameTextFeild: UITextField = {
        let textFeild = BottomLineTextField()
        textFeild.setStrokeColor(strokeColor: UIColor.systemGray.cgColor)
        
        textFeild.setFont(style: .title1)
        textFeild.textColor = .label
        
        textFeild.attributedPlaceholder = NSAttributedString(
            string: "give_it_a_name".localized(tableName: "Routine"),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        
        textFeild.textAlignment = .center
        textFeild.delegate = self
        return textFeild
    }()
    

    
    private let validationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .trailing
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let nameValidationLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption1)
        label.textColor = .red
        label.text = "minumum_chracters".localizedWithFormat(tableName: "Timer", arguments: 2)
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()
    
    private let nameCountLabel: UILabel = {
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
        view.addSubview(nameStackView)
                
        nameStackView.addArrangedSubview(nameTextFeild)
        nameStackView.addArrangedSubview(validationStackView)
        
        validationStackView.addArrangedSubview(nameValidationLabel)
        validationStackView.addArrangedSubview(nameCountLabel)
                
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            emojiButton.topAnchor.constraint(equalTo: view.topAnchor),
            emojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiButton.widthAnchor.constraint(equalToConstant: 80.0),
            emojiButton.heightAnchor.constraint(equalToConstant: 80.0),
                        
            nameStackView.topAnchor.constraint(equalTo: emojiButton.bottomAnchor, constant: 50.0),
            nameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            nameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            nameStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        emojiButton.setTitle("🍅", for: .normal)
    }
    
    
    //MARK: Presentable
    func setName(_ name: String) {
        nameTextFeild.text = name
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

extension TimerEditTitleViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != nameTextFeild{
            return
        }
        
        if let name = textField.text{
            nameValidationLabel.isHidden = name.count >= 2
            listener?.didSetName(name: name)
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
            
            self.nameCountLabel.text = "\(textCount)/50"
        }
        
        nameValidationLabel.isHidden = true
        return true
    }
    
}

extension TimerEditTitleViewController: EmojiPickerDelegate{
    func didGetEmoji(emoji: String) {        
        listener?.didSetEmoji(emoji: emoji)
    }
}
