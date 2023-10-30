//
//  RoutineHomeViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import UIKit
import CocoaLumberjackSwift

protocol RoutineHomePresentableListener: AnyObject {
    func createRoutineBarButtonDidTap()    
}

final class RoutineHomeViewController: UIViewController, RoutineHomePresentable, RoutineHomeViewControllable {
    
    

    weak var listener: RoutineHomePresentableListener?
    
    
    private lazy var createRoutineBarButtonItem : UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(createRoutineBarButtonTap)
        )
        return barButtonItem
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
        
        return scrollView
    }()

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
        title = "Routine"
        tabBarItem = UITabBarItem(
            title: "Routine",
            image: UIImage(systemName: "checkmark.seal"),
            selectedImage: UIImage(systemName: "checkmark.seal.fill")
        )
        
        navigationItem.rightBarButtonItems = [ createRoutineBarButtonItem]

        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])        
    }
    
    
    func addRoutineWeekCalendar(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    
    func addRoutineList(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        stackView.addArrangedSubview(vc.view)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor).isActive = true
        
        vc.didMove(toParent: self)        
    }
    
    @objc
    private func createRoutineBarButtonTap(){
        listener?.createRoutineBarButtonDidTap()
    }
}

