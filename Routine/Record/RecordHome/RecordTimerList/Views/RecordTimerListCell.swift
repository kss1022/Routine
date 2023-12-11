//
//  RecordTimerListCell.swift
//  Routine
//
//  Created by 한현규 on 11/9/23.
//

import UIKit



final class RecordTimerListCell: UICollectionViewCell{
    
    private let emojiIconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 32.0)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.tertiaryLabel.cgColor
        label.roundCorners()
        
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0.0
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .getBoldFont(size: 16.0)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()    
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = .getFont(size: 14.0)
        label.textColor = .systemGray
        return label
    }()
    
    private let doneButton: TouchesRoundButton = {
        let button = TouchesRoundButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .tertiaryLabel
        button.titleLabel?.font = .getFont(size: 14.0)
        button.setTitleColor(.label, for: .normal)
        
        button.roundCorners()
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    private func setView(){
        contentView.addSubview(emojiIconLabel)
        contentView.addSubview(stackView)
        contentView.addSubview(doneButton)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(durationLabel)
                
        
        NSLayoutConstraint.activate([
            emojiIconLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            emojiIconLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            emojiIconLabel.widthAnchor.constraint(equalTo: emojiIconLabel.heightAnchor),
            emojiIconLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                        
            stackView.leadingAnchor.constraint(equalTo: emojiIconLabel.trailingAnchor, constant: 8.0),
            stackView.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -8.0),
            stackView.centerYAnchor.constraint(equalTo: emojiIconLabel.centerYAnchor),
            
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0),
            doneButton.centerYAnchor.constraint(equalTo: emojiIconLabel.centerYAnchor)
        ])
        
                
                
        doneButton.setContentHuggingPriority(.init(252.0), for: .horizontal)
                
        
        self.roundCorners()
    }
    
    func bindView(_ viewModel: RecordTimerListViewModel){
        emojiIconLabel.text = viewModel.emojiIcon
        nameLabel.text = viewModel.name
        durationLabel.text = viewModel.duration
        
        doneButton.setTitle("Done", for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        emojiIconLabel.text = nil
        nameLabel.text = nil
        durationLabel.text = nil        
        doneButton.setTitle(nil, for: .normal)
    }
}


