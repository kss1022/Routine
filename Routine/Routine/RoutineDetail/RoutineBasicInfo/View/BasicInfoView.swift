//
//  BasicInfoView.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import UIKit



final class BasicInfoView: UIView {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8.0
        return stackView
    }()
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label
        return imageView
    }()
    
    private var label: UILabel = {
        let label = UILabel()
        label.setFont(style: .headline)
        label.textColor = .label
        return label
    }()

    init(){
        super.init(frame: .zero)
        setView()
    }
        
    
    init(image: UIImage?, title: String){
        super.init(frame: .zero)
        
        setView()
        
        
        self.imageView.image = image
        self.label.text = title
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    private func setView(){
        self.backgroundColor = .systemBackground
        addSubview(stackView)
        roundCorners()
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
        
        imageView.setContentHuggingPriority(.init(249.0), for: .horizontal)
        imageView.setContentCompressionResistancePriority(.init(751.0), for: .horizontal)

        
        label.setContentHuggingPriority(.init(249.0), for: .vertical)
        label.setContentCompressionResistancePriority(.init(751.0), for: .vertical)
    }
    
    func setImage(_ image: UIImage?){
        self.imageView.image = image
    }
    
    func setTitle(_ title: String){
        self.label.text = title
    }
    
}
