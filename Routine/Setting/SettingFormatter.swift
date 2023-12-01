//
//  Formatter+Setting.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import Foundation




extension Formatter{
    static func settingReminderDateFormatter() -> DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}
