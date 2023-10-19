//
//  TimerDetailViewController.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs
import UIKit

protocol TimerDetailPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class TimerDetailViewController: UIViewController, TimerDetailPresentable, TimerDetailViewControllable {
    
    weak var listener: TimerDetailPresentableListener?
                  
    private let stackView: UIStackView = {
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
        title = "Timer"
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)        
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func addCircularTimer(_ view: ViewControllable) {
       let vc = view.uiviewController
        addChild(vc)
        
        stackView.addArrangedSubview(vc.view)
        
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor).isActive = true
        vc.didMove(toParent: self)
    }

    
    func addNextSection(_ view: ViewControllable) {
        let vc = view.uiviewController
         addChild(vc)
         
         stackView.addArrangedSubview(vc.view)
         vc.didMove(toParent: self)
    }
}
