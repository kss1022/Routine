//
//  RoutineTotalRecordViewController.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs
import UIKit

protocol RoutineTotalRecordPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineTotalRecordViewController: UIViewController, RoutineTotalRecordPresentable, RoutineTotalRecordViewControllable {

    weak var listener: RoutineTotalRecordPresentableListener?
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadowWithRoundedCorners()
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
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
        view.addSubview(cardView)
        
//        cardView.addSubview(stackView)
//        
//        let inset: CGFloat = 16.0
//        
//        NSLayoutConstraint.activate([
//            cardView.topAnchor.constraint(equalTo: view.topAnchor),
//            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            
//            stackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: inset),
//            stackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: inset),
//            stackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -inset),
//            stackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -inset),
//        ])
    }

}
