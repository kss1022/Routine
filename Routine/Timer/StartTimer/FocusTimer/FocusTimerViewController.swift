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
    func closeButtonDidTap()
}

final class FocusTimerViewController: UIViewController, FocusTimerPresentable, FocusTimerViewControllable {
    
    

    weak var listener: FocusTimerPresentableListener?
    
    
    private var roundTimerContainer: UIView?
    private var timePickerContainer: UIView?
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonTap))
        return closeButton
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
        view.backgroundColor = .black
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
    func setTitle(title: String) {
        self.title = title
    }
    
    func showFinishTimer() {
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
    
    
    
    @objc
    private func closeBarButtonTap(){
        self.listener?.closeButtonDidTap()
    }
}
