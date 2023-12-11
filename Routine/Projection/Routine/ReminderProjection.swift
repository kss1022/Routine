//
//  ReminderProjection.swift
//  Routine
//
//  Created by 한현규 on 12/6/23.
//

import Foundation
import Combine


final class ReminderProjection{
    
    private let reminderDao: ReminderDao
    
    private var cancellables: Set<AnyCancellable>
    
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }

        reminderDao = dbManager.reminderDao
        
        cancellables = .init()
        
        registerReceiver()
    }
    
    
    
    private func registerReceiver(){
        DomainEventPublihser.shared
            .onReceive(RoutineCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(RoutineUpdated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(RoutineDeleted.self, action: when)
            .store(in: &cancellables)
    }
    
    
    private func when(event: RoutineCreated){
        do{
            guard let reminder = event.reminder else { return }
            
            let title = event.routineName.name
            let body = event.routineDescription.description
            
            let notification = try LocalNotification.Builder()
                .setContent(
                    title: title,
                    body: body,
                    userInfo: ["routineId": event.routineId.id.uuidString]
                ).setTimeTrigger(
                    year: reminder.year,
                    month: reminder.month,
                    day: reminder.day,
                    weekDays: reminder.weekDays,
                    monthDays: reminder.monthDays,
                    hour: reminder.hour,
                    minute: reminder.minute,
                    repeats: reminder.repeat
                ).build()
            
            let reminderDto = ReminderDto(
                routineId: event.routineId.id,
                routineName: event.routineName.name,
                emoji: event.emoji.emoji,
                title: title,
                body: body,
                year: reminder.year,
                month: reminder.month,
                day: reminder.day,
                weekDays: reminder.weekDays,
                monthDays: reminder.monthDays,
                hour: reminder.hour,
                minute: reminder.minute,
                repeat: reminder.repeat
            )
            
            Task{
                do{
                    try await AppNotificationManager.shared.localAdapter.registerNotifcation(notification: notification)
                    try reminderDao.save(reminderDto)
                }catch{
                    Log.e("\(error)")
                }
            }
        }catch{
            Log.e("EventHandler Error: RoutineCreated \(error)")
        }
    }
    
    private func when(event: RoutineUpdated){
        do{
            guard let reminder = event.reminder else {
                // TODO DELETE Reminder
                try reminderDao.delete(id: event.routineId.id)
                
                Task{
                    let manager = AppNotificationManager.shared
                    let request = await manager.registereNotifications()
                    
                    let identifiers = request
                        .filter {
                            let find =  $0.content.userInfo["routineId"] as? String
                            return find == event.routineId.id.uuidString
                        }
                        .map { $0.identifier }
                    
                    await manager.localAdapter
                        .unRegisterNotifications(ids: identifiers)

                    
                }
                return
            }
            
            let title = event.routineName.name
            let body = event.routineDescription.description

            let notification = try LocalNotification.Builder()
                .setContent(
                    title: event.routineName.name,
                    body: event.routineDescription.description,
                    userInfo: ["routineId": event.routineId.id.uuidString]
                ).setTimeTrigger(
                    year: reminder.year,
                    month: reminder.month,
                    day: reminder.day,
                    weekDays: reminder.weekDays,
                    monthDays: reminder.monthDays,
                    hour: reminder.hour,
                    minute: reminder.minute,
                    repeats: reminder.repeat
                ).build()
            
            let reminderDto = ReminderDto(
                routineId: event.routineId.id,
                routineName: event.routineName.name,
                emoji: event.emoji.emoji,
                title: title,
                body: body,
                year: reminder.year,
                month: reminder.month,
                day: reminder.day,
                weekDays: reminder.weekDays,
                monthDays: reminder.monthDays,
                hour: reminder.hour,
                minute: reminder.minute,
                repeat: reminder.repeat
            )
            
            guard let remain = try reminderDao.find(id: reminderDto.routineId) else{
                //save
                Task{
                    do{
                        try await AppNotificationManager.shared.localAdapter.registerNotifcation(notification: notification)
                        try reminderDao.save(reminderDto)
                    }catch{
                        Log.e("\(error)")
                    }
                }
                return
            }
            
            
            
            //update
            Task{
                do{
                    let manager = AppNotificationManager.shared
                    let request = await manager.registereNotifications()
                    
                    let identifiers = request
                        .filter {
                            let find =  $0.content.userInfo["routineId"] as? String
                            return find == event.routineId.id.uuidString
                        }
                        .map { $0.identifier }
                    
                    await manager.localAdapter
                        .unRegisterNotifications(ids: identifiers)

                    try await manager.localAdapter.registerNotifcation(notification: notification)
                    try reminderDao.update(reminderDto)
                }catch{
                    Log.e("\(error)")
                }
            }

        }catch{
            Log.e("EventHandler Error: RoutineUpdated \(error)")
        }
    }

    
    private func when(event: RoutineDeleted){
        Task{
            let manager = AppNotificationManager.shared
            let request = await manager.registereNotifications()
            
            let identifiers = request
                .filter {
                    let find =  $0.content.userInfo["routineId"] as? String
                    return find == event.routineId.id.uuidString
                }
                .map { $0.identifier }
            
            await manager.localAdapter
                .unRegisterNotifications(ids: identifiers)
        }
    }
    
}
