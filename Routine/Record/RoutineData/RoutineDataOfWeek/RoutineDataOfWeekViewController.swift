//
//  RoutineDataOfWeekViewController.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs
import UIKit

protocol RoutineDataOfWeekPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineDataOfWeekViewController: UIViewController, RoutineDataOfWeekPresentable, RoutineDataOfWeekViewControllable {

    weak var listener: RoutineDataOfWeekPresentableListener?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "Date Of Week"
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadowWithRoundedCorners()
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
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
        
        view.addSubview(titleLabel)
        view.addSubview(cardView)
        
        cardView.addSubview(stackView)
                
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
                        
            cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
            
            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -inset),
        ])
    }
    
    
    
    func setCompletes(_ viewModels: [RoutineDataOfWeekViewModel]) {
        stackView.arrangedSubviews.forEach{ $0.removeFromSuperview() }
        
        viewModels.map(RoutineDataOfWeekView.init)
            .forEach { stackView.addArrangedSubview($0) }
    }
    
    
}
