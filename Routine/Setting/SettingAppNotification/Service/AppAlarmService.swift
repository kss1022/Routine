//
//  AppAlarmService.swift
//  Routine
//
//  Created by 한현규 on 12/7/23.
//

import Foundation



protocol AppAlarmService{
    var alarm: ReadOnlyCurrentValuePublisher<SettingAlarmModel>{ get }
    
    
    func fetch()
    func update(isOn: Bool)
}

final class AppAlarmServiceImp: AppAlarmService{
    
    private let notificationManager = AppNotificationManager.shared
    private let preferenceStorage = PreferenceStorage.shared
    
    
    
    var alarm: ReadOnlyCurrentValuePublisher<SettingAlarmModel>{ alarmSubject }
    private let alarmSubject = CurrentValuePublisher<SettingAlarmModel>(
        SettingAlarmModel(
            title: "alarm".localized(tableName: "Profile"),
            imageName: "app.badge",
            isOn: PreferenceStorage.shared.appAlarmIsOn
        )
    )
    
    var isOn: Bool{
        preferenceStorage.appAlarmIsOn
    }
    
    
    func fetch() {
        let model =  SettingAlarmModel(
            title: "alarm".localized(tableName: "Profile"),
            imageName: "app.badge",
            isOn: isOn
        )
        
        alarmSubject.send(model)
    }

    
    func update(isOn: Bool) {
        preferenceStorage.appAlarmIsOn = isOn
        fetch()
    }
    
    
}


private extension PreferenceKeys{
    var appAlarmIsOn: PrefKey<Bool>{ .init(name: "appAlarmIsOn", defaultValue: true)}
}
