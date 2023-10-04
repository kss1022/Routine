//
//  RoutineTitleViewController.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
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
    
    
    private var emojiLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(style: .largeTitle)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let routineNameLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .title1)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let routineDescriptionLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .headline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var checkButton: UIButton = {
        let button = TouchesButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        button.setTitle("Complete", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = .label
        
        let buttonInset: CGFloat = 16.0
        
        button.contentEdgeInsets.top = buttonInset
        button.contentEdgeInsets.bottom = buttonInset
        button.contentEdgeInsets.left = buttonInset
        button.contentEdgeInsets.right = buttonInset
        
        button.roundCorners(24.0)
        
        button.addTarget(self, action: #selector(checkButtonTap), for: .touchUpInside)
        return button
    }()

    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()        
    }
    
    private func setLayout(){
     
        view.addSubview(emojiLabel)
        view.addSubview(stackView)
        view.addSubview(checkButton)
        
        stackView.addArrangedSubview(routineNameLabel)
        stackView.addArrangedSubview(routineDescriptionLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: view.topAnchor),
            emojiLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiLabel.widthAnchor.constraint(equalToConstant: 80.0),
            emojiLabel.heightAnchor.constraint(equalToConstant: 80.0),
            
            stackView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 8.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            checkButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32.0),
            checkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            checkButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
            
            checkButton.heightAnchor.constraint(equalToConstant: 48.0)
        ])
        
        
    }
    
    func setRoutineTitle(_ viewModel: RoutineTitleViewModel) {
        emojiLabel.text = viewModel.emojiIcon
        routineNameLabel.text = viewModel.routineName
        routineDescriptionLabel.text = viewModel.routineDescription
    }
    
    @objc
    private func checkButtonTap(){
        
    }

}
