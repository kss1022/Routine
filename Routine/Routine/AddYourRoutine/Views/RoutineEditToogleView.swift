//
//  RoutineEditToogleView.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import UIKit



final class RoutineEditToogleView: UIView{
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false        
        imageView.tintColor = .label
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .headline)
        label.textColor = .label
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    
    lazy var toogle: UISwitch = {
        let toogle = UISwitch()
        toogle.translatesAutoresizingMaskIntoConstraints = false
        toogle.tintColor = .systemGreen
        toogle.isOn = false
        return toogle
    }()
    
    init(image: UIImage?, title: String, subTitle: String){
        super.init(frame: .zero)
        
        setLayout()
        
        imageView.image = image
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setLayout(){
        
        addSubview(imageView)
        addSubview(labelStackView)
        addSubview(toogle)
        
        labelStackView.addArrangedSubview(titleLabel)
        labelStackView.addArrangedSubview(subTitleLabel)
        
        
        let inset: CGFloat = 8.0
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset),
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
            imageView.heightAnchor.constraint(equalToConstant: toogle.frame.height),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            labelStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor,constant: 8.0),
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
            labelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset),
            labelStackView.trailingAnchor.constraint(equalTo: toogle.leadingAnchor,constant: -8.0),
            
            toogle.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
            toogle.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -inset),
        ])
        
        titleLabel.setContentHuggingPriority(.init(249.0), for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.init(752.0), for: .vertical)

        subTitleLabel.setContentHuggingPriority(.init(249.0), for: .vertical)
        subTitleLabel.setContentCompressionResistancePriority(.init(752.0), for: .vertical)
        
        toogle.setContentHuggingPriority(.init(249.0), for: .horizontal)
        toogle.setContentCompressionResistancePriority(.init(752.0), for: .horizontal)
    }
    
    func setTitle(_ title: String){
        titleLabel.text = title
    }
        
    func setSubTitle(_ subTitle: String){
        subTitleLabel.text = subTitle
    }
    
    func setToogleEnable(_ enable: Bool){
        toogle.isEnabled = enable
    }
    
    func setToogle(_ isON: Bool){
        toogle.isOn = isON
    }
}
