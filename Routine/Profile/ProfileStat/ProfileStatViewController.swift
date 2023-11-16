//
//  ProfileStatViewController.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs
import UIKit

protocol ProfileStatPresentableListener: AnyObject {
    func segmentControlDidTap(index: Int)
}

final class ProfileStatViewController: UIViewController, ProfileStatPresentable, ProfileStatViewControllable {

    weak var listener: ProfileStatPresentableListener?
    
    
    private lazy var statSegmentControl: ProfileStatSegmentControl = {
        let segmentControl = ProfileStatSegmentControl(items: ["Record","Total","Acheive"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.addTarget(self, action: #selector(segmentControlTap(control:)), for: .valueChanged)
        return segmentControl
    }()
    
    private let pageContainer: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
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
        view.addSubview(statSegmentControl)
        view.addSubview(pageContainer)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            statSegmentControl.topAnchor.constraint(equalTo: view.topAnchor),
            statSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            statSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            pageContainer.topAnchor.constraint(equalTo: statSegmentControl.bottomAnchor, constant: 16.0),
            pageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            pageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            pageContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
        ])
    }
    
    
    func attachProfileRecord(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        pageContainer.addArrangedSubview(vc.view)
        
        vc.didMove(toParent: self)
    }
    
    func detachProfileRecord(_ view: ViewControllable) {
        let vc = view.uiviewController
        
        vc.view.removeFromSuperview()
        vc.removeFromParent()
        
        vc.didMove(toParent: nil)
    }
    
    func attachProfileAcheive(_ view: ViewControllable) {
        let vc = view.uiviewController
        addChild(vc)
        
        pageContainer.addArrangedSubview(vc.view)
        
        vc.didMove(toParent: self)
    }
    
    func detachProfileAcheive(_ view: ViewControllable) {
        let vc = view.uiviewController
        
        vc.view.removeFromSuperview()
        vc.removeFromParent()
        
        vc.didMove(toParent: nil)
    }
    
    
    @objc
    private func segmentControlTap(control: ProfileStatSegmentControl) {
        listener?.segmentControlDidTap(index: control.selectedSegmentIndex)
    }
}
