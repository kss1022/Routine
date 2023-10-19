//
//  TimerSectionListCell.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import UIKit



final class TimerSectionListCell: UITableViewCell{
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    

    private let categoryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.widthAnchor.constraint(equalToConstant: 5.0).isActive = true
        return view
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .subheadline)
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption1)
        label.textColor = .label
        return label
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(style: .title3)
        label.textColor = .label
        return label
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setView(){
        contentView.addSubview(stackView)
        contentView.addSubview(categoryView)
        
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(timerLabel)
        
        titleStackView.addArrangedSubview(nameLabel)
        titleStackView.addArrangedSubview(descriptionLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
        ])
    
    }
    
    func bindView(_ viewModel: TimerSectionListViewModel){
        nameLabel.text = "\(viewModel.emoji) \(viewModel.name)"
        descriptionLabel.text = viewModel.description
        timerLabel.text = viewModel.value
        
        if viewModel.color != nil{
            categoryView.isHidden = false
            categoryView.backgroundColor = viewModel.color!
        }else{
            categoryView.isHidden = true
        }
    }
    
}


