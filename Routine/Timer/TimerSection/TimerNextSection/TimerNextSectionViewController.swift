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
    
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
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
        view.addSubview(stackView)
                
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func setNextSection(_ viewModel: TimerNextSectionViewModel) {
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let sectionView = TimerNextSectionView(viewModel)
        self.stackView.addArrangedSubview(sectionView)
    }
    
    func removeNextSection() {
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
            
}
