//
//  RoutineListCell.swift
//  Routine
//
//  Created by 한현규 on 10/4/23.
//

import UIKit



final class RoutineListCell: UICollectionViewCell{
    
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
        label.textColor = .black
        return label
    }()
    
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption1)
        label.textColor = .systemGray
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    
    private func setView(){
        addSubview(emojiIconLabel)
        addSubview(stackView)
        addSubview(checkButton)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
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

    func bindView(_ viewModel: RoutineListViewModel){
        backgroundColor = viewModel.tint
        
        self.emojiIconLabel.text = viewModel.emojiIcon
        self.checkButton.isSelected = viewModel.isCompleted
        
        if viewModel.isCompleted{
            self.nameLabel.attributedText = viewModel.name.getAttributeStrkeString()
            self.descriptionLabel.attributedText = viewModel.description.getAttributeStrkeString()
            self.checkButton.setImage(UIImage(systemName: "checkmark.seal.fill"), for: .normal)
            self.checkButton.tintColor = UIColor(hex: "#00EA96FF")
        }else{
            self.nameLabel.attributedText = viewModel.name.getAttributeSting()
            self.descriptionLabel.attributedText = viewModel.description.getAttributeSting()
            self.checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            self.checkButton.tintColor = .black
        }

        
        self.checkButtonTapHandler = viewModel.tapCheckButtonHandler
        self.checkButton.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
    }
    

    
    @objc
    private func checkButtonDidTap(){
        checkButtonTapHandler?()
    }


}
