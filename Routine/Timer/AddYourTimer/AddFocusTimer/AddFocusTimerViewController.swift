//
//  AddFocusTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 10/30/23.
//

import ModernRIBs
import UIKit

protocol AddFocusTimerPresentableListener: AnyObject {
    func closeButtonDidTap()
    func doneButtonDidTap()
}

final class AddFocusTimerViewController: UIViewController, AddFocusTimerPresentable, AddFocusTimerViewControllable {
    
    

    weak var listener: AddFocusTimerPresentableListener?
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonTap))
        return closeButton
    }()
    
    private lazy var doneBarButtonItem: UIBarButtonItem = {
        let barbuttonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self, action: #selector(doneBarButtonDidTap))
        return barbuttonItem
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
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
        view.backgroundColor = .secondarySystemBackground
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem

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
    
    
    func addTimeEditTitle(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }

    func addTimerEditCountdown(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    @objc
    private func closeBarButtonTap(){
        self.listener?.closeButtonDidTap()
    }
    
    @objc
    private func doneBarButtonDidTap(){
        view.endEditing(true)
        listener?.doneButtonDidTap()
    }
}
