//
//  RoutineEditButton.swift
//  Routine
//
//  Created by 한현규 on 10/1/23.
//

import UIKit




final class RoutineEditButton : UIControl{
    
    
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.distribution = .equalSpacing
        stackView.spacing = 4.0
        return stackView
    }()
    
    private let editImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "pencil"))
        imageView.tintColor = .systemBackground
        return imageView
    }()
    
    private let editLabel: UILabel = {
       let label = UILabel()
        label.setFont(style: .headline)
        label.textColor = .systemBackground
        label.text = "Edit"
        label.textAlignment = .center
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
        self.backgroundColor = .gray
        
        self.addSubview(stackView)
        stackView.addArrangedSubview(editImageView)
        stackView.addArrangedSubview(editLabel)
        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4.0),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4.0),
        ])
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.size.height / 2
    }
    
    
}
