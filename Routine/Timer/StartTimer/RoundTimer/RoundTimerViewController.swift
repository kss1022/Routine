//
//  RoundTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import ModernRIBs
import UIKit

protocol RoundTimerPresentableListener: AnyObject {
    func closeButtonDidTap()
    func errorButtonDidTap()
}

final class RoundTimerViewController: UIViewController, RoundTimerPresentable, RoundTimerViewControllable {

    weak var listener: RoundTimerPresentableListener?
    
    private var roundTimerContainer: UIView?
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonTap))
        return closeButton
    }()
                  
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
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
        view.backgroundColor = .black
        navigationItem.leftBarButtonItem = closeBarButtonItem
                        
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
        
        updateTransition()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateTransition()
        }, completion: nil)
    }
    
    private func updateTransition(){
        if !UIDevice.current.orientation.isLandscape{
            stackView.axis = .vertical
            stackView.alignment = .fill
        }else{
            stackView.axis = .horizontal
            stackView.alignment = .center
        }
    }
    
    
    //MARK: ViewControllable
    func addTimerRemain(_ view: ViewControllable) {
        let vc = view.uiviewController
         addChild(vc)
         
         stackView.addArrangedSubview(vc.view)
         vc.didMove(toParent: self)
    }
    
    func addRoundTimer(_ view: ViewControllable) {
       let vc = view.uiviewController
        addChild(vc)
                
        self.roundTimerContainer = vc.view
        self.roundTimerContainer!.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.roundTimerContainer!)
        NSLayoutConstraint.activate([
            
            self.roundTimerContainer!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.roundTimerContainer!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
            
        
        vc.didMove(toParent: self)
    }

    
    func addNextSection(_ view: ViewControllable) {
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
    }
    
    func stopLoading() {
        loadingIndicator.stopAnimating()
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

}
