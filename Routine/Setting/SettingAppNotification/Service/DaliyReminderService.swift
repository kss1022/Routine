//
//  DaliyReminderService.swift
//  Routine
//
//  Created by 한현규 on 12/5/23.
//

import Foundation


protocol DaliyReminderService{
    var daliy: ReadOnlyCurrentValuePublisher<SettingDaliyReminderModel>{ get }
    
    func register(date: Date) async throws
    func update(isOn: Bool) async throws
    func update(date: Date) async throws
    
    func fetch()
}


final class DaliyReminderServiceImp: DaliyReminderService{
        
    private let notificationManager = AppNotificationManager.shared
    private let preferenceStorage = PreferenceStorage.shared
    
    
    var daliy: ReadOnlyCurrentValuePublisher<SettingDaliyReminderModel>{ daliySubject}
    private let daliySubject = CurrentValuePublisher(
        SettingDaliyReminderModel(
           title: "daliy_reminder".localized(tableName: "Profile"),
           imageName: "bell.square.fill",
           isOn: PreferenceStorage.shared.daliyRemidnerIsOn,
           hour: PreferenceStorage.shared.daliyReminderHour,
           minute: PreferenceStorage.shared.daliyReminderMinute
       )
    )
    
    
    private var isOn:  Bool{ preferenceStorage.daliyRemidnerIsOn }
    private var hour: Int{ preferenceStorage.daliyReminderHour }
    private var minute : Int{ preferenceStorage.daliyReminderMinute }
    
    //TODO: Localized
    func register(date: Date) async throws {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        let localNotification = try LocalNotification.Builder()
            .setContent(title: "Embrace the Start of Your Routine.", body: "A gentle reminder that it's time for your special routine. Enjoy the beginning in a relaxed manner.")
            .setTimeTrigger(hour: hour, minute: minute, repeats: true)
            .build()
        
        
        let identifier = localNotification.triggers.first!.key
        
        try await notificationManager.localAdapter.registerNotifcation(notification: localNotification)
        
        
        preferenceStorage.daliyRemidnerIsOn = true
        preferenceStorage.daliyReminderIdentifier = identifier
        preferenceStorage.daliyReminderHour = hour
        preferenceStorage.daliyReminderMinute = minute
    }
    
    func update(isOn: Bool) async throws {
        if isOn{
            try await registerDaliyReminder()
        }else{
            try await unregisterDaliyReminder()
        }
        
        fetch()
    }
    
    func update(date: Date) async throws {
        try await updateReminderTrigger(date: date)
        
        fetch()
    }
    
    func fetch() {
        let model = SettingDaliyReminderModel(
            title: "daliy_reminder".localized(tableName: "Profile"),
            imageName: "bell.square.fill",
            isOn: isOn,
            hour: hour,
            minute: minute
        )
        
        daliySubject.send(model)
    }
    
    //TODO: Localized
    private func registerDaliyReminder() async throws{
        let localNotification = try LocalNotification.Builder()
            .setContent(title: "Embrace the Start of Your Routine.", body: "A gentle reminder that it's time for your special routine. Enjoy the beginning in a relaxed manner.")
            .setTimeTrigger(hour: self.hour, minute: self.minute, repeats: true)
            .build()
                            
        
        let identifier = localNotification.triggers.first!.key
        
        try await notificationManager.localAdapter.registerNotifcation(notification: localNotification)
        

        preferenceStorage.daliyRemidnerIsOn = true
        preferenceStorage.daliyReminderIdentifier = identifier
    }

    
    private  func updateReminderTrigger(date : Date) async throws{
        try await unregisterDaliyReminder()
        try await register(date: date)
    }
    
    private func unregisterDaliyReminder() async throws{
        if let id = preferenceStorage.daliyReminderIdentifier?.uuidString{
            await notificationManager.localAdapter
                .unRegisterNotification(id: id)
            
            preferenceStorage.daliyRemidnerIsOn = false
            preferenceStorage.daliyReminderIdentifier = nil
            //preferenceStorage.daliyReminderHour = 18
            //preferenceStorage.daliyReminderMinute = 0
        }
    }
    
}


private extension PreferenceKeys {
    var daliyReminderIdentifier: PrefKey<UUID?>{ .init(name: "kDaliyReminderIdentifier", defaultValue: nil) }
    var daliyRemidnerIsOn: PrefKey<Bool>{ .init(name: "kDaliyRemidnerIsOn")} //default : false
    var daliyReminderHour: PrefKey<Int>{ .init(name: "kDaliyReminderHour", defaultValue: 18) }
    var daliyReminderMinute: PrefKey<Int>{ .init(name: "kDaliyReminderMinute", defaultValue: 0) }
}

