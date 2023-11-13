//
//  RecordWeekTableBannerCell.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import UIKit


final class RecordWeekTableBannerCell: UICollectionViewCell{
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Check your weeklyTracker✅"
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 2
        return label
    }()
      
    private let weeklyTableView: WeeklyTableView = {
        let tableView = WeeklyTableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.setFont(size: 11.0)
        tableView.setItemSize(size: 22.0)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
        setTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
        setTableView()
    }
    
   
    private func setView(){
        contentView.roundCorners()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(weeklyTableView)
        

        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            weeklyTableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32.0),
            weeklyTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32.0),
            weeklyTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32.0),
            weeklyTableView.bottomAnchor.constraint(lessThanOrEqualTo: titleLabel.topAnchor, constant: -16.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset),
        ])

        
        titleLabel.setContentCompressionResistancePriority(.init(751), for: .vertical)
    }
    
    
    func setTableView(){
        //WeeklyTableModel(datas:
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
