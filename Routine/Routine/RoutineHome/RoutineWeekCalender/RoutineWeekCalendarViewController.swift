//
//  RoutineWeekCalendarViewController.swift
//  Routine
//
//  Created by 한현규 on 10/5/23.
//

import ModernRIBs
import UIKit
import FSCalendar

protocol RoutineWeekCalendarPresentableListener: AnyObject {
    func weekCalendarDidTap(date: Date)
}

final class RoutineWeekCalendarViewController: UIViewController, RoutineWeekCalendarPresentable, RoutineWeekCalendarViewControllable {

    weak var listener: RoutineWeekCalendarPresentableListener?
    
    
    private var heightConstraint: NSLayoutConstraint!
    
    private lazy var weekCalendar : FSCalendar = {
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
        calendar.appearance.selectionColor = .primaryColor
        calendar.select(Date())
        
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
        view.addSubview(weekCalendar)
        
        let height =  UIDevice.current.model.hasPrefix("iPad") ? 400.0 : 300.0
        self.heightConstraint = weekCalendar.heightAnchor.constraint(equalToConstant: height)
        
        NSLayoutConstraint.activate([
            weekCalendar.topAnchor.constraint(equalTo: view.topAnchor),
            weekCalendar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weekCalendar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weekCalendar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            heightConstraint
        ])
        
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            self.weekCalendar.reloadData()
            self.weekCalendar.select(self.weekCalendar.selectedDate)
        }, completion: nil)
    }
}


extension RoutineWeekCalendarViewController: FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        heightConstraint.constant = CGRectGetHeight(bounds);
        // Do other updates here
        
        view.layoutIfNeeded()
    }
    
    //Handling event dots:
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//    }
}


extension RoutineWeekCalendarViewController: FSCalendarDelegate{
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageDate = calendar.currentPage
        Log.v("\(Formatter.recordDateFormatter().string(from: currentPageDate))")        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        listener?.weekCalendarDidTap(date: date)
    }

}

extension RoutineWeekCalendarViewController: FSCalendarDelegateAppearance {
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        let day = Calendar.current.component(.weekday, from: date) - 1
        
        if Calendar.current.shortWeekdaySymbols[day] == "Sun"{  //"일"
            return .systemRed
        } else if Calendar.current.shortWeekdaySymbols[day] == "Sat"{   //"토"
            return .systemBlue
        } else if date == calendar.today{
            return .white
        }else{
            return .label
        }
    }
}
