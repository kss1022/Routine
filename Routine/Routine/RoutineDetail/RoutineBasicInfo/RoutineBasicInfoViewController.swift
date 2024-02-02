//
//  RoutineBasicInfoViewController.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import ModernRIBs
import UIKit

protocol RoutineBasicInfoPresentableListener: AnyObject {
}

final class RoutineBasicInfoViewController: UIViewController, RoutineBasicInfoPresentable, RoutineBasicInfoViewControllable {

    weak var listener: RoutineBasicInfoPresentableListener?
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "basic_Info".localized(tableName: "Routine")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .headline)
        label.textColor = .black
        return label
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
    
    private let repeatBasicInfoView : BasicInfoView = {
        let view = BasicInfoView()
        view.setImage(UIImage(systemName: "repeat.circle.fill"))
        return view
    }()
    
    private let reminderBasicInfoView : BasicInfoView = {
        let view = BasicInfoView()
        view.setImage(UIImage(systemName: "clock.fill"))
        return view
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
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(repeatBasicInfoView)
        stackView.addArrangedSubview(reminderBasicInfoView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                                    
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func repeatInfo(info: String) {
        repeatBasicInfoView.setTitle(info)
    }
    
    func reminderInfo(info: String) {
        reminderBasicInfoView.setTitle(info)
    }

}
