//
//  RecordHomeViewController.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import UIKit

protocol RecordHomePresentableListener: AnyObject {
}

final class RecordHomeViewController: UIViewController, RecordHomePresentable, RecordHomeViewControllable {
    
    weak var listener: RecordHomePresentableListener?
    
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
        
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16.0
        return stackView
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
        title = "record".localized(tableName: "Record")
        tabBarItem = UITabBarItem(
            title: "record".localized(tableName: "Record"),
            image: UIImage(systemName: "flag"),    //pencil.circle
            selectedImage: UIImage(systemName: "flag.fill")
        )
        
        view.backgroundColor = .systemBackground
                
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setBanner(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func setRoutineList(_ view: ModernRIBs.ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func setTimerList(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
}

