//
//  RoutineDetailViewController.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs
import UIKit

protocol RoutineDetailPresentableListener: AnyObject {
    func editButtonDidTap()
}

final class RoutineDetailViewController: UIViewController, RoutineDetailPresentable, RoutineDetailViewControllable {

    weak var listener: RoutineDetailPresentableListener?
    
    var panGestureRecognizer: UIPanGestureRecognizer!

    
    private lazy var editBarButtonItem: UIBarButtonItem = {
        let editButton = RoutineEditButton()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        editButton.addGestureRecognizer(tap)
        
        let barButtonItem = UIBarButtonItem(customView: editButton)
        return barButtonItem
    }()
            
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
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
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = editBarButtonItem
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
                
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: stackView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
        ])
        
    }

    
//    override func didMove(toParent parent: UIViewController?) {
//        super.didMove(toParent: parent)
//        if parent == nil{
//            listener?.didMoved()
//        }
//    }
    
    
    func addTitle(_ view: ViewControllable) {
        let vc = view.uiviewController
        
        addChild(vc)
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func addRecordCalendar(_ view: ViewControllable) {
        let vc = view.uiviewController
        
        addChild(vc)
        vc.view.roundCorners()        
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }

    func setBackgroundColor(_ tint: String) {
        view.backgroundColor = UIColor(hex: tint)
    }
    
    
    
    @objc
    private func didTap(){
        self.listener?.editButtonDidTap()
    }

}

