//
//  AppTutorialSplashViewController.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs
import UIKit

protocol AppTutorialSplashPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AppTutorialSplashViewController: UIPageViewController, AppTutorialSplashPresentable, AppTutorialSplashViewControllable {

    weak var listener: AppTutorialSplashPresentableListener?
    
    
    
    init(){
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
 
    
    func setPage(page: Int) {
        switch page{
        case 0:
            setViewControllers([AppTutorailSplashView1()], direction: .forward, animated: false)
        case 1:
            setViewControllers([AppTutorailSplashView2()], direction: .forward, animated: false)
        case 2:
            setViewControllers([AppTutorailSplashView3()], direction: .forward, animated: false)
        case 3:
            setViewControllers([AppTutorailSplashView4()], direction: .forward, animated: false)
        default: break
        }
    }
}
