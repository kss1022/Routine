//
//  RoutineDataOfYearViewController.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs
import UIKit

protocol RoutineDataOfYearPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
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
        
        cardView.addSubview(gressView)
                
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
                        
            cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
            
            gressView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: inset),
            gressView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: inset),
            gressView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -inset),
            gressView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -inset),
        ])
        
        
    }
    
    func setComplets(_ dates: Set<Date>) {
        gressView.bindView(GressViewModel(year: 2023, selects: dates))
    }
    


}
