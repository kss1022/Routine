//
//  RoutineListViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/27.
//

import ModernRIBs
import UIKit

protocol RoutineListPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineListViewController: UIViewController, RoutineListPresentable, RoutineListViewControllable {


    weak var listener: RoutineListPresentableListener?
    
    
    private var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
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
        view.addSubview(stackView)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    
    func setRoutineLists(viewModels: [RoutineListViewModel]) {
        viewModels.map(RoutineListButton.init)
            .forEach {
                stackView.addArrangedSubview($0)
            }
    }
    
    
}
