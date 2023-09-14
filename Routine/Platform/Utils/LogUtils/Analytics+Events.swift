//
//  Analytics+Events.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import Firebase


extension Analytics{


    enum AppEvent : String{
        //MARK: - Server
        case testServerError = "TestServerError"

        //MARK: - Local
        case testLocalError = "TestLocalError"

        //MARK: - Notification
        case notificationRegisterSuccess = "notificationRegisterSuccess"
        case notificationRegisterFail = "notificationRegisterFail"
    }


    static func logEvent(_ event : AppEvent , pareteters : [String: Any]? = nil){
        Analytics.logEvent(event.rawValue, parameters: pareteters)
    }

}
