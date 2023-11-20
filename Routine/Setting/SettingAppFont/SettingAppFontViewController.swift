//
//  SettingAppFontViewController.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs
import UIKit

protocol SettingAppFontPresentableListener: AnyObject {
    func didMove()
}

final class SettingAppFontViewController: UIViewController, SettingAppFontPresentable, SettingAppFontViewControllable {

    weak var listener: SettingAppFontPresentableListener?
            
    private let stakView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0.0
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
        
        view.addSubview(stakView)
        
        NSLayoutConstraint.activate([
            stakView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stakView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stakView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stakView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
 
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent == nil{
            listener?.didMove()
        }
    }
    
    
    func setFontPreview(_ view: ViewControllable) {
        let vc = view.uiviewController        
        addChild(vc)
        stakView.addArrangedSubview(vc.view)
        
        vc.didMove(toParent: self)
    }
    
    func setSettingFont(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        stakView.addArrangedSubview(vc.view)
        
        vc.didMove(toParent: self)
    }
    
}
