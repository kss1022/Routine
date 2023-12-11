//
//  TopAcheiveFormatter.swift
//  Routine
//
//  Created by 한현규 on 12/7/23.
//

import Foundation


extension Formatter{
    static func topAcheiveFormatter() -> DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.M.d"
        return formatter
    }
}
