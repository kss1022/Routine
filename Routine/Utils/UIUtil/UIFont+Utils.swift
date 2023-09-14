//
//  UIFont+Utils.swift
//  WelcomeKorea
//
//  Created by 한현규 on 2023/01/31.
//

import UIKit



public extension UILabel {
    
    func setFont(style : UIFont.TextStyle){
        self.font = UIFont.getFont(style: style)
        self.adjustsFontForContentSizeCategory = true
    }
    
    func setBoldFont(style : UIFont.TextStyle){
        self.font = UIFont.getBoldFont(style: style)
        self.adjustsFontForContentSizeCategory = true
    }


}

public extension UITextField {
    func setFont(style : UIFont.TextStyle  ){
        self.font = UIFont.getFont(style: style)
        self.adjustsFontForContentSizeCategory = true
    }
    
    func setBoldFont(style : UIFont.TextStyle  ){
        self.font = UIFont.getBoldFont(style: style)
        self.adjustsFontForContentSizeCategory = true
    }

}

public extension UITextView {
    func setFont(style : UIFont.TextStyle ){
        self.font = UIFont.getFont(style: style)
        self.adjustsFontForContentSizeCategory = true
    }

    func setBoldFont(style : UIFont.TextStyle  ){
        self.font = UIFont.getBoldFont(style: style)
        self.adjustsFontForContentSizeCategory = true
    }
}



public extension UIButton{
    func setFont(style : UIFont.TextStyle ){
        self.titleLabel?.font = UIFont.getFont(style: style)
        self.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    func setBoldFont(style : UIFont.TextStyle ){
        self.titleLabel?.font = UIFont.getBoldFont(style: style)
        self.titleLabel?.adjustsFontForContentSizeCategory = true
    }
}
    


public extension UIFont {
    
    static let fontName = "AppleSDGothicNeo-Regular"
    static let boldFontName = "AppleSDGothicNeo-Bold"
    
    static let fontDic : [UIFont.TextStyle : UIFont] = {
        var dic = [UIFont.TextStyle : UIFont]()
        dic[.largeTitle] = UIFont(name: fontName, size: 34.0)
        dic[.title1] = UIFont(name: fontName, size: 28.0)
        dic[.title2] = UIFont(name: fontName, size: 22.0)
        dic[.title3] = UIFont(name: fontName, size: 20.0)
        dic[.headline] = UIFont(name: fontName, size: 17.0)
        dic[.body] = UIFont(name: fontName, size: 17.0)
        dic[.callout] = UIFont(name: fontName, size: 16.0)
        dic[.subheadline] = UIFont(name: fontName, size: 15.0)
        dic[.footnote] = UIFont(name: fontName, size: 13.0)
        dic[.caption1] = UIFont(name: fontName, size: 12.0)
        dic[.caption2] = UIFont(name: fontName, size: 11.0)
        return dic
    }()
    
    static let boldFontDic : [UIFont.TextStyle : UIFont] = {
        var dic = [UIFont.TextStyle : UIFont]()
        dic[.largeTitle] = UIFont(name: boldFontName, size: 34.0)
        dic[.title1] = UIFont(name: boldFontName, size: 28.0)
        dic[.title2] = UIFont(name: boldFontName, size: 22.0)
        dic[.title3] = UIFont(name: boldFontName, size: 20.0)
        dic[.headline] = UIFont(name: boldFontName, size: 17.0)
        dic[.body] = UIFont(name: boldFontName, size: 17.0)
        dic[.callout] = UIFont(name: boldFontName, size: 16.0)
        dic[.subheadline] = UIFont(name: boldFontName, size: 15.0)
        dic[.footnote] = UIFont(name: boldFontName, size: 13.0)
        dic[.caption1] = UIFont(name: boldFontName, size: 12.0)
        dic[.caption2] = UIFont(name: boldFontName, size: 11.0)
        return dic
    }()
    
    
    static func myCustomFontDic() -> [UIFont.TextStyle : UIFont]{
        return UIFont.fontDic
    }
    
    static func myCustomFontBoldDic() -> [UIFont.TextStyle : UIFont]{
        return UIFont.boldFontDic
    }
    
    
    //todo self.adjustsFontForContentSizeCategory = true
    static func getFont(style : UIFont.TextStyle) -> UIFont{
        let fontDic : [UIFont.TextStyle : UIFont] = UIFont.myCustomFontDic()
        
        if let font = fontDic[style] {
            return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        }else{
            return UIFont.preferredFont(forTextStyle: style)
        }
    }
    
    static func getBoldFont(style : UIFont.TextStyle) -> UIFont{
        let fontDic : [UIFont.TextStyle : UIFont] = UIFont.myCustomFontBoldDic()
        
        if let font = fontDic[style] {
            return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        }else{
            return UIFont.preferredFont(forTextStyle: style)
        }
    }
    
    static func checkFontName(){
        for family in UIFont.familyNames {
            
            let sName: String = family as String
            print("family: \(sName)")
            
            for name in UIFont.fontNames(forFamilyName: sName) {
                print("name: \(name as String)")
            }
        }
    }
    
}
