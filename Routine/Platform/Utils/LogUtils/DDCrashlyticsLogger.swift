//
//  DDCrashlyticsLogger.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import CocoaLumberjack
import FirebaseCrashlytics


class DDCrashlyticsLogger: DDAbstractLogger {
    let firebaseCrashlytics = Crashlytics.crashlytics()
 
    override func log(message logMessage: DDLogMessage) {
        if logMessage.level == .error {
            firebaseCrashlytics.log(logMessage.message)
        }
    }
}
