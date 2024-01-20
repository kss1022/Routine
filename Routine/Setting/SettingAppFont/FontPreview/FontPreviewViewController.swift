//
//  FontPreviewViewController.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs
import UIKit

protocol FontPreviewPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class FontPreviewViewController: UIViewController, FontPreviewPresentable, FontPreviewViewControllable {

    weak var listener: FontPreviewPresentableListener?
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
    
    
    private let smallLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .caption1)
        label.textColor = .label
        label.text = "font_preview".localized(tableName: "Profile")
        return label
    }()
    
    private let smallBoldLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .caption1)
        label.textColor = .label
        label.text = "Hello Routine~👋"
        return label
    }()

    private let middleLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .subheadline)
        label.textColor = .label
        label.text = "font_preview".localized(tableName: "Profile")
        return label
    }()
    
    private let middleBoldLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .subheadline)
        label.textColor = .label
        label.text = "Hello Routine~👋"
        return label
    }()
    
    private let largeLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .title1)
        label.textColor = .label
        label.text = "font_preview".localized(tableName: "Profile")
        return label
    }()
    
    
    private let largeBoldLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .title1)
        label.textColor = .label
        label.text = "Hello Routine~👋"
        return label
    }()
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    private func setLayout(){
        view.addSubview(stackView)
        view.backgroundColor = .secondarySystemBackground
        stackView.addArrangedSubview(smallLabel)
        stackView.addArrangedSubview(smallBoldLabel)
        stackView.addArrangedSubview(middleLabel)
        stackView.addArrangedSubview(middleBoldLabel)
        stackView.addArrangedSubview(largeLabel)
        stackView.addArrangedSubview(largeBoldLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32.0),
        ])
    }
}
