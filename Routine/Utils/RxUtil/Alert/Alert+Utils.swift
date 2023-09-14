//
//  Alert_Utils.swift
//  WelcomeKorea
//
//  Created by 한현규 on 2023/04/17.
//

import UIKit



//extension UIAlertController {
//    
//    // Set title font and title color
//    func setTitle(font: UIFont?, color: UIColor?) {
//        guard let title = self.title else { return }
//        let attributeString = NSMutableAttributedString(string: title)
//        
//        if let titleFont = font {
//            attributeString.addAttributes([NSAttributedString.Key.font: titleFont],
//                                          range: NSRange(location: 0, length: title.count))
//        }
//        if let titleColor = color {
//            attributeString.addAttributes([NSAttributedString.Key.foregroundColor: titleColor],
//                                          range: NSRange(location: 0, length: title.count))
//        }
//        self.setValue(attributeString, forKey: "attributedTitle")
//        
//    }
//
//    // Set message font and message color
//    func setMessage(font: UIFont?, color: UIColor?) {
//        guard let message = self.message else { return }
//        
//        let attributeString = NSMutableAttributedString(string: message)
//        if let messageFont = font {
//            attributeString.addAttributes([NSAttributedString.Key.font: messageFont],
//                                          range: NSRange(location: 0, length: message.count))
//        }
//        
//        if let messageColorColor = color {
//            attributeString.addAttributes([NSAttributedString.Key.foregroundColor: messageColorColor],
//                                          range: NSRange(location: 0, length: message.count))
//            
//        }
//        self.setValue(attributeString, forKey: "attributedMessage")
//    }
//    
//    
//    // Set tint color of UIAlertController
//    func setTint(color: UIColor) {
//        self.view.tintColor = color
//    }
//    
//    func setBackground(color : UIColor){
//        self.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = color
//    }
//}
//
