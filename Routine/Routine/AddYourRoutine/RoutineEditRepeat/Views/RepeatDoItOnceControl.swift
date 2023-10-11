//
//  RepeatDoItOnceControl.swift
//  Routine
//
//  Created by 한현규 on 10/10/23.
//

import UIKit
import FSCalendar



final class RepeatDoItOnceControl: UIControl{
    
    
    public var selectedDay: Date

    private var heightConstraint: NSLayoutConstraint!
    
    private lazy var weekCalender : FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.dataSource = self
        calendar.delegate = self
        
        
        calendar.setScope(.month, animated: false)
        
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal
        
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.headerTitleColor = .label
        calendar.appearance.weekdayTextColor = .gray
        calendar.appearance.eventDefaultColor = .red
        calendar.appearance.selectionColor = .blue
                
        calendar.select(selectedDay)
        return calendar
    }()
    
    
    
    init(){
        self.selectedDay = .init()
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        self.selectedDay = .init()
        super.init(coder: coder)
        
        setView()
    }
    

    
    private func setView(){
        self.addSubview(weekCalender)
        
        self.heightConstraint = weekCalender.heightAnchor.constraint(equalToConstant: 300.0)
        
        NSLayoutConstraint.activate([
            weekCalender.topAnchor.constraint(equalTo: self.topAnchor),
            weekCalender.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            weekCalender.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            weekCalender.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            heightConstraint
        ])
    }
    
    
    func setDate(date: Date){
        Log.v("Set DoItOnceControl: \(date)")
        self.selectedDay = date
        weekCalender.select(date)
    }
}


extension RepeatDoItOnceControl: FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        heightConstraint.constant = CGRectGetHeight(bounds);
        // Do other updates here        
        self.layoutIfNeeded()
    }
    
    
}


extension RepeatDoItOnceControl: FSCalendarDelegate{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectedDay = date
        self.sendActions(for: .valueChanged)
    }

}
