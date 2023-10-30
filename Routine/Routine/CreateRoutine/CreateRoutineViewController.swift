//
//  CreateRoutineViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/25.
//

import ModernRIBs
import UIKit

protocol CreateRoutinePresentableListener: AnyObject {
    func addYourOwnButtonDidTap()
    func closeButtonDidTap()
}

final class CreateRoutineViewController: UIViewController, CreateRoutinePresentable, CreateRoutineViewControllable {
    
    weak var listener: CreateRoutinePresentableListener?
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonTap))
        return closeButton
    }()
    
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
        stackView.spacing = 16.0
        return stackView
    }()
    
    private lazy var addYourOwnButton: UIButton = {
        let button = TouchesButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .systemFont(ofSize: 14.0, weight: .bold)
        button.setTitle("Add YourOwnButton", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple
        
        let buttonInset: CGFloat = 16.0
        
        button.contentEdgeInsets.top = buttonInset
        button.contentEdgeInsets.bottom = buttonInset
        button.contentEdgeInsets.left = buttonInset
        button.contentEdgeInsets.right = buttonInset
        
        button.roundCorners(24.0)
        
        button.addTarget(self, action: #selector(addYourOwnButtonTap), for: .touchUpInside)
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
        title = "Pick a new one"
        
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        view.addSubview(addYourOwnButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: addYourOwnButton.topAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            addYourOwnButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addYourOwnButton.heightAnchor.constraint(equalToConstant: 48.0),
            addYourOwnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            
        ])
    }
    
    @objc
    private func addYourOwnButtonTap(){
        listener?.addYourOwnButtonDidTap()
    }
    
    @objc
    private func closeBarButtonTap(){
        listener?.closeButtonDidTap()
    }
}
