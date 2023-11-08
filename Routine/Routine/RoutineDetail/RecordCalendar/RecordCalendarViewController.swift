//
//  RecordCalendarViewController.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import ModernRIBs
import UIKit
import FSCalendar

protocol RecordCalendarPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RecordCalendarViewController: UIViewController, RecordCalendarPresentable, RecordCalendarViewControllable {

    weak var listener: RecordCalendarPresentableListener?

    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    private var heightConstraint: NSLayoutConstraint!
    private var completes = Set<Date>()
    

    private lazy var calendar : FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.dataSource = self
        calendar.delegate = self
        
        //calendar.locale = Locale(identifier: "ko_KR")
        
        calendar.setScope(.month, animated: false)
        
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal
        calendar.allowsMultipleSelection = true
        //calendar.swipeToChooseGesture.isEnabled = true
        
//        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
//        calendar.addGestureRecognizer(scopeGesture)
        
        
        calendar.today = nil // Hide the today circle
        
        calendar.appearance.headerTitleColor = .label
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.weekdayTextColor = .gray
        
        //calendar.appearance.selectionColor = .primaryColor
        calendar.appearance.eventDefaultColor = .systemRed
        calendar.appearance.eventSelectionColor = .systemRed
        //calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        
        calendar.register(RecordCalenderCell.self, forCellReuseIdentifier: RecordCalenderCell.reuseIdentifier)

        
        
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
        view.backgroundColor = .systemBackground
        view.addSubview(calendar)
        
        let height =  UIDevice.current.model.hasPrefix("iPad") ? 400.0 : 300
        self.heightConstraint = calendar.heightAnchor.constraint(equalToConstant: height)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            calendar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            calendar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            calendar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
            heightConstraint
        ])
    }
    
    func setCompletes(_ dates: Set<Date>) {
        
        
        let addedElements = dates.subtracting(completes)
        let removedElements = completes.subtracting(dates)
        
        
        addedElements.forEach {
            calendar.select($0, scrollToDate: false)
        }
        
        removedElements.forEach {
            calendar.deselect($0)
        }
                
        completes = dates        
        calendar.reloadData()
        
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else { return }
            self.calendar.reloadData()
            self.calendar.select(self.calendar.selectedDate)
        }, completion: nil)
    }
    
}


extension RecordCalendarViewController: FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        heightConstraint.constant = CGRectGetHeight(bounds);
        // Do other updates here
        view.layoutIfNeeded()
    }
    
    
    
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
//        if self.gregorian.isDateInToday(date){
//            return 1
//        }
//        
//        return 0
//    }
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: RecordCalenderCell.reuseIdentifier, for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    
}


extension RecordCalendarViewController: FSCalendarDelegate{
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
    }
    
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        false
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        false
    }
        

}


extension RecordCalendarViewController: FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        return [appearance.eventDefaultColor]
    }
}

private extension RecordCalendarViewController{
    // MARK: - Private functions
    
    private func configureVisibleCells() {
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! RecordCalenderCell)
        // Custom today circle
        //diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        diyCell.circleImageView.isHidden = true
        
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
            diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }
    
}
