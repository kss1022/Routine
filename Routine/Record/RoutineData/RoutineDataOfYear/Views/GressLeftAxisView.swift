//
//  GressLeftAxisView.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import UIKit




final class GressLeftAxisView: UIView{
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private func label() -> UILabel{
        let label = UILabel()
        label.font = .getBoldFont(size: 8.0)
        label.textColor =  .label
        return label
    }
    
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
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        
        ["", "Mon", "", "Wed","", "Fri", ""].forEach { week in
            if week.isEmpty{
                stackView.addArrangedSubview(UIView())
            }else{
                let label = label()
                label.text = week
                stackView.addArrangedSubview(label)
            }
        }
    }
    
    
}
