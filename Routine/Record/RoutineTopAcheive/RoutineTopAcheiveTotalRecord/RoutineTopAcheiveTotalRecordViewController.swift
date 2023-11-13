//
//  RoutineTopAcheiveTotalRecordViewController.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import ModernRIBs
import UIKit

protocol RoutineTopAcheiveTotalRecordPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineTopAcheiveTotalRecordViewController: UIViewController, RoutineTopAcheiveTotalRecordPresentable, RoutineTopAcheiveTotalRecordViewControllable {

    weak var listener: RoutineTopAcheiveTotalRecordPresentableListener?
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    private func setLayout(){
        
    }
}
