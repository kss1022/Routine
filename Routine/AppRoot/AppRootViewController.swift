//
//  AppRootViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import UIKit

protocol AppRootPresentableListener: AnyObject {
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
