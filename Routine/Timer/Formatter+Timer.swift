//
//  Formatter+Timer.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import Foundation



extension Formatter{
    static func timeFormatter() -> DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
}
