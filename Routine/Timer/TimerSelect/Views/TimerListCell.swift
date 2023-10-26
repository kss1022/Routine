//
//  TimerListCell.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import UIKit



final class TimerListCell: UICollectionViewCell{
    

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
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
        
    private let summaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .headline)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let tintView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 3.0).isActive = true
        return view
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
        
        contentView.backgroundColor = .secondarySystemBackground
        stackView.addShadowWithRoundedCorners()
        
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(summaryStackView)
        
        summaryStackView.addArrangedSubview(infoLabel)
        summaryStackView.addArrangedSubview(tintView)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
        ])
        
        infoLabel.setContentHuggingPriority(.init(249.0), for: .vertical)
        infoLabel.setContentCompressionResistancePriority(.init(752.0), for: .vertical)
        
        
        self.roundCorners()
    }

    func bindView(_ viewModel: TimerListViewModel){
        
        self.nameLabel.text = viewModel.name
        self.infoLabel.text = viewModel.info
        self.tintView.backgroundColor = viewModel.tint
    }
    

}


