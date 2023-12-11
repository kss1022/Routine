//
//  AppMailManager.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import Foundation
import MessageUI



final class AppMailManager: NSObject{
    
    public static let shared = AppMailManager()
    
    private override init(){}
    
    func canSendMail() -> Bool{
        MFMailComposeViewController.canSendMail()
    }

}
