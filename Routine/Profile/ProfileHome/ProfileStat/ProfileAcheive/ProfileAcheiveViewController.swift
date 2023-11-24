//
//  ProfileAcheiveViewController.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs
import UIKit

protocol ProfileAcheivePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ProfileAcheiveViewController: UIViewController, ProfileAcheivePresentable, ProfileAcheiveViewControllable {
    
    weak var listener: ProfileAcheivePresentableListener?
    
    private let testView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        view.addSubview(testView)
        
        NSLayoutConstraint.activate([
            testView.topAnchor.constraint(equalTo: view.topAnchor),
            testView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            testView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            testView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            testView.heightAnchor.constraint(equalToConstant: 50.0),
        ])
        
        testView.backgroundColor = .secondarySystemBackground
    }
}
