//
//  RoutineWeekCalenderViewController.swift
//  Routine
//
//  Created by 한현규 on 10/5/23.
//

import ModernRIBs
import UIKit
import FSCalendar

protocol RoutineWeekCalenderPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineWeekCalenderViewController: UIViewController, RoutineWeekCalenderPresentable, RoutineWeekCalenderViewControllable {

    weak var listener: RoutineWeekCalenderPresentableListener?
    
    
    private var heightConstraint: NSLayoutConstraint!
    
    private lazy var weekCalender : FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.dataSource = self
        calendar.delegate = self
        
        //calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.setScope(.week, animated: false)
        
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal
                
        calendar.calendarHeaderView.isHidden = true
        calendar.headerHeight = 6.0
        
        //calendar.appearance.headerTitleColor = .label
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.weekdayTextColor = .gray
        calendar.appearance.eventDefaultColor = .red
        calendar.appearance.selectionColor = .blue                                
        
        return calendar
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
        view.addSubview(weekCalender)
        
        self.heightConstraint = weekCalender.heightAnchor.constraint(equalToConstant: 300.0)
        
        NSLayoutConstraint.activate([
            weekCalender.topAnchor.constraint(equalTo: view.topAnchor),
            weekCalender.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weekCalender.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weekCalender.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            heightConstraint
        ])
        
        
    }
}


extension RoutineWeekCalenderViewController: FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        heightConstraint.constant = CGRectGetHeight(bounds);
        // Do other updates here
        
        view.layoutIfNeeded()
    }
    
    //Handling event dots:
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//    }
}


extension RoutineWeekCalenderViewController: FSCalendarDelegate{
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        Log.v("FSCalendarDelegate didSelect: \(date) \(monthPosition)")
    }

}


//extension RoutineWeekCalenderViewController: FSCalendarDelegateAppearance{
//    
//}
