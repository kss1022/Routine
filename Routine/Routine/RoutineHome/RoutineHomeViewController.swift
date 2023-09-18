//
//  RoutineHomeViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import UIKit
import CocoaLumberjackSwift

protocol RoutineHomePresentableListener: AnyObject {
    func createRoutineDidTap()
}

final class RoutineHomeViewController: UIViewController, RoutineHomePresentable, RoutineHomeViewControllable {

    weak var listener: RoutineHomePresentableListener?
    
    
    private lazy var createRoutineBarButtonItem : UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle"),
            style: .plain,
            target: self,
            action: #selector(createRoutineBarButtonTap)
        )
        return button
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
        title = "Routine"
        
        navigationItem.rightBarButtonItems = [ createRoutineBarButtonItem]

        
        tabBarItem = UITabBarItem(
            title: "Routine",
            image: UIImage(systemName: "checkmark.seal"),
            selectedImage: UIImage(systemName: "checkmark.seal.fill")
        )
        view.backgroundColor = .white
    }
    

    @objc
    private func createRoutineBarButtonTap(){
        listener?.createRoutineDidTap()
    }
}

