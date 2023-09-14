//
//  LogerProvider.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import CocoaLumberjackSwift


extension DDLog{
    func logFileDatas() -> [Data]{
        let ddFileLogger = DDFileLogger()
        let logFilePaths = ddFileLogger.logFileManager.sortedLogFilePaths
        var logFileDatas = [Data]()
        for logFilePath in logFilePaths {
            let fileURL = URL(fileURLWithPath: logFilePath)
            if let logFileData = try? Data(contentsOf: fileURL, options: [Data.ReadingOptions.mappedIfSafe]) {
                // Insert at front to reverse the order, so that oldest logs appear first.
                logFileDatas.insert(logFileData, at: 0)
            }
        }
        return logFileDatas
    }
}


class Log{
    static func v(_ message: String) {
        let msg = DDLogMessageFormat(stringLiteral: message)
        DDLogVerbose(msg)
    }    
    
    static func d(_ message: String) {
        let msg = DDLogMessageFormat(stringLiteral: message)
        DDLogDebug(msg)
    }
    
    static func i(_ message: String) {
        let msg = DDLogMessageFormat(stringLiteral: message)
        DDLogInfo(msg)
    }
    
    
    static func w(_ message: String) {
        let msg = DDLogMessageFormat(stringLiteral: message)
        DDLogWarn(msg)
    }
    
    static func e(_ message: String) {
        let msg = DDLogMessageFormat(stringLiteral: message)
        DDLogError(msg)
    }
    
}



