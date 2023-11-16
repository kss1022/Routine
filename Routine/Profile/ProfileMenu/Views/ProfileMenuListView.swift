//
//  ProfileMenuListView.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import UIKit



final class ProfileMenuListView: UIView{
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .title3)
        label.textColor = . label
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.roundCorners()
        return view
    }()
    
    private let listStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 24.0
        return stackView
    }()
    
    
    init(_ viewModel: ProfileMenuListViewModel){
        super.init(frame: .zero)
        
        setView()
        
        
        titleLabel.text = viewModel.title
        viewModel.menus.map(ProfileMenuView.init)
            .forEach { listStackView.addArrangedSubview($0)}
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setView(){
        addSubview(titleLabel)
        addSubview(cardView)
        
        
        cardView.addSubview(listStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                                                
            cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            listStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16.0),
            listStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16.0),
            listStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16.0),
            listStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16.0)
        ])
        

    }
    
    
    
}




final class ProfileMenuView: UIControl{
    
    private var tapHandler: (() -> Void)?

    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .headline)
        label.textColor = .label
        return label
    }()
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .secondaryLabel
        return imageView
    }()
    
    
    init(_ viewModel: ProfileMenuViewModel){
        super.init(frame: .zero)
        
        setView()
                                        
        imageView.image = viewModel.image
        titleLabel.text = viewModel.title
        self.tapHandler = viewModel.tapHandler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        addSubview(stackView)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(rightImageView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 30.0),
            imageView.heightAnchor.constraint(equalToConstant: 30.0)
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(gesture)
        
        
        imageView.setContentCompressionResistancePriority(.init(751.0), for: .horizontal)
        titleLabel.setContentHuggingPriority(.init(249.0), for: .horizontal)
        rightImageView.setContentCompressionResistancePriority(.init(751.0), for: .horizontal)
    }

    @objc
    private func tap(){
        self.tapHandler?()
    }
    
}
