//
//  RoutineWeeklyTableCell.swift
//  Routine
//
//  Created by 한현규 on 11/21/23.
//

import UIKit



final class RoutineWeeklyTableCell: UICollectionViewCell{
    
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let periodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .subheadline)        
        label.textColor = .label
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
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
        
        tableView.setFont(size: 12.0)
        tableView.setItemSize(size: 24.0)
        return tableView
    }()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    private func setView(){
        contentView.addSubview(scrollView)
        
        scrollView.addSubview(periodLabel)
        scrollView.addSubview(cardView)
                
        cardView.addSubview(weeklyTableView)
        
        
        let inset: CGFloat = 16.0
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            periodLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32.0),
            periodLabel.leadingAnchor.constraint(greaterThanOrEqualTo: cardView.leadingAnchor, constant: inset),
            periodLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -inset),
                        
            cardView.topAnchor.constraint(equalTo: periodLabel.bottomAnchor, constant: 24.0),
            cardView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            cardView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            cardView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -inset),
            
            weeklyTableView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: inset),
            weeklyTableView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: inset),
            weeklyTableView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -inset),
            weeklyTableView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -inset),  
        ])
    }

    
    func setPeriod(period: String){
        periodLabel.text = period
    }
    
    func setColumns(_ columns: [WeeklyTableColumn]){
        weeklyTableView.columns(columns: columns)
    }
    
    func setDatas(_ datas: [WeekTableDataEntry]){
        weeklyTableView.datas(datas: datas)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        periodLabel.text = nil
        weeklyTableView.datas(datas: [])
    }
}
