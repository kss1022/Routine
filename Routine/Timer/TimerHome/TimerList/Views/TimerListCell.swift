//
//  TimerListCell.swift
//  Routine
//
//  Created by 한현규 on 1/15/24.
//


import UIKit



final class TimerListCell: UICollectionViewCell{
    
    private var checkButtonTapHandler: (() -> Void)?
    
    private let emojiIconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 36.0, weight: .regular)
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
        stackView.spacing = 4.0
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .getBoldFont(size: 12.0)
        label.textColor = .black
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .getBoldFont(size: 18.0)
        label.textColor = .black
        return label
    }()    

    
    private let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
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
        self.editButton.addTarget(self, action: #selector(checkButtonDidTap), for: .touchUpInside)
        
        contentView.addSubview(emojiIconLabel)
        contentView.addSubview(editButton)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(nameLabel)
        
        let inset: CGFloat = 8.0
        
        NSLayoutConstraint.activate([
            emojiIconLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            emojiIconLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
                        
            stackView.topAnchor.constraint(equalTo: emojiIconLabel.bottomAnchor, constant: 16.0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
            
            editButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),            
        ])
                
        
        self.roundCorners()
    }

    func bindView(_ viewModel: TimerListViewModel){
        backgroundColor = viewModel.tintColor
        
        self.emojiIconLabel.text = viewModel.emojiIcon
        self.nameLabel.text = viewModel.name
        self.descriptionLabel.text = viewModel.description
        self.checkButtonTapHandler = viewModel.tapHandler
    }
    

    
    @objc
    private func checkButtonDidTap(){
        checkButtonTapHandler?()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.backgroundColor = .clear
        self.nameLabel.text = nil
        self.descriptionLabel.text = nil
        self.checkButtonTapHandler = nil
    }}


