//
//  RoutineTitleViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs
import UIKit

protocol RoutineTitlePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineTitleViewController: UIViewController, RoutineTitlePresentable, RoutineTitleViewControllable {
    
    weak var listener: RoutineTitlePresentableListener?
    
    
    private let imojiButton : UIButton = {
        let button = TouchesButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        
        button.setFont(style: .largeTitle)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
        button.contentEdgeInsets.top = 8.0
        button.contentEdgeInsets.left = 8.0
        button.contentEdgeInsets.right = 8.0
        button.contentEdgeInsets.bottom = 8.0
        button.roundCorners()
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
    
    private let routineNameTextFeild: UITextField = {
        let textFeild = BottomLineTextField()
        
        textFeild.setFont(style: .title1)
        textFeild.textColor = .label
        textFeild.placeholder = "Give it a name"
        textFeild.textAlignment = .center
        textFeild.becomeFirstResponder()
        
        return textFeild
    }()
    
    private let routineNameHelpLabel: UILabel = {
        let label = UILabel()
        
        label.setFont(style: .caption1)
        label.textColor = .secondaryLabel
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
    
    private let routineDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.setFont(style: .title1)
        textView.textColor = .label
        //textView.placeholder = "Give it a name"
        textView.roundCorners()
        return textView
    }()
    
    private let routineDescriptionHelpLabel: UILabel = {
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
        imojiButton.setTitle("🐢", for: .normal)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
        imojiButton.setTitle("🐢", for: .normal)
    }
    
    private func setLayout(){
        
        view.addSubview(imojiButton)
        view.addSubview(routineNameStackView)
        view.addSubview(routineDescriptionStackView)
        
        routineNameStackView.addArrangedSubview(routineNameTextFeild)
        routineNameStackView.addArrangedSubview(routineNameHelpLabel)
                        
        routineNameStackView.addArrangedSubview(routineDescriptionTextView)
        routineNameStackView.addArrangedSubview(routineDescriptionHelpLabel)
                
        
        NSLayoutConstraint.activate([
            imojiButton.topAnchor.constraint(equalTo: view.topAnchor),
            imojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imojiButton.widthAnchor.constraint(equalToConstant: 80.0),
            imojiButton.heightAnchor.constraint(equalToConstant: 80.0),
            
            routineNameStackView.topAnchor.constraint(equalTo: imojiButton.bottomAnchor, constant: 50.0),
            routineNameStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            routineNameStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            routineDescriptionStackView.topAnchor.constraint(equalTo: routineNameStackView.bottomAnchor, constant: 50.0),
            routineDescriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            routineDescriptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            routineDescriptionStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
            
            routineDescriptionTextView.heightAnchor.constraint(equalToConstant: 120.0)
        ])
        
        routineNameTextFeild.becomeFirstResponder()
    }
    
    
}
