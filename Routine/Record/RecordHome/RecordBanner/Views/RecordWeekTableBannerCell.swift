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
        label.font = .getBoldFont(size: 18.0)
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
        
        let models = [
            RecordWeekTableBannerViewModel(
                title: "Take medicine",
                emoji: "💊",
                tint: "#FFCCCCFF",
                sunday: Bool.random(),
                monday: Bool.random(),
                tuesday: Bool.random(),
                wednesday: Bool.random(),
                thursday: Bool.random(),
                friday: Bool.random(),
                saturday: Bool.random()
            ),
            RecordWeekTableBannerViewModel(
                title: "Running",
                emoji: "🏃",
                tint: "#FFFFCCFF",
                sunday: Bool.random(),
                monday: Bool.random(),
                tuesday: Bool.random(),
                wednesday: Bool.random(),
                thursday: Bool.random(),
                friday: Bool.random(),
                saturday: Bool.random()
            ),
            RecordWeekTableBannerViewModel(
                title: "Exercise",
                emoji: "💪",
                tint: "#E5CCFFFF",
                sunday: Bool.random(),
                monday: Bool.random(),
                tuesday: Bool.random(),
                wednesday: Bool.random(),
                thursday: Bool.random(),
                friday: Bool.random(),
                saturday: Bool.random()
            ),
            RecordWeekTableBannerViewModel(
                title: "Keep a diary",
                emoji: "✍️",
                tint: "#FFCCE5FF",
                sunday: Bool.random(),
                monday: Bool.random(),
                tuesday: Bool.random(),
                wednesday: Bool.random(),
                thursday: Bool.random(),
                friday: Bool.random(),
                saturday: Bool.random()
            ),
            RecordWeekTableBannerViewModel(
                title: "Driving",
                emoji: "🚗",
                tint: "#CCFFFFFF",
                sunday: Bool.random(),
                monday: Bool.random(),
                tuesday: Bool.random(),
                wednesday: Bool.random(),
                thursday: Bool.random(),
                friday: Bool.random(),
                saturday: Bool.random()
            ),
            RecordWeekTableBannerViewModel(
                title: "Drink water",
                emoji: "💧",
                tint: "#FFCCCCFF",
                sunday: Bool.random(),
                monday: Bool.random(),
                tuesday: Bool.random(),
                wednesday: Bool.random(),
                thursday: Bool.random(),
                friday: Bool.random(),
                saturday: Bool.random()
            ),
            RecordWeekTableBannerViewModel(
                title: "Study hard",
                emoji: "📖",
                tint: "#C0C0C0FF",
                sunday: Bool.random(),
                monday: Bool.random(),
                tuesday: Bool.random(),
                wednesday: Bool.random(),
                thursday: Bool.random(),
                friday: Bool.random(),
                saturday: Bool.random()
            ),
            RecordWeekTableBannerViewModel(
                title: "Walk a dog",
                emoji: "🦮",
                tint: "#E09FFFFF",
                sunday: Bool.random(),
                monday: Bool.random(),
                tuesday: Bool.random(),
                wednesday: Bool.random(),
                thursday: Bool.random(),
                friday: Bool.random(),
                saturday: Bool.random()
            ),
            RecordWeekTableBannerViewModel(
                title: "Basketball",
                emoji: "🏀",
                tint: "#FFE5CCFF",
                sunday: Bool.random(),
                monday: Bool.random(),
                tuesday: Bool.random(),
                wednesday: Bool.random(),
                thursday: Bool.random(),
                friday: Bool.random(),
                saturday: Bool.random()
            ),
            RecordWeekTableBannerViewModel(
                title: "Beer",
                emoji: "🍻",
                tint: "#CCFFCCFF",
                sunday: Bool.random(),
                monday: Bool.random(),
                tuesday: Bool.random(),
                wednesday: Bool.random(),
                thursday: Bool.random(),
                friday: Bool.random(),
                saturday: Bool.random()
            ),
        ]
                
        weeklyTableView.datas(datas: models.map(WeekTableDataEntry.init))
        weeklyTableView.columns(columns: models.map(WeeklyTableColumn.init))
        
        //weeklyTableView.bindView(models.map(WeeklyTableDataEntry.init))

    }

}


struct RecordWeekTableBannerViewModel{
    let id: UUID
    let title: String
    let emoji: String
    let tint: UIColor?
    let sunday: Bool
    let monday: Bool
    let tuesday: Bool
    let wednesday: Bool
    let thursday: Bool
    let friday: Bool
    let saturday: Bool
    
    init(title: String, emoji: String, tint: String, sunday: Bool, monday: Bool, tuesday: Bool, wednesday: Bool, thursday: Bool, friday: Bool, saturday: Bool) {
        self.id = UUID()
        self.title = title
        self.emoji = emoji
        self.tint = UIColor(hex: tint)
        self.sunday = sunday
        self.monday = monday
        self.tuesday = tuesday
        self.wednesday = wednesday
        self.thursday = thursday
        self.friday = friday
        self.saturday = saturday
    }
    
//    init(_ model: RoutineWeeklyTrackerModel) {
////        self.title = model.routineName
//        self.emoji = model.emojiIcon
//        self.tint = UIColor(hex: model.tint)
//        self.sunday = model.sunday
//        self.monday = model.monday
//        self.tuesday = model.tuesday
//        self.wednesday = model.wednesday
//        self.thursday = model.thursday
//        self.friday = model.friday
//        self.saturday = model.saturday
//    }
    
}
