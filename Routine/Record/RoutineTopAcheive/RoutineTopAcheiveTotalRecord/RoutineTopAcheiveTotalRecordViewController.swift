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
    
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .title3)
        label.textColor = .label
        label.text = "Total number of achievements"
        label.numberOfLines = 2
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        return stackView
    }()
    
    private let totalDoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .callout)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let totalDoneSubLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .footnote)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.numberOfLines = 0
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
        view.addSubview(titleLabel)
        view.addSubview(labelStackView)
        
        
        labelStackView.addArrangedSubview(totalDoneLabel)
        labelStackView.addArrangedSubview(totalDoneSubLabel)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -inset),
            
            labelStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24.0),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32.0),
            labelStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32.0),
            labelStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24.0)
        ])
    }
    
    func setTotalCount(totalCount: Int, sub: String) {
        totalDoneLabel.text = "\(totalCount) Done!!!"
        totalDoneSubLabel.text = sub
    }
}
