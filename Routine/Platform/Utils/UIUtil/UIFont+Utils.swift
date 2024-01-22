//
//  UIFont+Utils.swift
//  WelcomeKorea
//
//  Created by 한현규 on 2023/01/31.
//

import UIKit

//TODO: Handling CustomFontSize & Updates the fonts of the added view.

public extension UIFont {
        
    //MARK: Public
    static var appFontName = "AppleSDGothicNeo-Regular"
    static var appBoldFontName = "AppleSDGothicNeo-Bold"
    static var isDynamicFont = true
    static var appFontSize = 0.0
}


//MARK: Setter
extension UIFont{
    
    public static func setFont(fontName: String, boldFontName: String, isDynamicFont: Bool, fontSize: CGFloat){
        UIFont.appFontName = fontName
        UIFont.appBoldFontName = boldFontName
        UIFont.isDynamicFont = isDynamicFont
        UIFont.appFontSize = fontSize
        
        
        UIFont.fontDic = UIFont.fontDic(fontName: UIFont.appFontName, fontSize: UIFont.appFontSize)
        UIFont.boldFontDic = UIFont.fontDic(fontName: UIFont.appBoldFontName, fontSize: UIFont.appFontSize)
    }
    
    public static func setFont(fontName: String, boldFontName: String){
        UIFont.appFontName = fontName
        UIFont.fontDic = UIFont.fontDic(fontName: UIFont.appFontName, fontSize: UIFont.appFontSize)
        
        UIFont.appBoldFontName = boldFontName
        UIFont.boldFontDic = UIFont.fontDic(fontName: UIFont.appBoldFontName, fontSize: UIFont.appFontSize)
    }
    
    public static func setIsDynamicFont(isDynamicFont: Bool){        
        UIFont.isDynamicFont = isDynamicFont
    }
        
    
    public static func setFontSize(fontSize: CGFloat){
        UIFont.appFontSize = fontSize
        
        UIFont.fontDic = UIFont.fontDic(fontName: UIFont.appFontName, fontSize: UIFont.appFontSize)
        UIFont.boldFontDic = UIFont.fontDic(fontName: UIFont.appBoldFontName, fontSize: UIFont.appFontSize)
    }
}

//MARK: Getter
extension UIFont{
    public static func getFont(style : UIFont.TextStyle) -> UIFont{
        let fontDic : [UIFont.TextStyle : UIFont] = UIFont.myCustomFontDic()
        if let font = fontDic[style] {
            if !isDynamicFont{
                return font
            }

            return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        }else{
            return UIFont.preferredFont(forTextStyle: style)
        }
    }
    
    public static func getFont(size: CGFloat) -> UIFont{
        UIFont(name: appFontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    public static func getBoldFont(style : UIFont.TextStyle) -> UIFont{
        let fontDic : [UIFont.TextStyle : UIFont] = UIFont.myCustomFontBoldDic()
        
        if let font = fontDic[style] {
            if !isDynamicFont{
                return font
            }

            return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        }else{
            return UIFont.preferredFont(forTextStyle: style)
        }
    }
    
    public static func getBoldFont(size: CGFloat) -> UIFont{
        UIFont(name: appBoldFontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
}


//MARK: Font dic
extension UIFont{
    //MARK: Private
    private static var fontDic : [UIFont.TextStyle : UIFont] = {
        fontDic(fontName: appFontName, fontSize: appFontSize)
    }()
    
    private static var boldFontDic : [UIFont.TextStyle : UIFont] = {
        fontDic(fontName: appBoldFontName, fontSize: appFontSize)
    }()
        
    private static func fontDic(fontName: String, fontSize: CGFloat) -> [UIFont.TextStyle : UIFont]{
        var dic = [UIFont.TextStyle : UIFont]()
                        
        dic[.largeTitle] = UIFont(name: fontName, size: 34.0 + fontSize)
        dic[.title1] = UIFont(name: fontName, size: 28.0 + fontSize)
        dic[.title2] = UIFont(name: fontName, size: 22.0 + fontSize)
        dic[.title3] = UIFont(name: fontName, size: 20.0 + fontSize)
        dic[.headline] = UIFont(name: fontName, size: 17.0 + fontSize)
        dic[.body] = UIFont(name: fontName, size: 17.0 + fontSize)
        dic[.callout] = UIFont(name: fontName, size: 16.0 + fontSize)
        dic[.subheadline] = UIFont(name: fontName, size: 15.0 + fontSize)
        dic[.footnote] = UIFont(name: fontName, size: 13.0 + fontSize)
        dic[.caption1] = UIFont(name: fontName, size: 12.0 + fontSize)
        dic[.caption2] = UIFont(name: fontName, size: 11.0 + fontSize)
        return dic
    }
    
    
    private static func myCustomFontDic() -> [UIFont.TextStyle : UIFont]{
        return UIFont.fontDic
    }
    
    private static func myCustomFontBoldDic() -> [UIFont.TextStyle : UIFont]{
        return UIFont.boldFontDic
    }
}

//MARK: Set font
extension UILabel {
    public func setFont(style : UIFont.TextStyle){
        self.font = UIFont.getFont(style: style)
        self.adjustsFontForContentSizeCategory = true
    }
    
    public func setBoldFont(style : UIFont.TextStyle){
        self.font = UIFont.getBoldFont(style: style)
        self.adjustsFontForContentSizeCategory = true
    }
}

extension UITextField {
    public func setFont(style : UIFont.TextStyle  ){
        self.font = UIFont.getFont(style: style)
        self.adjustsFontForContentSizeCategory = true
    }
    
    public func setBoldFont(style : UIFont.TextStyle  ){
        self.font = UIFont.getBoldFont(style: style)
        self.adjustsFontForContentSizeCategory = true
    }
}

extension UITextView {
    public func setFont(style : UIFont.TextStyle ){
        self.font = UIFont.getFont(style: style)
        self.adjustsFontForContentSizeCategory = true
    }

    public func setBoldFont(style : UIFont.TextStyle  ){
        self.font = UIFont.getBoldFont(style: style)
        self.adjustsFontForContentSizeCategory = true
    }
}



extension UIButton{
    public func setFont(style : UIFont.TextStyle ){
        self.titleLabel?.font = UIFont.getFont(style: style)
        self.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    public func setBoldFont(style : UIFont.TextStyle ){
        self.titleLabel?.font = UIFont.getBoldFont(style: style)
        self.titleLabel?.adjustsFontForContentSizeCategory = true
    }
}
