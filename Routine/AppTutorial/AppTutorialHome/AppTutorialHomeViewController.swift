//
//  AppTutorialHomeViewController.swift
//  Routine
//
//  Created by 한현규 on 11/27/23.
//

import ModernRIBs
import UIKit

protocol AppTutorialHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AppTutorialHomeViewController: UIPageViewController, AppTutorialHomePresentable, AppTutorialHomeViewControllable {

    weak var listener: AppTutorialHomePresentableListener?
    
    
    init(){
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setLayout(){
        view.backgroundColor = .primaryColor
    }
            
    
    func replaceView(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        self.setViewControllers([vc], direction: .forward, animated: false)
        vc.didMove(toParent: self)
    }
    
}


//    func replaceView(_ view: ViewControllable) {
//        if let presentedViewControllable = presentedViewControllable{
//            presentedViewControllable.uiviewController.view.removeFromSuperview()
//            presentedViewControllable.uiviewController.removeFromParent()
//        }
//        setPresentedViewControllable(view)
//    }
//
//    private var presentedViewControllable: ViewControllable?
//
//    private func setPresentedViewControllable(_ view: ViewControllable){
//        self.presentedViewControllable = view
//
//
//        let vc = view.uiviewController
//        addChild(vc)
//
//        let presentedView = vc.view!
//        self.view.addSubview(presentedView)
//        NSLayoutConstraint.activate([
//            presentedView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            presentedView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
//            presentedView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
//            presentedView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//
//        vc.didMove(toParent: self)
//    }

