//
//  Alert.swift
//  WelcomeKorea
//
//  Created by 한현규 on 2023/04/17.
//

//import Foundation
//
//import UIKit
//
//
//struct Alert{
//    let title : String?
//    let message : String?
//    let actions : [AlertAction]
//    let style : UIAlertController.Style
//    
//    
//    init( title : String? , message: String? , actions : [AlertAction] = [AlertAction(title: "confirm".localized())], style : UIAlertController.Style = .alert) {
//        self.title = title
//        self.message = message
//        self.actions = actions
//        self.style = style
//    }
//}
//
//
//
//// MARK : - Simple String Alert
//extension Observable<String>{
//    
//    func asAlert() -> Observable<Alert>{
//        self.map { message -> Alert in
//            return Alert(title: nil, message: message)
//        }
//    }
//}
