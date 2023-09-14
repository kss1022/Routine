//
//  RoutineLogFormatter.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import CocoaLumberjack

class RoutineLogFormatter: NSObject, DDLogFormatter {
    
    var loggerCount: Int
    let dateFormatter: DateFormatter
    
    override init() {
        loggerCount = 0
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        super.init()
    }
        
    func format(message logMessage: DDLogMessage) -> String? {
        let timestamp = dateFormatter.string(from: logMessage.timestamp)
        
        let logLevel : NSString
        switch logMessage.flag{
            case .debug : logLevel = "[D]"
            case .info : logLevel = "[I]"
            case .warning : logLevel = "[W]"
            case .error : logLevel = "[E]"
            default : logLevel = "[V]"
        }
        
        //return logText
        
        return "\(logLevel) \(timestamp) | \(logMessage.message)"
    }
    
    func didAdd(to logger: DDLogger) {
        loggerCount += 1
                
        assert(loggerCount <= 1, "This logger isn't thread-safe")
    }
    
    func willRemove(from logger: DDLogger) {
        loggerCount -= 1
    }
}
