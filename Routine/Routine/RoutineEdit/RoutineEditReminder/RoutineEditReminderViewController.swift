//
//  RoutineEditReminderViewController.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import ModernRIBs
import UIKit

protocol RoutineEditReminderPresentableListener: AnyObject {
    func reminderToogleValueChange(isON: Bool)
    func reminderTimePickerValueChange(date: Date)
    func didBecomeActiveNotification()
}

final class RoutineEditReminderViewController: UIViewController, RoutineEditReminderPresentable, RoutineEditReminderViewControllable {

    
    weak var listener: RoutineEditReminderPresentableListener?
    
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
    
    private lazy var routineEditToogleView: RoutineEditToogleView = {
        let toogleView = RoutineEditToogleView(
            image: UIImage(systemName: "clock.fill"),
            title: "Reminder",
            subTitle: "Set a reminder"
        )
        
        toogleView.toogle.addTarget(self, action: #selector(reminderToogleValueChange(sender:)), for: .valueChanged)
        return toogleView
    }()
         
    
    private lazy var timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)

        return datePicker
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

        view.addSubview(stackView)
        
        stackView.addArrangedSubview(routineEditToogleView)
        
        let inset: CGFloat = 8.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    
    // MARK: Presentable
    
    func setToogleEnable(enable: Bool) {
        routineEditToogleView.setToogleEnable(enable)
    }
    
    func setToogle(on: Bool) {
        routineEditToogleView.setToogle(on)
    }
    
    func setDate(date: Date) {
        timePicker.setDate(date, animated: false)
    }
    
    
    func showTimePikcer() {
        stackView.addArrangedSubview(timePicker)
    }
    
    func hideTimePicker() {
        timePicker.removeFromSuperview()
    }
    
    func setSubTitle(subTitle: String) {
        routineEditToogleView.setSubTitle(subTitle)
    }
    
    // MARK: Handle Toogle(Switch)
    @objc 
    private func reminderToogleValueChange(sender: UISwitch) {
        listener?.reminderToogleValueChange(isON: sender.isOn)
    }
    
    
    // MARK: Handle SegmentControl
    @objc
    private func timePickerValueChanged(_ sender: UIDatePicker) {
        self.listener?.reminderTimePickerValueChange(date: sender.date)
    }
    
    
    
    @objc private func didBecomeActive() {
        listener?.didBecomeActiveNotification()
    }
    

}
