//
//  ProfileEditViewController.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import ModernRIBs
import UIKit

protocol ProfileEditPresentableListener: AnyObject {
    func closeButtonDidTap()
    func doneButtonDidTap()
}

final class ProfileEditViewController: UIViewController, ProfileEditPresentable, ProfileEditViewControllable {

    weak var listener: ProfileEditPresentableListener?
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonTap))
        return closeButton
    }()
    
    private lazy var doneBarButtonItme: UIBarButtonItem = {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonTap))
        return doneButton
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
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.rightBarButtonItem = doneBarButtonItme
            
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
                
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            stackView.heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor)
        ])
        
        updateTransition()
    }
    
    
    func setEditMemoji(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)        
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateTransition()
        }, completion: nil)
    }
    
    func showUpdateProfileFailed() {
        let alert = UIAlertController(
            title: "update_failed".localized(tableName: "Profile"),
            message: "update_failed".localized(tableName: "Profile"),
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(title: "confirm".localized(tableName: "Profile"), style: .default)
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    
    private func updateTransition(){
        scrollView.isScrollEnabled = UIDevice.current.orientation.isLandscape
    }
    
    
    @objc
    private func closeBarButtonTap(){
        listener?.closeButtonDidTap()
    }
    
    @objc
    private func doneBarButtonTap(){
        listener?.doneButtonDidTap()
    }
}
