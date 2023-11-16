//
//  AppMailManager.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import Foundation
import MessageUI



final class AppMailManager: NSObject{
    
    public static let share = AppMailManager()
    
    func canSendMail() -> Bool{
        MFMailComposeViewController.canSendMail()
    }

}
