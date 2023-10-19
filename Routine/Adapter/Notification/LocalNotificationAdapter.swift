//
//  LocalNotificationAdapter.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation
import UserNotifications




//Adapter
final class LocalNotificationAdapter: AppNotification{
    
    private let center: UNUserNotificationCenter
    
    init(center: UNUserNotificationCenter) {
        self.center = center
    }

    
    // MARK: Register
    func registerNotifcation(notification: LocalNotification) async throws{
        let requests = notification.triggers.map {
            UNNotificationRequest(
                identifier: $0.key.uuidString,
                content: notification.content,
                trigger: $0.value
            )
        }
        
        
        for request in requests {
            try await center.add(request)
        }
        
        await checkRequest()
    }
    
    
    
    
    // MARK: unRegister
    func unRegisterNotification(id: String) async{
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()                
        requests.filter { $0.identifier == id }
            .forEach { request in
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
            }
        Log.v("unRegisterNotification")
        
        await checkRequest()
    }
    
    func unRegisterNotifications(ids: [String]) async {
        ids.forEach {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [$0])
        }
        Log.v("unRegisterNotifications")
        await checkRequest()
    }
    
    private func checkRequest() async{
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        Log.v("Register Requests count: \(requests.count)")
    }

}
