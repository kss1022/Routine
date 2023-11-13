//
//  TImerStasDateView.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import UIKit


final class TimerStasDateView: UIView{
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left.circle.fill"), for: .normal)
        button.tintColor = .primaryColor
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right.circle.fill"), for: .normal)
        button.tintColor = .primaryColor
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "11.10 2023"
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
        
        stackView.addArrangedSubview(leftButton)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(rightButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    
}

    
