//
//  CreateTimerButton.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import UIKit



final class CreateTimerButton: UIControl{
    
    private var tapHandler: (() -> Void)?

    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.addShadowWithRoundedCorners()
        return view
    }()
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints  = false
        imageView.contentMode = .scaleAspectFit
        imageView.roundCorners(4.0)
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 4.0
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .headline)
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(style: .caption2)
        label.textColor = .secondaryLabel
        return label
    }()
    
    init(_ viewModel: CreatTimerViewModel){
        super.init(frame: .zero)
        
        setView()
        imageView.image = viewModel.image
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        tapHandler = viewModel.tapHandler
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    private func setView(){
        let tapHandler = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tapHandler)
        
        
        addSubview(cardView)
        
        cardView.addSubview(imageView)
        cardView.addSubview(stackView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: self.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset),
            cardView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset),
            cardView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: stackView.topAnchor, constant: -inset),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: inset),
            imageView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor,  constant: inset),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: inset * 2),
            stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -inset * 2),
        ])
    }
    
    
    @objc
    private func didTap(){
        tapHandler?()
    }
}
