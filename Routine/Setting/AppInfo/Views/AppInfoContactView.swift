//
//  AppInfoContactView.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import UIKit




final class AppInfoContactView: UIView{
    
    
    private let contanctTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getBoldFont(size: 24.0)
        label.textColor = .label
        label.text = "ContactMe"
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
  
    init(_ viewModels: [AppInfoContactViewModel]){
        super.init(frame: .zero)
        
        setView()
        
        
        viewModels.map(AppInfoContactButton.init)
            .forEach {
                stackView.addArrangedSubview($0)
            }
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setView(){
        addSubview(contanctTitleLabel)
        addSubview(stackView)
        
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            contanctTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            contanctTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            contanctTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -inset),
            
            stackView.topAnchor.constraint(equalTo: contanctTitleLabel.bottomAnchor, constant: inset),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
    }

    
}
