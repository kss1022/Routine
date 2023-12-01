//
//  SettingRoutineReminderViewModel.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import Foundation



struct SettingRoutineReminderViewModel{
    let emoji: String
    let routineName: String
    let reminderTime: String
    let reminderInfo: String
    let isOn: Bool
    let valueChanged: (Bool) -> Void
    
    
    
    init(_ model: ReminderModel, valuechanged: @escaping (Bool) -> Void) {
        self.emoji = model.emoji
        self.routineName = model.routineName
        
        let calendar = Calendar.current
        let dateComponent = DateComponents(hour: model.hour, minute: model.minute)
        let date = calendar.date(from: dateComponent) ?? Date()
        
        self.reminderTime = Formatter.settingReminderDateFormatter().string(from: date)
        
        
        if model.repeat{
            if let weekDays = model.weekDays{
                //MARK: Weekly
                
                let weekDaySimbols = Calendar.current.shortStandaloneWeekdaySymbols
                let weeklyInfo = weekDays.sorted { $0 < $1 }
                    .map{ weekDaySimbols[$0] }
                    .joined(separator: ", ")
                self.reminderInfo = "Weekly: \(weeklyInfo)"
            }else if let monthDays = model.monthDays{
                //MARK: Monthy
                let monthlyInfo =  monthDays.sorted { $0 < $1 }
                    .map(String.init)
                    .joined(separator: ", ")
                self.reminderInfo = "Monthly: \(monthlyInfo)"
            }else{
                //MARK: Daliy
                self.reminderInfo = "Daliy"
            }
        }else{
            //MARK: Do it Once
            if let year = model.year , let month = model.month , let day = model.day{
                self.reminderInfo = "\(year).\(month).\(day)"
            }else{
                Log.e("Repeat is false, but there is no day information.")
                self.reminderInfo = "?"
            }
        }
        
        
        self.isOn = true
        self.valueChanged = valuechanged
    }
}
