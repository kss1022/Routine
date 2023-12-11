//
//  RoutineReminderService.swift
//  Routine
//
//  Created by 한현규 on 12/5/23.
//

import Foundation


protocol RoutineReminderService{
    var routineIds: Set<String>{ get async }
    func on(model: ReminderModel) async throws
    func off(routineId: UUID) async
}

final class RoutineReminderServiceImp: RoutineReminderService{
    
    
    
    private let notificationManager = AppNotificationManager.shared

    
    var routineIds: Set<String>{
        get async {
            let request = await notificationManager.registereNotifications()
            let routineIds = request
                .compactMap { $0.content.userInfo["routineId"] as? String }
            return Set(routineIds)
        }
    }
            
    
    func on(model: ReminderModel) async throws {
        let notification = try LocalNotification.Builder()
            .setContent(
                title: model.title,
                body: model.body,
                userInfo: ["routineId": model.routineId.uuidString]
            ).setTimeTrigger(
                year: model.year,
                month: model.month,
                day: model.day,
                weekDays: model.weekDays,
                monthDays: model.monthDays,
                hour: model.hour,
                minute: model.minute,
                repeats: model.repeat
            ).build()
                                                        
        try await notificationManager.localAdapter.registerNotifcation(notification: notification)
    }
    
    func off(routineId: UUID) async {
        
        let request = await notificationManager.registereNotifications()
        
        let identifiers = request
            .filter {
                let find =  $0.content.userInfo["routineId"] as? String
                return find == routineId.uuidString
            }
            .map { $0.identifier }
        
        await notificationManager.localAdapter
            .unRegisterNotifications(ids: identifiers)
    }

    
    
}
