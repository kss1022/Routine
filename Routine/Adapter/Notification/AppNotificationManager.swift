//
//  AppNotificationManager.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation
import UserNotifications


protocol AppNotification{
    func registerNotifcation(notification: LocalNotification) async throws
    func unRegisterNotification(id: String) async
    func unRegisterNotifications(ids: [String]) async
}



final class AppNotificationManager{
    
    public static let share = AppNotificationManager()
        
    private let center = UNUserNotificationCenter.current()
    public let localAdapter: LocalNotificationAdapter
    
            
    private init()  {
        localAdapter = LocalNotificationAdapter(center: center)
        
#if DEBUG
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
#endif
    }
    
    
    func setupNotification() async throws -> Bool {
        let granted = try await requestPermission()
        setRoutineAction()
        Log.v("Notification Center Perssion: \(granted)")
        return granted
    }
    
    func checkNotificationStatus() async -> Bool{
        let setttings = await UNUserNotificationCenter.current().notificationSettings()
        let isGranted = setttings.authorizationStatus == .authorized
                
        Log.v("UNAuthorizationStatus is \(setttings.authorizationStatus)")
        return isGranted
    }
    
    
    // MARK: Permission
    private func requestPermission() async throws -> Bool{
        Log.d("requestPermission (If Not Exists): Notification Permission")
        
        return try await center.requestAuthorization(options: [.alert, .badge, .sound, .providesAppNotificationSettings]) //.provisional -> not sound...
//        return try await center.requestAuthorization(options: [.alert, .badge, .sound, .provisional, .providesAppNotificationSettings, ]) //.provisional -> not sound...
    }
    
    private func getNoticationSetting() async{
        let settings = await center.notificationSettings()
        
        guard (settings.authorizationStatus == .authorized) ||
                  (settings.authorizationStatus == .provisional) else { return }
        
        
        if settings.alertSetting == .enabled {
            // Schedule an alert-only notification.
        } else {
            // Schedule a notification with a badge and sound.
        }
    }
    
    private func setRoutineAction(){
        let action1 = UNNotificationAction(identifier: "Action1Identifier", title: "Action 1", options: [])
        let action2 = UNNotificationAction(identifier: "Action2Identifier", title: "Action 2", options: [])
        
        let category = UNNotificationCategory(
            identifier: "CategoryIdentifier",
            actions: [action1, action2],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: .customDismissAction
        )
        
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([category])
    }


}
