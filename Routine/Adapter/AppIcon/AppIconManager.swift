//
//  AppIconManager.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import Foundation
import UIKit.UIApplication


final class AppIconManager{
    
    
    public static let shared = AppIconManager()
    
    private init(){}
    
 
    @MainActor
    func supporChangeIcon() -> Bool{
        UIApplication.shared.supportsAlternateIcons
    }
    
    @MainActor
    func changeAppIcon(to icon: AppIcon) async throws{
        if !supporChangeIcon(){
            print("SupportsAlternateIcons if false")
            return
        }
        
        let iconName: String? = (icon == .blue) ?  nil : icon.rawValue
        try await UIApplication.shared.setAlternateIconName(iconName)
    }
}


enum AppIconManagerException: Error{
    case notSupportsAlternateIcons(msg : String)
    case settingAlternateIconError(msg : String)
}


enum AppIcon: String{
    case blue = "AppIcon"
    case red = "AppIcon2"
}
