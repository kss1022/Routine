//
//  RoutineProjection.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation
import Combine


final class RoutineProjection{
    
    
    private let routineListDao: RoutineListDao
    private let routineDetailDao: RoutineDetailDao
    private let repeatDao: RepeatDao
    private let reminderDao: ReminderDao
    
    private var cancellables: Set<AnyCancellable>
    
    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        routineListDao = dbManager.routineListDao
        routineDetailDao = dbManager.routineDetailDao
        repeatDao = dbManager.repeatDao
        reminderDao = dbManager.reminderDao
        
        cancellables = .init()
        
        registerReciver()
    }
    
    
    
    func registerReciver(){
        DomainEventPublihser.share
            .onReceive(RoutineCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.share
            .onReceive(RoutineUpdated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.share
            .onReceive(RoutineNameChanged.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.share
            .onReceive(RoutineDeleted.self, action: when)
            .store(in: &cancellables)
    }
    
    
    func when(event: RoutineCreated){
        do{
            let routineList = RoutineListDto(
                routineId: event.routineId.id,
                routineName: event.routineName.name,
                routineDescription: event.routineDescription.description,
                repeatType: RepeatTypeDto(event.repeat.repeatType),
                repeatValue: RepeatValueDto(event.repeat.repeatValue),
                emojiIcon: event.emoji.emoji,
                tint: event.tint.color,
                sequence: 0
            )
            
            let routineDetail = RoutineDetailDto(
                routineId: event.routineId.id,
                routineName: event.routineName.name,
                routineDescription: event.routineDescription.description,
                repeatType: RepeatTypeDto(event.repeat.repeatType),
                repeatValue: RepeatValueDto(event.repeat.repeatValue),
                reminderIsOn: event.reminder != nil,
                reminderHour: event.reminder?.hour,
                reminderMinute: event.reminder?.minute,
                emojiIcon: event.emoji.emoji,
                tint: event.tint.color,
                updatedAt: event.occurredOn
            )
            
            let `repeat` = RepeatDto(
                routineId: event.routineId.id,
                repeatType: RepeatTypeDto(event.repeat.repeatType),
                repeatValue: RepeatValueDto(event.repeat.repeatValue)
            )
            
            
            
            try routineListDao.save(routineList)
            try routineDetailDao.save(routineDetail)
            try repeatDao.save(`repeat`)
            
            try handleReminder(event: event)
        }catch{
            Log.e("EventHandler Error: RoutineCreated \(error)")
        }
    }
    
    func when(event: RoutineUpdated){
        do{
            let routineList = RoutineListDto(
                routineId: event.routineId.id,
                routineName: event.routineName.name,
                routineDescription: event.routineDescription.description,
                repeatType: RepeatTypeDto(event.repeat.repeatType),
                repeatValue: RepeatValueDto(event.repeat.repeatValue),
                emojiIcon: event.emoji.emoji,
                tint: event.tint.color,
                sequence: 0
            )
            
            let routineDetail = RoutineDetailDto(
                routineId: event.routineId.id,
                routineName: event.routineName.name,
                routineDescription: event.routineDescription.description,
                repeatType: RepeatTypeDto(event.repeat.repeatType),
                repeatValue: RepeatValueDto(event.repeat.repeatValue),
                reminderIsOn: event.reminder != nil,
                reminderHour: event.reminder?.hour,
                reminderMinute: event.reminder?.minute,
                emojiIcon: event.emoji.emoji,
                tint: event.tint.color,
                updatedAt: event.occurredOn
            )
            
            try routineListDao.update(routineList)
            try routineDetailDao.update(routineDetail)
            try handleReminder(event: event)
        }catch{
            Log.e("EventHandler Error: RoutineUpdated \(error)")
        }
    }
    
    
    func when(event: RoutineNameChanged){
        do{
            let routineId = event.routineId.id
            let changedName = event.routineName.name
            
            try routineListDao.updateName(routineId, name: changedName)
            try routineDetailDao.updateName(routineId, name: changedName)
        }catch{
            Log.e("EventHandler Error: RoutineNameChanged \(error)")
        }
    }
    
    func when(event: RoutineDeleted){
        do{
            let routineId = event.routineId.id
            try routineListDao.delete(routineId)
            try routineDetailDao.delete(routineId)
        }catch{
            Log.e("EventHandler Error: RoutineDeleted \(error)")
        }
    }
    
    
    private func handleReminder(event: RoutineCreated) throws{
        guard let reminder = event.reminder else { return }
        
        let notification = try LocalNotification.Builder()
            .setContent(
                title: event.routineName.name,
                body: event.routineDescription.description
            ).setTimeTrigger(
                year: reminder.year,
                month: reminder.month,
                day: reminder.day,
                weekDays: reminder.weekDays,
                monthDays: reminder.monthDays,
                hour: reminder.hour,
                minute: reminder.minute,
                repeats: (reminder.year != nil) && (reminder.month != nil) && (reminder.day != nil)
            ).build()
        
        let reminderDto = ReminderDto(
            routineId: event.routineId.id,
            identifiers: notification.triggers.map{ $0.key.uuidString },
            hour: reminder.hour,
            minute: reminder.minute
        )
        
        Task{
            do{
                try await AppNotificationManager.share.localAdapter.registerNotifcation(notification: notification)
                try reminderDao.save(reminderDto)
            }catch{
                Log.e("\(error)")
            }
        }
    }
    
    private func handleReminder(event: RoutineUpdated) throws{
        guard let reminder = event.reminder else { return }
        
        let notification = try LocalNotification.Builder()
            .setContent(
                title: event.routineName.name,
                body: event.routineDescription.description
            ).setTimeTrigger(
                year: reminder.year,
                month: reminder.month,
                day: reminder.day,
                weekDays: reminder.weekDays,
                monthDays: reminder.monthDays,
                hour: reminder.hour,
                minute: reminder.minute,
                repeats: (reminder.year != nil) && (reminder.month != nil) && (reminder.day != nil)
            ).build()
        
        let reminderDto = ReminderDto(
            routineId: event.routineId.id,
            identifiers: notification.triggers.map{ $0.key.uuidString },
            hour: reminder.hour,
            minute: reminder.minute
        )
        
        guard let remain = try reminderDao.find(id: reminderDto.routineId) else{
            //save
            Task{
                do{
                    try await AppNotificationManager.share.localAdapter.registerNotifcation(notification: notification)
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
//                for identifire in remain.getIdentifires(){
//                    await AppNotificationManager.share().localAdapter.unRegisterNotification(id: identifire)
//                }
                await AppNotificationManager.share.localAdapter.unRegisterNotifications(ids: remain.getIdentifires())
                try await AppNotificationManager.share.localAdapter.registerNotifcation(notification: notification)
                try reminderDao.update(reminderDto)
            }catch{
                Log.e("\(error)")
            }
        }
    }
    
    
}
