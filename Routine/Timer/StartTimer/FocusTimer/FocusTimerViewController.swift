//
//  FocusTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs
import UIKit
import SpriteKit

protocol FocusTimerPresentableListener: AnyObject {
    func cancelButtonDidTap()
    func finishButtonDidTap()
    
    func closeButtonDidTap()
    func errorButtonDidTap()
}

final class FocusTimerViewController: UIViewController, FocusTimerPresentable, FocusTimerViewControllable {

    
    

    weak var listener: FocusTimerPresentableListener?
    
    
    private var roundTimerContainer: UIView?
    private var timePickerContainer: UIView?
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonTap))
        return closeButton
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
        navigationItem.leftBarButtonItem = closeBarButtonItem
        view.backgroundColor = .systemBlue
        
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: ViewControllerable
    func addRoundTimer(_ view: ViewControllable) {
        let vc = view.uiviewController                
        addChild(vc)
        
        roundTimerContainer = vc.view
        roundTimerContainer!.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(roundTimerContainer!)
        NSLayoutConstraint.activate([
            roundTimerContainer!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            roundTimerContainer!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        
        vc.didMove(toParent: self)
    }
    
    //MARK: Presentable
    
    func setResume() {
        UIView.animate(withDuration: 0.5.second) { [weak self] in
            self?.view.backgroundColor = .black
        }
    }
    
    func setSuspend() {
        UIView.animate(withDuration: 0.5.second) { [weak self] in
            self?.view.backgroundColor = .systemBlue
        }
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func setFinish() {
        UIView.animate(withDuration: 0.3.second) { [weak self] in
            self?.view.backgroundColor = .systemBlue
        }
        
        let firework = ConfettiParticle()   //FireworkParticle()
        firework.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(firework)
        NSLayoutConstraint.activate([
            firework.topAnchor.constraint(equalTo: view.topAnchor),
            firework.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firework.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firework.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
    }
    
    // MARK: Presentable

    func showActionDialog() {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: UIDevice.current.userInterfaceIdiom == .pad ? .alert : .actionSheet
        )
        
        
        let cancelAction = UIAlertAction(title: "cancel_timer".localized(tableName: "Timer"), style: .default) { [weak self] _ in
            self?.listener?.cancelButtonDidTap()
        }
        
        let finishAction = UIAlertAction(title: "finish_timer".localized(tableName: "Timer"), style: .default) { [weak self] _ in
            self?.listener?.finishButtonDidTap()
        }
        
        let dismissAction = UIAlertAction(title: "dismiss".localized(tableName: "Timer"), style: .cancel)
        
        alertController.addAction(dismissAction)
        alertController.addAction(cancelAction)
        alertController.addAction(finishAction)
        self.present(alertController, animated: true)
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
