//
//  ReminderDateFormatter.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation




extension Formatter{
    
    static func reminderDateFormatter() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a" // 시간을 표시할 형식을 설정
        return dateFormatter
    }
    
}
