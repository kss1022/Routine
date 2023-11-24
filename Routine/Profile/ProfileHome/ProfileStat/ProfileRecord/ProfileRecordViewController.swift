//
//  ProfileRecordViewController.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs
import UIKit

protocol ProfileRecordPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class ProfileRecordViewController: UIViewController, ProfileRecordPresentable, ProfileRecordViewControllable {
    
    weak var listener: ProfileRecordPresentableListener?
    
    
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
            testView.heightAnchor.constraint(equalToConstant: 30.0),
        ])
        
        testView.backgroundColor = .secondarySystemBackground
    }}
