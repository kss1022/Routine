//
//  TimerListCell.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import UIKit



final class TimerListCell: UICollectionViewCell{
    
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
        stackView.alignment = .top
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
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    
    private func setView(){
        contentView.layer.borderColor = UIColor.label.cgColor
        contentView.layer.borderWidth = 1.0
        contentView.backgroundColor = .systemBackground
        contentView.addShadowWithRoundedCorners()
        
        contentView.addSubview(emojiIconLabel)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(nameLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            emojiIconLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            emojiIconLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            emojiIconLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            emojiIconLabel.widthAnchor.constraint(equalTo: emojiIconLabel.heightAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: self.emojiIconLabel.trailingAnchor, constant: 8.0),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),

        ])
        
        nameLabel.setContentHuggingPriority(.init(249.0), for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.init(752.0), for: .vertical)
        
        
        self.roundCorners()
    }

    func bindView(_ viewModel: TimerListViewModel){
        self.emojiIconLabel.text = viewModel.emoji
        self.nameLabel.text = viewModel.name
    }
    

}


