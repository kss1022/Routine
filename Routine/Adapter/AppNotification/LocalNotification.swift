//
//  LocalNotification.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation
import UserNotifications



//Adptee
struct LocalNotification{
            
    let content: UNMutableNotificationContent
    private(set) var triggers: [UUID: UNNotificationTrigger]
    
    private init(content: UNMutableNotificationContent, triggers: [UNNotificationTrigger]) {
        self.content = content
        self.triggers = .init()
        
        triggers.forEach {
            self.triggers[UUID()] = $0
        }
        
    }
    

    class Builder{
        private var content: UNMutableNotificationContent?
        private var triggers: [UNNotificationTrigger]
        
        init() {
            self.content = nil
            self.triggers = []
        }
        
        //알람 내용 구성
        func setContent(title: String, body: String, userInfo: [AnyHashable : Any] = [:]) -> Builder{
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body            
            content.sound = .default
            content.threadIdentifier = "threadIdentifier"
            content.summaryArgument = "summaryArgument"
            content.categoryIdentifier = "CategoryIdentifier"
            content.userInfo = userInfo
            self.content = content
            return self
        }    
        
        //트리거 구성
        //weekDay:3 -> Tuesday , hour:14 -> 14:00 hours
        
        
        func setTimeTrigger(
            year: Int? = nil,
            month: Int? = nil,
            day: Int? = nil,
            weekDays: Set<Int>? = nil,
            monthDays: Set<Int>? = nil,
            hour: Int,
            minute: Int,
            repeats: Bool
        ) -> Builder{
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
            dateComponents.hour = hour
            dateComponents.minute = minute
                    
            
            weekDays?.forEach {
                dateComponents.weekday = $0 + 1
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComponents, repeats: true
                )
                self.triggers.append(trigger)
            }
            
            
            monthDays?.forEach {
                dateComponents.day = $0
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComponents, repeats: true
                )
                self.triggers.append(trigger)
            }
            
            
            if let year = year,
               let month = month,
               let day = day{
                dateComponents.year = year
                dateComponents.month = month
                dateComponents.day = day
                
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComponents, repeats: repeats
                )
                self.triggers.append(trigger)
            }
            
            
            if triggers.isEmpty{
                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComponents, repeats: repeats
                )
                self.triggers.append(trigger)
            }
                                                                        
            
            return self
        }
      
        
        func  build() throws -> LocalNotification{
            if content == nil{
                throw ArgumentException("Content of  NotificationBuilder is not setting")
            }
                        
            return LocalNotification(content: content!, triggers: self.triggers)
        }
    }

    
}
