//
//  AppInfoMainView.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import UIKit




final class AppInfoMainView: UIView{
    

    
    private let appIconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4.0
        return stackView
    }()
    
    private let versionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getFont(size: 14.0)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let copyrightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .getFont(size: 14.0)
        label.textColor = .secondaryLabel
        return label
    }()
    
    init(_ viewModel: AppInfoMainViewModel){
        super.init(frame: .zero)
        
        setView()
        
        appIconImageView.image = viewModel.image
        versionLabel.text = viewModel.version
        copyrightLabel.text = viewModel.copyright
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView(){
        addSubview(appIconImageView)
        addSubview(labelStackView)
        
        labelStackView.addArrangedSubview(versionLabel)
        labelStackView.addArrangedSubview(copyrightLabel)
        
        let width: CGFloat = UIDevice.frame().width
        let imageWidth: CGFloat = width / 2
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: width),
            
            appIconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            appIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            appIconImageView.widthAnchor.constraint(equalToConstant: imageWidth),
            appIconImageView.heightAnchor.constraint(equalToConstant: imageWidth),
            
            labelStackView.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 32.0),
            labelStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: inset),
            labelStackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -inset),
            labelStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -inset),            
        ])
//        appIconImageView.widthAnchor.constraint(equalToConstant: imageWidth),
//        appIconImageView.heightAnchor.constraint(equalToConstant: imageWidth),
    }
}
