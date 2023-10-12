//
//  AttributedString+Utils.swift
//  WelcomeKorea
//
//  Created by 한현규 on 2023/04/17.
//

import UIKit



public extension String{
    
    func getColorAttributeString ( attributeText : String, attributeFont : UIFont , attributeColor : UIColor) -> NSMutableAttributedString{
        let attributeString = NSMutableAttributedString(string: self)
        // NSMutableAttributedString에 속성을 추가합니다.
        let addtionalAttributes : [NSAttributedString.Key : Any] = [
            .foregroundColor : attributeColor,
            .font : attributeFont
        ]
        
        attributeString.addAttributes(addtionalAttributes, range: (self as NSString).range(of: attributeText))
        return attributeString
    }
    
    func getAttributeImageString( image : UIImage , bounds : CGRect? = nil, font : UIFont? = nil ) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: "" )
        let imageAttachment = NSTextAttachment(image: image)
        
        if let bounds = bounds{
            imageAttachment.bounds = bounds
        }else if let font = font{            
            let y =  round( font.capHeight - CGFloat( image.size.height)) / 2.0
            imageAttachment.bounds = CGRectMake(0, y, image.size.width, image.size.height)
        }
        
        attributedString.append(NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: " \(self)"))
        return attributedString
    }
    
    func getAttributeSting() -> NSAttributedString{
        NSAttributedString(string: self)
    }
    
    func getAttributeStrkeString() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
