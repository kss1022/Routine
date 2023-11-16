//
//  AppInfoViewController.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs
import UIKit

protocol AppInfoPresentableListener: AnyObject {
    func closeBarButtonDidTap()
}

final class AppInfoViewController: UIViewController, AppInfoPresentable, AppInfoViewControllable {

    weak var listener: AppInfoPresentableListener?
    
    private lazy var closeBarButtonItem: UIBarButtonItem = {
        let closeButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBarButtonTap))
        return closeButton
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
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }
    
    
    @objc
    private func closeBarButtonTap(){
        listener?.closeBarButtonDidTap()
    }
}
