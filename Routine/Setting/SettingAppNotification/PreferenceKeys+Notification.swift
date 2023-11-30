//
//  PreferenceKeys+Notification.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import Foundation



extension PreferenceKeys {
    var setDaliyReminder: PrefKey<Bool>{ .init(name: "kSetDaliyReminder")}
    var daliyReminderDate: PrefKey<Date>{ .init(name: "kDaliyReminderDate", defaultValue: Date())}
}
