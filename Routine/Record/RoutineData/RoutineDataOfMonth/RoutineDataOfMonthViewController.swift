//
//  RoutineDataOfMonthViewController.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import ModernRIBs
import UIKit
import FSCalendar

protocol RoutineDataOfMonthPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class RoutineDataOfMonthViewController: UIViewController, RoutineDataOfMonthPresentable, RoutineDataOfMonthViewControllable {

    weak var listener: RoutineDataOfMonthPresentableListener?
    
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    private var heightConstraint: NSLayoutConstraint!
    private var completes = Set<Date>()

    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "date_of_month".localized(tableName: "Record")
        return label
    }()
        
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.addShadowWithRoundedCorners()
        return view
    }()

    private lazy var calendar : FSCalendar = {
        let calendar = FSCalendar()
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.dataSource = self
        calendar.delegate = self
                
        calendar.setScope(.month, animated: false)
        
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal
        calendar.allowsMultipleSelection = true

        calendar.today = nil // Hide the today circle
        
        calendar.appearance.headerTitleColor = .label
        calendar.appearance.titleDefaultColor = .label
        calendar.appearance.weekdayTextColor = .gray
        
        calendar.appearance.headerTitleFont = .getFont(size: 14.0)
        calendar.appearance.titleFont = .getFont(size: 14.0)
        //calendar.appearance.subtitleFont = .getFont(size: 14.0)
        calendar.appearance.weekdayFont = .getFont(size: 14.0)
        
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
        view.addSubview(titleLabel)
        view.addSubview(cardView)
        
        cardView.addSubview(calendar)
                        
        
        let height =  UIDevice.current.model.hasPrefix("iPad") ? 400.0 : 300
        self.heightConstraint = calendar.heightAnchor.constraint(equalToConstant: height)
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            
            cardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: inset),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset),
            
            
            calendar.topAnchor.constraint(equalTo: cardView.topAnchor, constant: inset),
            calendar.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: inset),
            calendar.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -inset),
            calendar.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -inset),
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


extension RoutineDataOfMonthViewController: FSCalendarDataSource{
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        heightConstraint.constant = CGRectGetHeight(bounds);
        // Do other updates here
        view.layoutIfNeeded()
    }
    
    
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: RecordCalenderCell.reuseIdentifier, for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    
}


extension RoutineDataOfMonthViewController: FSCalendarDelegate{
    
    
    
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


private extension RoutineDataOfMonthViewController{
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
        diyCell.selectionLayer.fillColor = UIColor.primaryGreen.cgColor
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
