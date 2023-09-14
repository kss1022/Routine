//
//  RoutineHomeViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import UIKit

protocol RoutineHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineHomeViewController: UIViewController, RoutineHomePresentable, RoutineHomeViewControllable {

    weak var listener: RoutineHomePresentableListener?
    
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
        tabBarItem = UITabBarItem(
            title: "Routine",
            image: UIImage(systemName: "checkmark.seal"),
            selectedImage: UIImage(systemName: "checkmark.seal.fill")
        )
        view.backgroundColor = .white
    }
}

