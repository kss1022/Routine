//
//  TimerListCell.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import UIKit



final class TimerListCell: UICollectionViewCell{
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
    
    private let statusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.tintColor = .black
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
        contentView.addSubview(emojiIconLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(statusButton)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            emojiIconLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            emojiIconLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            emojiIconLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            emojiIconLabel.widthAnchor.constraint(equalTo: emojiIconLabel.heightAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: self.emojiIconLabel.trailingAnchor, constant: 8.0),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: statusButton.leadingAnchor, constant: -8.0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            
            statusButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            statusButton.topAnchor.constraint(equalTo: stackView.topAnchor),
            statusButton.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            statusButton.widthAnchor.constraint(equalTo: statusButton.heightAnchor),
        ])
        
        nameLabel.setContentHuggingPriority(.init(249.0), for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.init(752.0), for: .vertical)
        
        descriptionLabel.setContentHuggingPriority(.init(249.0), for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.init(752.0), for: .vertical)
        
        self.roundCorners()
    }

    func bindView(_ viewModel: TimerListViewModel){
        self.backgroundColor = viewModel.tint
        self.emojiIconLabel.text = viewModel.emoji
        self.nameLabel.text = viewModel.name
        self.descriptionLabel.text = viewModel.description
        //self.statusButton.setImage(viewModel.image, for: .normal)
        //self.checkButtonTapHandler = viewModel.tapCheckButtonHandler
        //self.startingButton.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
    }
    

    
    @objc
    private func checkButtonDidTap(){
        checkButtonTapHandler?()
    }

}


