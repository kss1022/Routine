//
//  RecordRoutineListCell.swift
//  Routine
//
//  Created by 한현규 on 11/6/23.
//

import UIKit




final class RecordRoutineListCell: UICollectionViewCell{
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4.0
        return stackView
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.roundCorners()
        return view
    }()
    
    private var cardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    private let emojiIconLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 36.0, weight: .regular)
        //label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getFont(size: 14.0)
        label.textColor = .label
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
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(cardView)
        stackView.addArrangedSubview(nameLabel)
        
        cardView.addSubview(cardStackView)
        
        cardStackView.addArrangedSubview(emojiIconLabel)
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                        
            cardStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 4.0),
            cardStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 4.0),
            cardStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -4.0),
            cardStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -4.0),
        ])
        
        
//        cardView.setContentHuggingPriority(.init(240.0), for: .vertical)
//        cardView.setContentCompressionResistancePriority(.init(800.0), for: .vertical)
//        
//        emojiIconLabel.setContentHuggingPriority(.init(251.0), for: .horizontal)
//        emojiIconLabel.setContentCompressionResistancePriority(.init(749.0), for: .horizontal)
//        
//        nameLabel.setContentHuggingPriority(.init(249.0), for: .vertical)
//        nameLabel.setContentCompressionResistancePriority(.init(751.0), for: .vertical)
    }

    func bindView(_ viewModel: RecordRoutineListViewModel){
        cardView.backgroundColor = viewModel.tint
        emojiIconLabel.text = viewModel.emojiIcon
        nameLabel.text = viewModel.name
    }

    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cardView.backgroundColor = .clear
        emojiIconLabel.text = nil
        nameLabel.text = nil
    }
}

