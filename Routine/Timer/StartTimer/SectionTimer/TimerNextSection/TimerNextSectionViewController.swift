//
//  TimerNextSectionViewController.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs
import UIKit

protocol TimerNextSectionPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class TimerNextSectionViewController: UIViewController, TimerNextSectionPresentable, TimerNextSectionViewControllable {

    weak var listener: TimerNextSectionPresentableListener?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .headline)
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setFont(style: .subheadline)
        label.textColor = .label
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(style: .title3)
        label.textColor = .label
        return label
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
        
        stackView.addArrangedSubview(titleStackView)
        stackView.addArrangedSubview(timeLabel)
        
        titleStackView.addArrangedSubview(nameLabel)
        titleStackView.addArrangedSubview(descriptionLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
        ])
        
        updateTransition()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateTransition()
        }, completion: nil)
        updateTransition()
    }
    
    private func updateTransition(){
        if !UIDevice.current.orientation.isLandscape{
            stackView.axis = .horizontal
        }else{
            stackView.axis = .vertical
        }
    }
    
    func setNextSection(_ viewModel: TimerNextSectionViewModel) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        timeLabel.text = viewModel.time
    }
    
    func removeNextSection() {
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
            
}
