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
        setTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
        setTableView()
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
    
    
    func setTableView(){
        
        periodLabel.text = "2023.11.13 ~ 2023.11.17"
        
        let models = [
            WeeklyTableModel(
                title: "Take medicine",
                emoji: "💊",
                tint: "#FFCCCCFF",
                done: [Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),]
            ),
            WeeklyTableModel(
                title: "Running",
                emoji: "🏃",
                tint: "#FFFFCCFF",
                done: [Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),]
            ),
            WeeklyTableModel(
                title: "Exercise",
                emoji: "💪",
                tint: "#E5CCFFFF",
                done: [Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),]
            ),
            WeeklyTableModel(
                title: "Keep a diary",
                emoji: "✍️",
                tint: "#FFCCE5FF",
                done: [Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),]
            ),
            WeeklyTableModel(
                title: "Driving",
                emoji: "🚗",
                tint: "#CCFFFFFF",
                done: [Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),]
            ),
            WeeklyTableModel(
                title: "Drink water",
                emoji: "💧",
                tint: "#FFCCCCFF",
                done: [Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),]
            ),
            WeeklyTableModel(
                title: "Study hard",
                emoji: "📖",
                tint: "#C0C0C0FF",
                done: [Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),]
            ),
            WeeklyTableModel(
                title: "Walk a dog",
                emoji: "🦮",
                tint: "#E09FFFFF",
                done: [Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),]
            ),
            WeeklyTableModel(
                title: "Basketball",
                emoji: "🏀",
                tint: "#FFE5CCFF",
                done: [Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),]
            ),
            WeeklyTableModel(
                title: "Beer",
                emoji: "🍻",
                tint: "#CCFFCCFF",
                done: [Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),Bool.random(),]
            ),
        ]
                
        weeklyTableView.bindView(models.map(WeeklyTableDataEntry.init))
    }
}
