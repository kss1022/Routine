//
//  SettingAppAlarmViewController.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs
import UIKit

protocol SettingAppAlarmPresentableListener: AnyObject {
    func didMove()
}

final class SettingAppAlarmViewController: UIViewController, SettingAppAlarmPresentable, SettingAppAlarmViewControllable {

    weak var listener: SettingAppAlarmPresentableListener?
    
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
    
 
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent == nil{
            listener?.didMove()
        }
    }
}
