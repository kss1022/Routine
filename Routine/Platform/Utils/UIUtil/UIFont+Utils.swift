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
    static var appFontName = "Bradley Hand" //"AppleSDGothicNeo-Regular"
    static var appBoldFontName = "Bradley Hand" //"AppleSDGothicNeo-Bold"
    
    static func updateAppFont(fontName: String){
        UIFont.appFontName = fontName
        UIFont.fontDic = UIFont.fontDic(fontName: UIFont.appFontName)
    }
    
    static func updateAppBoldFont(fontName: String){
        UIFont.appBoldFontName = fontName
        UIFont.boldFontDic = UIFont.fontDic(fontName: UIFont.appBoldFontName)
    }
    
    static func getFont(style : UIFont.TextStyle) -> UIFont{
        let fontDic : [UIFont.TextStyle : UIFont] = UIFont.myCustomFontDic()
        
        if let font = fontDic[style] {
            return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        }else{
            return UIFont.preferredFont(forTextStyle: style)
        }
    }
    
    static func getFont(size: CGFloat) -> UIFont{
        UIFont(name: appFontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func getBoldFont(style : UIFont.TextStyle) -> UIFont{
        let fontDic : [UIFont.TextStyle : UIFont] = UIFont.myCustomFontBoldDic()
        
        if let font = fontDic[style] {
            return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        }else{
            return UIFont.preferredFont(forTextStyle: style)
        }
    }
    
    static func getBoldFont(size: CGFloat) -> UIFont{
        UIFont(name: appBoldFontName, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    
    //MARK: Private
    private static var fontDic : [UIFont.TextStyle : UIFont] = {
        fontDic(fontName: appFontName)
    }()
    
    private static var boldFontDic : [UIFont.TextStyle : UIFont] = {
        fontDic(fontName: appBoldFontName)
    }()
    
    private static func fontDic(fontName: String) -> [UIFont.TextStyle : UIFont]{
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
    }
    
    
    private static func myCustomFontDic() -> [UIFont.TextStyle : UIFont]{
        return UIFont.fontDic
    }
    
    private static func myCustomFontBoldDic() -> [UIFont.TextStyle : UIFont]{
        return UIFont.boldFontDic
    }
    
}



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
    
