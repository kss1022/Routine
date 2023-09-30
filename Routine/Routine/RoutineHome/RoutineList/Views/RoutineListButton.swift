//
//  RoutineListButton.swift
//  Routine
//
//  Created by 한현규 on 2023/09/27.
//

import Foundation
import UIKit



final class RoutineListButton: UIControl{
    
    private var tapHandler: (() -> Void)?
    private var checkButtonTapHandler: (() -> Void)?
    
    private let emojiIconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(style: .largeTitle)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .headline)
        label.textColor = .label
        return label
    }()
    
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let checkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = .init(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        return button
    }()
    
    init(_ viewModel: RoutineListViewModel){
        super.init(frame: .zero)

        setView()
        bindView(viewModel)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }

    
    private func setView(){
        addSubview(emojiIconLabel)
        addSubview(stackView)
        addSubview(checkButton)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)

        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            emojiIconLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8.0),
            emojiIconLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            emojiIconLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            emojiIconLabel.widthAnchor.constraint(equalTo: emojiIconLabel.heightAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: self.emojiIconLabel.trailingAnchor, constant: 8.0),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor, constant: -8.0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset),
            
            checkButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8.0),
            checkButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            checkButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            checkButton.widthAnchor.constraint(equalTo: checkButton.heightAnchor),
        ])
        
        nameLabel.setContentHuggingPriority(.init(249.0), for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.init(752.0), for: .vertical)
        
        descriptionLabel.setContentHuggingPriority(.init(249.0), for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.init(752.0), for: .vertical)
        
        self.roundCorners()
    }

    private func bindView(_ viewModel: RoutineListViewModel){
        backgroundColor = viewModel.color
        
        self.emojiIconLabel.text = viewModel.emojiIcon
        self.nameLabel.text = viewModel.name
        self.descriptionLabel.text = viewModel.description
        self.checkButton.isSelected = viewModel.isChecked
        
        if viewModel.isChecked{
            self.checkButton.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            self.checkButton.tintColor = .green
        }else{
            self.checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            self.checkButton.tintColor = .label
        }

        
        self.tapHandler = viewModel.tapHandler
        self.checkButtonTapHandler = viewModel.tapCheckButtonHandler
        
        self.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        self.checkButton.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
    }
    
    @objc
    private func didTap(){
        tapHandler?()
        
        //It is processed when it is not reduced by the navigation push effect. 
        UIView.animate(withDuration: 0.3) {
            self.transform = .identity
        }
    }
    
    @objc
    private func checkButtonDidTap(){
        checkButtonTapHandler?()
    }

    
}
