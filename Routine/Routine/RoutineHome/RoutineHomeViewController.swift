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
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
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
        //title = "Today"
        navigationItem.title = "today".localized(tableName: "Routine")
        
        tabBarItem = UITabBarItem(
            title: "routine".localized(tableName: "Routine"),
            image: UIImage(systemName: "checkmark.seal"),
            selectedImage: UIImage(systemName: "checkmark.seal.fill")
        )
        
        navigationItem.rightBarButtonItems = [ createRoutineBarButtonItem]

        view.backgroundColor = .systemBackground
        view.addSubview(stackView)
            
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        vc.didMove(toParent: self)        
    }
    
    func setTitle(title: String) {
        navigationItem.title = title
    }
    
    @objc
    private func createRoutineBarButtonTap(){
        listener?.createRoutineBarButtonDidTap()
    }
}

