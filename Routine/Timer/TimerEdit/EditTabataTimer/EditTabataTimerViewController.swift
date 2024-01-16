//
//  EditTabataTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import ModernRIBs
import UIKit

protocol EditTabataTimerPresentableListener: AnyObject {
    func closeButtonDidTap()
    func doneButtonDidTap()
    func errorButtonDidTap()
}

final class EditTabataTimerViewController: UIViewController, EditTabataTimerPresentable, EditTabataTimerViewControllable {

    weak var listener: EditTabataTimerPresentableListener?
    
    
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
    

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
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
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItem

        view.addSubview(stackView)
        view.addSubview(loadingIndicator)
                
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: ViewControllable
    func addEditTitle(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)

        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    
    func addSectionLists(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    //MARK: Presentable
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
        showAlert(title: title, message: message)
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
