//
//  OSTypefaceListView.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import UIKit


final class OSTypefaceListView: UIControl{
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
        
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8.0
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "os_typeface".localized(tableName: "Profile")
        return label
    }()
    
    private let fontNameLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption2)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .secondaryLabel
        imageView.image = UIImage(systemName: "checkmark.circle")
        return imageView
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
        
        stackView.addArrangedSubview(labelStackView)
        stackView.addArrangedSubview(imageView)
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(fontNameLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            
            imageView.widthAnchor.constraint(equalToConstant: 30.0),
            imageView.heightAnchor.constraint(equalToConstant: 30.0)
        ])
    }

    
    func fontName(_ fontName: String){
        fontNameLabel.text = fontName
    }
    
    func select(){
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
    }
    
    func deSelect(){
        imageView.image = UIImage(systemName: "checkmark.circle")
    }
    
}
