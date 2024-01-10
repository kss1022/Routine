//
//  RoutineDataOfYearViewController.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs
import UIKit

protocol RoutineDataOfYearPresentableListener: AnyObject {
    func leftButtonDidTap()
    func rightButtonDidTap()
}

final class RoutineDataOfYearViewController: UIViewController, RoutineDataOfYearPresentable, RoutineDataOfYearViewControllable {

    weak var listener: RoutineDataOfYearPresentableListener?
    

    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "date_of_year".localized(tableName: "Record")
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.addShadowWithRoundedCorners()
        return view
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .system)
        
        let image = UIImage(systemName: "arrow.left.circle")?.setSize(pointSize: 22.0)
        button.setImage(image, for: .normal)
        button.tintColor = .tertiaryLabel
        button.addTarget(self, action: #selector(leftButtonTap), for: .touchUpInside)
        return button
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.font = .getBoldFont(size: 14.0)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        
        let image = UIImage(systemName: "arrow.right.circle")?.setSize(pointSize: 22.0)
        button.setImage(image, for: .normal)
        button.tintColor = .tertiaryLabel
        button.addTarget(self, action: #selector(rightButtonTap), for: .touchUpInside)
        return button
    }()
    
    
    private let gressView: GressView = {
        let view = GressView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        view.addSubview(cardView)
        
        cardView.addSubview(titleStackView)
        cardView.addSubview(gressView)
        
        titleStackView.addArrangedSubview(leftButton)
        titleStackView.addArrangedSubview(yearLabel)
        titleStackView.addArrangedSubview(rightButton)
                
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
                        
            cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
            
            titleStackView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: inset),
            titleStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: inset),
            titleStackView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -inset),
            
            gressView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: inset),
            gressView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: inset),
            gressView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -inset),
            gressView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -inset),
        ])
        
        
    }
    
    
    func setComplets(year: Int, dates: Set<Date>) {
        yearLabel.text = "\(year)"
        gressView.bindView(GressViewModel(year: year, selects: dates))
    }
        

    @objc
    private func leftButtonTap(){
        listener?.leftButtonDidTap()
    }
    
    @objc
    private func rightButtonTap(){
        listener?.rightButtonDidTap()
    }

}
