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
    func createRoutineDidTap()
    func updateButtonDidTap(text: String)
    func readButtonDidTap()
}

final class RoutineHomeViewController: UIViewController, RoutineHomePresentable, RoutineHomeViewControllable {
    
    

    weak var listener: RoutineHomePresentableListener?
    
    
    private lazy var createRoutineBarButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(createRoutineBarButtonTap)
        )
        return button
    }()
    

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
    
    private let textFeild: UITextField = {
        let textFeild = UITextField()
        textFeild.textColor = .label
        textFeild.borderStyle = .roundedRect
        return textFeild
    }()
    
    private lazy var updateButton : UIButton = {
        let button = UIButton()
        button.setTitle("Update", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(updateButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var readButton : UIButton = {
        let button = UIButton()
        button.setTitle("Read", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(readButtonTap), for: .touchUpInside)
        return button
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
        
        navigationItem.rightBarButtonItems = [ createRoutineBarButtonItem]

        
        tabBarItem = UITabBarItem(
            title: "Routine",
            image: UIImage(systemName: "checkmark.seal"),
            selectedImage: UIImage(systemName: "checkmark.seal.fill")
        )
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(textFeild)
        stackView.addArrangedSubview(updateButton)
        stackView.addArrangedSubview(readButton)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    

    @objc
    private func createRoutineBarButtonTap(){
        listener?.createRoutineDidTap()
    }
    
    @objc
    private func updateButtonTap(){
        if let text = textFeild.text{
            listener?.updateButtonDidTap(text: text)
        }
    }
    
    @objc
    private func readButtonTap(){
        listener?.readButtonDidTap()
    }
}

