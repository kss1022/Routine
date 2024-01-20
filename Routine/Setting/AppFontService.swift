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
    
    public var fontName: String{
        preferenceStorege.appFont
    }
    
    public var boldFontName: String{
        preferenceStorege.appBoldFont
    }
    
    //typeface
    public var isOSTypeface: Bool{
        preferenceStorege.appIsOSTypeface
    }
    
    //fontSize
    public var ifOSFontSize : Bool{
        preferenceStorege.appIsOSFontSize
    }

    public var fontSize: AppFontSize{
        preferenceStorege.appFontSize
    }
    
    func setup(){
        setFontName()
        setAttributes()
    }
            
    
    
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
    
    
    
    //MARK: Typeface
//    private func setTypeface(){
//        let fontName = preferenceStorege.appFont
//        let boldFontName = preferenceStorege.appBoldFont
//        UIFont.updateAppFont(fontName: fontName)
//        UIFont.updateAppBoldFont(fontName: boldFontName)
//    }
    
   
  
    
//    MARK: Font Size
//    func setOfDynamicSize(){
//        preferenceStorege.isCustomSize = false
//        
//        setFontSize()
//    }
//    
//    func setCustomFontSize(size: Float){
//        preferenceStorege.isCustomSize = true
//        preferenceStorege.customSize = size
//        
//        setFontSize()
//    }
//    
//    private func setFontSize(){
//    }
    

}

//MARK: Set font name
extension AppFontService{
    private func setFontName(){
        if isOSTypeface{
            UIFont.setFont(fontName: fontName, boldFontName: boldFontName)
            return
        }
        
        UIFont.setFont(fontName: "AppleSDGothicNeo-Regular", boldFontName: "AppleSDGothicNeo-Bold")
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




// MARK: Update attached views
extension AppFontService{
    private func setAttachedTypeface(){
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
           let window = sceneDelegate.window {
            updateFontInViewControllerRecursive(window.rootViewController!)
        }
    }
    
    private func updateFontInViewControllerRecursive(_ viewController: UIViewController) {
        updateFontInSubviewsRecursive(viewController.view)
        
        for childVC in viewController.children {
            updateFontInViewControllerRecursive(childVC)
        }
    }
    private func updateFontInSubviewsRecursive(_ view: UIView) {
        for subview in view.subviews {
            if let label = subview as? UILabel {
                label.font = .getFont(size: label.font.pointSize)
            } else {
                updateFontInSubviewsRecursive(subview)
            }
        }
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


public enum AppFontSize: String{
    case xSmall
    case Small
    case Medium
    case Large //Default
    case xLarge
    case xxLarge
    case xxxLarge
}
