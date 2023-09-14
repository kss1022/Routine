//
//  RecordHomeViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import UIKit

protocol RecordHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RecordHomeViewController: UIViewController, RecordHomePresentable, RecordHomeViewControllable {

    weak var listener: RecordHomePresentableListener?
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    
    private func setLayout(){
        title = "Record"
        tabBarItem = UITabBarItem(
            title: "Record",
            image: UIImage(systemName: "flag"),    //pencil.circle
            selectedImage: UIImage(systemName: "flag.fill")
        )
        view.backgroundColor = .white
    }
}

