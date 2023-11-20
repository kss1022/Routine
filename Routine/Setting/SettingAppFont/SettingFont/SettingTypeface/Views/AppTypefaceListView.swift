//
//  AppTypefaceListView.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import UIKit



final class AppTypefaceListView: UIControl{
    
    private var tapHandler: (() -> Void)?

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
        return label
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    init(_ viewModel: AppTypefaceListViewModel){
        super.init(frame: .zero)
        
        setView()
        bindView(viewModel)
    }
    
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        let tapHandler = UITapGestureRecognizer(target: self, action: #selector(didTap))
        self.addGestureRecognizer(tapHandler)
        
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
    
    private func bindView(_ viewModel: AppTypefaceListViewModel){
        titleLabel.text = viewModel.title
        imageView.image =  viewModel.image
        tapHandler = viewModel.tapHandler
    }

    @objc
    private func didTap(){
        self.tapHandler?()
    }
}
