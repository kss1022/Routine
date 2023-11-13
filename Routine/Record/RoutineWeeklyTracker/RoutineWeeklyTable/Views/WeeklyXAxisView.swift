//
//  WeeklyXAxisView.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import UIKit




final class WeeklyXAxisView : UIView{
    
  
    private let weeklyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private func weeklyLabel() -> UILabel{
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
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
        addSubview(weeklyStackView)
        
        
        NSLayoutConstraint.activate([
            weeklyStackView.topAnchor.constraint(equalTo: topAnchor),
            weeklyStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weeklyStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weeklyStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        ["S","M","T","W","T","F","S",].map {
            let label = weeklyLabel()
            label.text = $0
            return label
        }.forEach {
            weeklyStackView.addArrangedSubview($0)
        }
        
    }
    
    func setFontSize(size: CGFloat){
        weeklyStackView.arrangedSubviews
            .compactMap { $0 as? UILabel }
            .forEach { $0.font = .systemFont(ofSize: size, weight: .bold) }            
    }
    
    
    
}
