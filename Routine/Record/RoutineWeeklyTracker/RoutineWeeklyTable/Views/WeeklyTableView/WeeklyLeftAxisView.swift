//
//  WeeklyLeftAxisView.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import UIKit



final class WeeklyLeftAxisView: UIScrollView{
    
    private var fontSize: CGFloat = 12.0
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        return stackView
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
        self.isUserInteractionEnabled = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    
    func addCell(title: String, emoji: String){
        let column =  WeekklyLeftAxisColumnView(title: title, emoji: emoji)
        column.setFont(size: fontSize)
        stackView.addArrangedSubview(column)
    }
    
    func setFont(size: CGFloat){
        self.fontSize = size
        
        stackView.arrangedSubviews
            .compactMap{ $0 as? WeekklyLeftAxisColumnView}
            .forEach {
                $0.setFont(size: size)
            }
    }
}

final class WeekklyLeftAxisColumnView: UIView{
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 4.0
        return stackView
    }()
    
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        label.textColor = .label
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.0, weight: .bold)
        return label
    }()
    
    init(title: String, emoji: String){
        super.init(frame: .zero)
        
        setView()
        titleLabel.text = title
        emojiLabel.text = emoji
    }
        
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setView(){
        addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(emojiLabel)
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        titleLabel.setContentHuggingPriority(.init(249.0), for: .horizontal)
        emojiLabel.setContentCompressionResistancePriority(.init(751.0), for: .horizontal)
    }
    
    
    func setFont(size: CGFloat){
        titleLabel.font = .systemFont(ofSize: size, weight: .bold)
        emojiLabel.font = .systemFont(ofSize: size, weight: .bold)
    }
    
}
