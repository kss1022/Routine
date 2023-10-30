//
//  FocusTimerViewController.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import ModernRIBs
import UIKit

protocol FocusTimerPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class FocusTimerViewController: UIViewController, FocusTimerPresentable, FocusTimerViewControllable {
    
    

    weak var listener: FocusTimerPresentableListener?
    
    
    private var roundTimerContainer: UIView?
    private var timePickerContainer: UIView?
                  
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
    }    
    
    //MARK: ViewControllerable
    func addRoundTimer(_ view: ViewControllable) {
        let vc = view.uiviewController                
        addChild(vc)
        
        roundTimerContainer = vc.view
        roundTimerContainer!.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(roundTimerContainer!)
        NSLayoutConstraint.activate([
            roundTimerContainer!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            roundTimerContainer!.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        
        vc.didMove(toParent: self)
    }
    
    
    func addTimePicker(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        timePickerContainer = vc.view
        timePickerContainer!.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(timePickerContainer!)
        NSLayoutConstraint.activate([            
            timePickerContainer!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            timePickerContainer!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        vc.didMove(toParent: self)
    }
    
    //MARK: Presentable
    func setTitle(title: String) {
        self.title = title
    }
}
