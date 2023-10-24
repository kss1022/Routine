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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
                  
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 32.0
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
        
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    func addTimerRemain(_ view: ViewControllable) {
        let vc = view.uiviewController
         addChild(vc)
         
         stackView.addArrangedSubview(vc.view)
         vc.didMove(toParent: self)
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
