//
//  SettingAppNotificationViewController.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import ModernRIBs
import UIKit

protocol SettingAppNotificationPresentableListener: AnyObject {
    func didMove()
    
    func alarmToogleValueChanged(isOn: Bool)
        
    func daliyReminderToolgeValueChanged(isOn: Bool)
    func daliyReminderDateValueChanged(date : Date)
    func daliyReminderDidTap()
    
    func routineReminderToogleValueChanged(isOn: Bool, routineId: UUID)
}

final class SettingAppNotificationViewController: UIViewController, SettingAppNotificationPresentable, SettingAppNotificationViewControllable {
    
    
    weak var listener: SettingAppNotificationPresentableListener?
    
    var alarm: SettingAlarmViewModel?
    var daliyReminder: SettingDaliyReminderViewModel?
    var routineReminders = [SettingRoutineReminderViewModel]()
    
    var isDaliyRemindeDatePickerShow = false
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(cellType: SettingAppNotificationToogleCell.self)
        tableView.register(cellType: SettingAppNotificationDatePickerCell.self)
        tableView.register(cellType: SettingRoutineReminderCell.self)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
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
        //title = "Setting Alarm"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if parent == nil{
            listener?.didMove()
        }
    }

 
    func setAlarm(_ viewModel: SettingAlarmViewModel) {            
        if let alarm = self.alarm{
            if alarm.isOn && !viewModel.isOn{
                self.alarm = viewModel
                tableView.deleteSections([1, 2], with: .none)
            }else if !alarm.isOn && viewModel.isOn{
                self.alarm = viewModel
                tableView.insertSections([1, 2], with: .none)
            }else{
                self.alarm = viewModel
                tableView.reloadSections([0], with: .none)
            }                        
        }else{
            self.alarm = viewModel
            tableView.reloadData()
            //tableView.reloadSections([0], with: .none)
        }
        
        
    }
    
    func setDaliyReminder(_ viewModel: SettingDaliyReminderViewModel) {
        if self.daliyReminder == nil{
            self.daliyReminder = viewModel
            
            if (self.alarm?.isOn ?? false){
                tableView.reloadSections([1], with: .none)
            }
            
            return
        }
        
        self.daliyReminder = viewModel
        
        if (self.alarm?.isOn ?? false){
            tableView.reloadRows(at: [.init(row: 0, section: 1)], with: .none)
        }
    }
    
    
    func setRoutineReminders(_ viewModels: [SettingRoutineReminderViewModel]) {
        self.routineReminders = viewModels
        
        if (self.alarm?.isOn ?? false){
            tableView.reloadSections([2], with: .none)
        }        
    }
    

    
    func showDaliyReminderDatePicker() {
        isDaliyRemindeDatePickerShow = true
        self.tableView.insertRows(at: [.init(row: 1, section: 1)], with: .middle)
    }
    
    func hideDaliyReminderDatePicker() {
        isDaliyRemindeDatePickerShow = false
        self.tableView.deleteRows(at: [.init(row: 1, section: 1)], with: .middle)
    }
}

extension SettingAppNotificationViewController: UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let alarm = self.alarm else { return 0 }
        
        if !alarm.isOn{
            return 1
        }
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            //MARK: ONFF
            return 1
        case 1:
            //MARK: DALIY REMINDER
            if isDaliyRemindeDatePickerShow{
                return 2
            }else{
                return 1
            }
        case 2:
            //MARK: ROUTINE REMINDER
            return routineReminders.count
        default : fatalError("Invalid IndexPath.row")
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        
        switch section{
        case 0 :            
            //MARK: ONFF
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingAppNotificationToogleCell.self)
            if let alarm = alarm{
                cell.bindView(alarm)
            }
            
            cell.valueChanged = { [weak self] isOn in
                self?.listener?.alarmToogleValueChanged(isOn: isOn)
            }
            return cell
        case 1:
            //MARK: DALIY REMINDER
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingAppNotificationToogleCell.self)
                
                if let daliyReminder = daliyReminder{
                    cell.bindView(daliyReminder)
                }
                
                cell.valueChanged = { [weak self] isOn in
                    self?.listener?.daliyReminderToolgeValueChanged(isOn: isOn)
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingAppNotificationDatePickerCell.self)
                if let daliyReminder = daliyReminder{
                    cell.bindView(daliyReminder)
                }
                
                cell.valueChanged = { [weak self] date in
                    self?.listener?.daliyReminderDateValueChanged(date: date)
                }
                return cell
            }
        case 2:
            //MARK: ROUTINE REMINDER
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SettingRoutineReminderCell.self)
            let reminder = routineReminders[indexPath.row]
            cell.bindView(reminder)
            cell.valueChanged = { [weak self] isOn in
                self?.listener?.routineReminderToogleValueChanged(isOn: isOn, routineId: reminder.id)
            }
            return cell
        default : fatalError("Invalid IndexPath.row")
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "UITableViewHeaderFooterView") else{
            fatalError("Failed to dequeue reusable cell")
        }
                
        var content = headerView.defaultContentConfiguration()
        
        
        switch section{
        case 0 : 
            //MARK: ONFF
            content.text = "onOff".localized(tableName: "Profile")
        case 1:
            //MARK: DALIY REMINDER
            content.text = "daliy_reminder".localized(tableName: "Profile")
        case 2:
            //MARK: ROUTINE REMINDER            
            if routineReminders.count == 0{
                return nil
            }
            
            content.text = "routine_reminder".localized(tableName: "Profile")
        default : fatalError("Invalid section")
        }
        
        content.textProperties.font = .getFont(style: .caption1)
        headerView.contentConfiguration = content
        
        return headerView
    }

}


extension SettingAppNotificationViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Change from gray again when choosing a cell
        
        //Reminder Tap!
        if indexPath.section == 1 && indexPath.row == 0{
            listener?.daliyReminderDidTap()
        }
        
    }

}
