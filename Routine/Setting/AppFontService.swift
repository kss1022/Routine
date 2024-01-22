//
//  AppFontService.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import Foundation
import UIKit


final class AppFontService{
    
    
    public static let shared = AppFontService()
    
    private init(){}
    
    private let preferenceStorege = PreferenceStorage.shared
        
    //typeface
    public var fontName: String{
        preferenceStorege.appFont
    }
    
    public var boldFontName: String{
        preferenceStorege.appBoldFont
    }
    
    public var isOSTypeface: Bool{
        preferenceStorege.appIsOSTypeface
    }
    
    //fontSize
    public var fontSize: AppFontSize{
        preferenceStorege.appFontSize
    }
    
    public var isOSFontSize : Bool{
        preferenceStorege.appIsOSFontSize
    }
    
    //Set font
    func setup(){
        setFont()
        setAttributes()
    }
            
    
    //Set typeface
    func updateFont(familyName: String){
        //Update setting font
        let fontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: familyName])
        
        let fontName = familyName
        let boldFontName = fontDescriptor.withSymbolicTraits(.traitBold)?.postscriptName ?? familyName
        
        preferenceStorege.appFont = fontName
        preferenceStorege.appBoldFont = boldFontName
        preferenceStorege.appIsOSTypeface = true
                                
        setFontName()
        setAttributes()
        setAttachedTypeface()
                
        Log.d("AppFontManager updateFont: \(fontName),\(boldFontName)")
    }
    
    func updateBaseFont(){
        preferenceStorege.appFont = ""
        preferenceStorege.appBoldFont = ""
        preferenceStorege.appIsOSTypeface = false
                
        setFontName()
        setAttributes()
        setAttachedTypeface()
        
        Log.d("AppFontManager baseFont")
    }
    
    
    //set fontsize
    func updateOSFontSize(){
        preferenceStorege.appIsOSFontSize = true
        
        setIsOSFontSize()
        setAttachedToOSFont()
        
        Log.d("AppFontManager OSFont")
    }
    
    func updateAppFontSize(){
        preferenceStorege.appIsOSFontSize = false
        
        let sizes = toAppFontSizeDic()
        setIsAppFontSize()
        setAttachedToAppFont(sizes: sizes)
        
        Log.d("AppFontManager AppFontSize")
    }
    
    func updateAppFontSize(_ fontSize: AppFontSize){
        let before = preferenceStorege.appFontSize
        preferenceStorege.appFontSize = fontSize
        
        setFontSize()
        setAttachedFontSize(from: before, to: fontSize)
        
        Log.d("AppFontManager updateFontSize: \(fontSize)")
    }

}

//MARK: Set font name, size
extension AppFontService{
    private func setFont(){
        var fontName = "AppleSDGothicNeo-Regular"
        var boldFontName = "AppleSDGothicNeo-Bold"
        var fontSize = 0.0
        
        if isOSTypeface{
            fontName = self.fontName
            boldFontName = self.boldFontName
        }
        
        
        if !isOSFontSize{
            fontSize = self.fontSize.rawValue
        }
        
        UIFont.setFont(fontName: fontName, boldFontName: boldFontName, isDynamicFont: isOSFontSize ,fontSize: fontSize)
    }
    
    private func setFontName(){
        if isOSTypeface{
            UIFont.setFont(fontName: fontName, boldFontName: boldFontName)
            return
        }
        
        UIFont.setFont(fontName: "AppleSDGothicNeo-Regular", boldFontName: "AppleSDGothicNeo-Bold")
    }
    
    private func setIsOSFontSize(){
        if !isOSFontSize{
            fatalError("isOsFontSize must true")
        }
                
        UIFont.setIsDynamicFont(isDynamicFont: true)
        UIFont.setFontSize(fontSize: 0)
    }
    
    private func setIsAppFontSize(){
        if isOSFontSize{
            fatalError("isOsFontSize must false")
        }
                
        UIFont.setIsDynamicFont(isDynamicFont: false)
        UIFont.setFontSize(fontSize: fontSize.rawValue)
    }
    
    private func setFontSize(){
        if isOSFontSize{
            UIFont.setFontSize(fontSize: 0)
            return
        }
        
        UIFont.setFontSize(fontSize: fontSize.rawValue)
    }
}



// MARK: Set attributes
extension AppFontService{
    private func setAttributes(){
        setNavigationTypeface()
        setBarButtonItemTypeface()
        setTabBarItemTypeface()
    }
    
    private func setNavigationTypeface(){
        let titleFontAttributes = [NSAttributedString.Key.font: UIFont.getBoldFont(size: 20.0)]
        let largeTitleFontAttributes = [NSAttributedString.Key.font: UIFont.getBoldFont(size: 34.0)]
        UINavigationBar.appearance().titleTextAttributes = titleFontAttributes//[NSAttributedString.Key.font: UIFont.getBoldFont(size: 20.0)]
        UINavigationBar.appearance().largeTitleTextAttributes = largeTitleFontAttributes//[NSAttributedString.Key.font: UIFont.getBoldFont(size: 34.0)]
    }
    
    private func setBarButtonItemTypeface(){
        let fontAttributes = [NSAttributedString.Key.font: UIFont.getBoldFont(size: 17.0)]
        UIBarButtonItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(fontAttributes, for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes(fontAttributes, for: .selected)
    }
    
    private func setTabBarItemTypeface(){
        let fontAttributes = [NSAttributedString.Key.font: UIFont.getFont(size: 11.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .highlighted)
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .selected)
    }
    
}




// MARK: Update typeface attached views
extension AppFontService{
    private func setAttachedTypeface(){
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            //rootviewController -> children is NavigationController
            for childVC in window.rootViewController!.children {
                updateFontInViewControllerRecursive(childVC)
            }
        }
    }
    
    private func updateFontInViewControllerRecursive(_ viewController: UIViewController) {
        if !(viewController is UINavigationController){
            updateFontInSubviewsRecursive(viewController.view)
            return
        }
                        
        for childVC in viewController.children {
            updateFontInViewControllerRecursive(childVC)
        }
    }
    private func updateFontInSubviewsRecursive(_ view: UIView) {
        for subview in view.subviews {
            if let label = subview as? UILabel{
                label.adjustsFontSizeToFitWidth = true
                label.font = .getFont(size: label.font.pointSize)
            } else {
                updateFontInSubviewsRecursive(subview)
            }
        }
        
        view.layoutSubviews()
    }
}

// MARK: Update attached views OS to App
extension AppFontService{
    private func setAttachedToAppFont(sizes: [CGFloat:UIFont.TextStyle]){
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            //rootviewController -> children is NavigationController
            for childVC in window.rootViewController!.children {
                updateToAppFontInViewControllerRecursive(childVC, sizes: sizes)
            }
        }
    }
    
    private func updateToAppFontInViewControllerRecursive(_ viewController: UIViewController, sizes: [CGFloat:UIFont.TextStyle]) {
        if !(viewController is UINavigationController){
            updateFontToAppOSInSubviewsRecursive(viewController.view, sizes: sizes)
            return
        }
                        
        for childVC in viewController.children {
            updateToAppFontInViewControllerRecursive(childVC, sizes: sizes)
        }
    }
    private func updateFontToAppOSInSubviewsRecursive(_ view: UIView, sizes: [CGFloat:UIFont.TextStyle]) {
        for subview in view.subviews {
            if let label = subview as? UILabel{
                label.toAppFont(sizes: sizes)
            } else {
                updateFontToAppOSInSubviewsRecursive(subview, sizes: sizes)
            }
        }
        
        view.layoutSubviews()
    }
        

}


// MARK: Update  attached views App to OS
extension AppFontService{
    private func setAttachedToOSFont(){
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            //rootviewController -> children is NavigationController
            for childVC in window.rootViewController!.children {
                let styles = toOSFontStyleDic()
                updateToOSFontInViewControllerRecursive(childVC, styles: styles)
            }
        }
    }
    
    private func updateToOSFontInViewControllerRecursive(_ viewController: UIViewController, styles: [CGFloat:UIFont.TextStyle]) {
        if !(viewController is UINavigationController){
            updateToOSFontInSubviewsRecursive(viewController.view, styles: styles)
            return
        }
                        
        for childVC in viewController.children {
            updateToOSFontInViewControllerRecursive(childVC, styles: styles)
        }
    }
    private func updateToOSFontInSubviewsRecursive(_ view: UIView, styles: [CGFloat:UIFont.TextStyle]) {
        for subview in view.subviews {
            if let label = subview as? UILabel{
                label.toOSFont(styles: styles)
            } else {
                updateToOSFontInSubviewsRecursive(subview, styles: styles)
            }
        }
        
        view.layoutSubviews()
    }
}


// MARK: Update fontSize attached views
extension AppFontService{
    private func setAttachedFontSize(from: AppFontSize, to: AppFontSize){
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            
            for childVC in window.rootViewController!.children {
                updateFontSizeInViewControllerRecursive(childVC, value: to.rawValue - from.rawValue)
            }
        }
    }

    private func updateFontSizeInViewControllerRecursive(_ viewController: UIViewController, value: CGFloat) {
        if !(viewController is UINavigationController){
            updateFontSizeInSubviewsRecursive(viewController.view, value: value)
            return
        }
        
        for childVC in viewController.children {
            updateFontSizeInViewControllerRecursive(childVC, value: value)
        }
    }
    
    private func updateFontSizeInSubviewsRecursive(_ view: UIView, value: CGFloat) {
        for subview in view.subviews {
            if let label = subview as? UILabel{
                if !label.adjustsFontForContentSizeCategory{
                    continue
                }
                
                label.font = label.font.withSize(label.font.pointSize + value)
            } else {
                updateFontSizeInSubviewsRecursive(subview, value: value)
            }
        }
        
        view.layoutSubviews()
    }
 
}




private extension PreferenceKeys{
    var appFont : PrefKey<String>{ .init(name: "kAppFont", defaultValue: UIFont.appFontName) }
    var appBoldFont : PrefKey<String>{ .init(name: "kAppBoldFont", defaultValue: UIFont.appBoldFontName) }
    
    //typeface
    var appIsOSTypeface: PrefKey<Bool>{ .init(name: "kappIsOSTypeface", defaultValue: false)}
    
    //fontSize
    var appIsOSFontSize: PrefKey<Bool>{ .init(name: "kappIsOSFontSize", defaultValue: false)}
    var appFontSize: PrefKey<AppFontSize>{ .init(name: "kAppFontSize", defaultValue: .Large)}
}


public enum AppFontSize: CGFloat, Codable{
    case xSmall = -6.0
    case Small = -4.0
    case Medium = -2.0
    case Large  = 0.0   //Default
    case xLarge = 2.0
    case xxLarge = 4.0
    case xxxLarge = 6.0
}


extension AppFontService{
    private func toOSFontStyleDic() -> [CGFloat:UIFont.TextStyle]{
        var dic = [CGFloat: UIFont.TextStyle]()
        dic[34.0 + fontSize.rawValue] = .largeTitle
        dic[28.0 + fontSize.rawValue] = .title1
        dic[22.0 + fontSize.rawValue] = .title2
        dic[20.0 + fontSize.rawValue] = .title3
        dic[17.0 + fontSize.rawValue] = .headline
        dic[17.0 + fontSize.rawValue] = .body
        dic[16.0 + fontSize.rawValue] = .callout
        dic[15.0 + fontSize.rawValue] = .subheadline
        dic[13.0 + fontSize.rawValue] = .footnote
        dic[12.0 + fontSize.rawValue] = .caption1
        dic[11.0 + fontSize.rawValue] = .caption2
        return dic
    }
    
    private func toAppFontSizeDic() -> [CGFloat:UIFont.TextStyle]{
        var dic = [CGFloat: UIFont.TextStyle]()
        dic[UIFont.getFont(style: .largeTitle).pointSize] = .largeTitle
        dic[UIFont.getFont(style: .title1).pointSize] = .title1
        dic[UIFont.getFont(style: .title2).pointSize] = .title2
        dic[UIFont.getFont(style: .title3).pointSize] = .title3
        dic[UIFont.getFont(style: .headline).pointSize] = .headline
        dic[UIFont.getFont(style: .body).pointSize] = .body
        dic[UIFont.getFont(style: .callout).pointSize] = .callout
        dic[UIFont.getFont(style: .subheadline).pointSize] = .subheadline
        dic[UIFont.getFont(style: .footnote).pointSize] = .footnote
        dic[UIFont.getFont(style: .caption1).pointSize] = .caption1
        dic[UIFont.getFont(style: .caption2).pointSize] = .caption2
        return dic
    }
}

extension UILabel{
    fileprivate func toAppFont(sizes: [CGFloat:UIFont.TextStyle]){
        if !adjustsFontForContentSizeCategory{
            return
        }
                                
        guard let style = sizes[font.pointSize] else { return }
        if font.familyName == UIFont.appBoldFontName{
            setBoldFont(style: style)
            return
        }
        setFont(style: style)
    }
    
    fileprivate func toOSFont(styles: [CGFloat:UIFont.TextStyle]){
        if !adjustsFontForContentSizeCategory{
            return
        }
        
        guard let style = styles[font.pointSize] else { return }
                
        if font.familyName == UIFont.appBoldFontName{
            setBoldFont(style: style)
            return
        }
        setFont(style: style)
    }
                
    private func fontStyle(sizes: [CGFloat:UIFont.TextStyle]) -> UIFont.TextStyle?{
        sizes[font.pointSize]
    }
    
    
    // Fonts can be created with UIFont.preferredFont(forTextStyle:), but there's
    // no direct way to find out what textStyle a font was created with.....
    
    //    private func fontStyle() -> UIFont.TextStyle?{
    //        guard let font = font else { return nil }
    //        let fontDescriptor = font.fontDescriptor
    //        if let textStyle = fontDescriptor.fontAttributes[.textStyle] as? UIFont.TextStyle {
    //            return textStyle
    //        } else {
    //            return nil
    //        }
    //    }

}
