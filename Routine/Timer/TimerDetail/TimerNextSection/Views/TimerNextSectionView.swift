//
//  TimerNextSectionView.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import UIKit


final class TimerNextSectionView: UIView{
    
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
        label.setFont(style: .headline)
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .subheadline)
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
    

    init(_ viewModel: TimerSectionListViewModel){
        super.init(frame: .zero)
        setView()
        
        nameLabel.text = "\(viewModel.emoji) \(viewModel.name)"
        descriptionLabel.text = viewModel.description
        timerLabel.text = viewModel.value.rawValue()
        
        if viewModel.color != nil{
            categoryView.isHidden = false
            categoryView.backgroundColor = viewModel.color!
        }else{
            categoryView.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setView()
    }
    
    
    private func setView(){
        self.addSubview(stackView)
        self.addSubview(categoryView)
        
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(timerLabel)
        
        titleStackView.addArrangedSubview(nameLabel)
        titleStackView.addArrangedSubview(descriptionLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            categoryView.topAnchor.constraint(equalTo: self.topAnchor),
            categoryView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            categoryView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset),
        ])
    
    }

}
