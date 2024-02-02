//
//  ProfileMenuViewController.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs
import UIKit

protocol ProfileMenuPresentableListener: AnyObject {
}

final class ProfileMenuViewController: UIViewController, ProfileMenuPresentable, ProfileMenuViewControllable {

    weak var listener: ProfileMenuPresentableListener?
    

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 32.0
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
        view.addSubview(stackView)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
        ])
    }
    
    func setMenus(_ viewModels: [ProfileMenuListViewModel]) {
        viewModels.map(ProfileMenuListView.init)
            .forEach { stackView.addArrangedSubview($0) }
    }
        
    func setMenu(_ viewModel: ProfileRequestReviewListViewModel) {
        stackView.addArrangedSubview(ProfileRequestReviewListView(viewModel))
    }

}
