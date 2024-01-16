//
//  EditFocusTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 1/15/24.
//

import ModernRIBs
import UIKit

protocol EditFocusTimerPresentableListener: AnyObject {
    func closeButtonDidTap()
    func doneButtonDidTap()
    func errorButtonDidTap()
}

final class EditFocusTimerViewController: UIViewController, EditFocusTimerPresentable, EditFocusTimerViewControllable {


    weak var listener: EditFocusTimerPresentableListener?
    
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
    
    private let loadingIndicator: UIActivityIndicatorView = {
      let activity = UIActivityIndicatorView(style: .medium)
      activity.translatesAutoresizingMaskIntoConstraints = false
      activity.hidesWhenStopped = true
      activity.stopAnimating()
      return activity
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
        view.addSubview(loadingIndicator)
        
        scrollView.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
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
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func startLoading() {
        loadingIndicator.startAnimating()
        doneBarButtonItem.isEnabled = false
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
        doneBarButtonItem.isEnabled = true
    }
        
    
    func showError(title: String, message: String) {
        showAlert(
            title: title,
            message: message
        )
    }
    
    func showCacelError(title: String, message: String) {
        showAlert(
            title: title,
            message: message) { [weak self] _ in
                self?.listener?.errorButtonDidTap()
            }
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
