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
        stackView.distribution = .fill
        stackView.spacing = 16.0
        return stackView
    }()
    
    
    private let label: UILabel = {
        let label = UILabel()
        label.setFont(style: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "font_preview".localized(tableName: "Profile")
        return label
    }()
    
    private let boldLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Let's embark on a journey together to form new habits and achieve your goals."
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
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(boldLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 36.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -36.0),
            view.heightAnchor.constraint(equalToConstant: 180.0)
        ])
        
        label.setContentHuggingPriority(.init(249.0), for: .vertical)
        label.setContentCompressionResistancePriority(.init(752.0), for: .vertical)
    }
}
