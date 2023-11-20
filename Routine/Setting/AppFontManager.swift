//
//  AppFontManager.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import Foundation
import UIKit


final class AppFontManager{
    
    
    public static let share = AppFontManager()
    
    private let preferenceStorege = PreferenceStorage.shared
    public let fontDic: [String: [String]]
    
    private init(){
        var fontDic = [String: [String]]()
        
        UIFont.familyNames.forEach { familyName in
            fontDic[familyName] = UIFont.fontNames(forFamilyName: familyName)
        }
        self.fontDic = fontDic
    }
    
    func setup(){
        
        setTypeface()
        setFontSize()
    }
            
    
    //MARK: Typeface
    func updateFont(familyName: String) throws{
        let fontDescriptor = UIFontDescriptor(fontAttributes: [UIFontDescriptor.AttributeName.family: familyName])
        let boldFontName = fontDescriptor.withSymbolicTraits(.traitBold)?.postscriptName ?? familyName
        
        preferenceStorege.appFont = familyName
        preferenceStorege.appBoldFont = boldFontName
        setTypeface()
        
        Log.d("AppFontManager Set Font")
    }
    
    private func setTypeface(){
        let font = preferenceStorege.appFont
        let boldFont = preferenceStorege.appBoldFont
        UIFont.updateAppFont(fontName: font)
        UIFont.updateAppBoldFont(fontName: boldFont)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont.getBoldFont(size: 20.0)]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont.getBoldFont(size: 34.0)]
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.getFont(size: 11.0)]
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(fontAttributes, for: .selected)
    }
    
    
    //MARK: Font Size
    func setOfDynamicSize(){
        preferenceStorege.isCustomSize = false
        
        setFontSize()
    }
    
    func setCustomFontSize(size: Float){
        preferenceStorege.isCustomSize = true
        preferenceStorege.customSize = size
        
        setFontSize()
    }
    
    private func setFontSize(){
    }
    

}

class AppFontManagerException: SystemException{
}


private extension PreferenceKeys{
    var appFont : PrefKey<String>{ .init(name: "kAppFont", defaultValue: "AppleSDGothicNeo-Regular") }
    var appBoldFont : PrefKey<String>{ .init(name: "kAppBoldFont", defaultValue: "AppleSDGothicNeo-Bold") }
    
    var isCustomSize: PrefKey<Bool>{ .init(name: "isCustomSize", defaultValue: false)}
    var customSize: PrefKey<Float>{ .init(name: "kCustomSize", defaultValue: 10.0)}
}
