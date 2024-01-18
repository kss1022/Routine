//
//  TimerCountInfoView.swift
//  Routine
//
//  Created by 한현규 on 10/28/23.
//

import UIKit



final class TimerCountInfoView: UIView{

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16.0
        return stackView
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .subheadline)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .subheadline)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return label
    }()
    
   
    
    init(){
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    
    private func setView(){
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(countLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setCountInfo(_ viewModel: TimerCountInfoViewModel){
        titleLabel.text = "\(viewModel.emoji) \(viewModel.title)"        
        countLabel.text = "\(viewModel.count) / \(viewModel.totalCount)"
    }
}
