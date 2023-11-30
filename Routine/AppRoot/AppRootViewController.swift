//
//  AppRootViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import UIKit

protocol AppRootPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AppRootViewController: UITabBarController, AppRootPresentable, AppRootViewControllable {

    weak var listener: AppRootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isHidden = true
        view.backgroundColor = .systemBackground
    }
}


extension AppRootViewController: AppHomeViewControllable{
    
    func setViewControllers(_ viewControllers: [ViewControllable]) {
        
        tabBar.isHidden = false
        view.backgroundColor = .clear
        
        super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
}
