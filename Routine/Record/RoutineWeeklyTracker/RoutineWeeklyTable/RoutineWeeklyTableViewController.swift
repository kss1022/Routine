//
//  RoutineWeeklyTableViewController.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs
import UIKit

protocol RoutineWeeklyTablePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineWeeklyTableViewController: UIViewController, RoutineWeeklyTablePresentable, RoutineWeeklyTableViewControllable {

    weak var listener: RoutineWeeklyTablePresentableListener?
    
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    
    private let cardView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        view.addShadowWithRoundedCorners()
        return view
    }()
    
    private let weeklyTableView: WeeklyTableView = {
        let tableView = WeeklyTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
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
        view.roundCorners()
        
        
        view.addSubview(periodLabel)
        
        view.addSubview(cardView)
        cardView.addSubview(weeklyTableView)
        

        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            periodLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            periodLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            
            cardView.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 32.0),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
            
            weeklyTableView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: inset),
            weeklyTableView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: inset),
            weeklyTableView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -inset),
            weeklyTableView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -inset),
        ])
    }
    

    
    func setWeeklyTable(_ viewModels: [WeeklyTableViewModel]) {
        periodLabel.text = "2023.11.13 ~ 2023.11.17"
        weeklyTableView.bindView(viewModels.map(WeeklyTableDataEntry.init))
    }
}
