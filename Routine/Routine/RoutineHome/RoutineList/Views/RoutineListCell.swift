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
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0.0
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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutIfNeeded()
    }
    
    private func setView(){
        self.checkButton.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
        
        contentView.addSubview(emojiIconLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(checkButton)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            emojiIconLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            emojiIconLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            emojiIconLabel.widthAnchor.constraint(equalToConstant: 50.0),
            emojiIconLabel.heightAnchor.constraint(equalToConstant: 50.0),
            
            stackView.leadingAnchor.constraint(equalTo: emojiIconLabel.trailingAnchor, constant: 8.0),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: checkButton.leadingAnchor, constant: -8.0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            stackView.heightAnchor.constraint(greaterThanOrEqualTo: emojiIconLabel.heightAnchor, multiplier: 1.0),
            
            checkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            checkButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 40.0),
            checkButton.heightAnchor.constraint(equalToConstant: 40.0),
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
        //self.checkButton.isSelected = viewModel.isCompleted
                        
        descriptionLabel.isHidden = viewModel.description.isEmpty
        
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
    }
    

    
    @objc
    private func checkButtonDidTap(){
        checkButtonTapHandler?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.nameLabel.attributedText = nil
        self.descriptionLabel.attributedText = nil
        self.checkButton.setImage(nil, for: .normal)
        self.checkButton.tintColor = .clear
        self.checkButtonTapHandler = nil
    }
}
