//
//  RoutineWeeklyTrackerViewController.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs
import UIKit

protocol RoutineWeeklyTrackerPresentableListener: AnyObject {
    func didMove()
}

final class RoutineWeeklyTrackerViewController: UIViewController, RoutineWeeklyTrackerPresentable, RoutineWeeklyTrackerViewControllable {

    weak var listener: RoutineWeeklyTrackerPresentableListener?

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
        title = "weeklyTracker".localized(tableName: "Record")
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)                
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setWeeklyTable(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)        
        stackView.addArrangedSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil{
            listener?.didMove()
        }
    }
}
