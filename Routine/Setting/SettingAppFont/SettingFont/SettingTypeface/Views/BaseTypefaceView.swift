//
//  BaseTypefaceView.swift
//  Routine
//
//  Created by 한현규 on 1/21/24.
//

import UIKit



final class BaseTypefaceListView: UIControl{
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "base_typeface".localized(tableName: "Profile")
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
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
        
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

    func select(){
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
    }
    
    func deSelect(){
        imageView.image = UIImage(systemName: "checkmark.circle")
    }
}
