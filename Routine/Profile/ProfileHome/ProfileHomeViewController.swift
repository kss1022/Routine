//
//  ProfileHomeViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import UIKit

protocol ProfileHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ProfileHomeViewController: UIViewController, ProfileHomePresentable, ProfileHomeViewControllable {
    

    weak var listener: ProfileHomePresentableListener?
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
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
        title = "profile".localized(tableName: "Profile")
        tabBarItem = UITabBarItem(
            title: "profile".localized(tableName: "Profile"),
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
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
    
    //MARK: ViewControllabel
    func setProfileCard(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        stackView.addArrangedSubview(vc.view)
        
        vc.didMove(toParent: self)
    }
    
    func setProfileStat(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        stackView.addArrangedSubview(vc.view)
        
        vc.didMove(toParent: self)
    }
    
    
    func setProfileMenus(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        stackView.addArrangedSubview(vc.view)
        
        vc.didMove(toParent: self)
    }
    
    
    //MARK: Presentable
    func showMailResult(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "confirm".localized(tableName: "Profile"), style: .default)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
}
