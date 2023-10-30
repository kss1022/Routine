//
//  SectionTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs
import UIKit

protocol SectionTimerPresentableListener: AnyObject {
    func closeButtonDidTap()
}

final class SectionTimerViewController: UIViewController, SectionTimerPresentable, SectionTimerViewControllable {
    
    weak var listener: SectionTimerPresentableListener?
    

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

        view.backgroundColor = .systemBackground
        
        
        view.addSubview(stackView)
         
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
    
    
    @objc
    private func closeBarButtonTap(){
        self.listener?.closeButtonDidTap()
    }
}
