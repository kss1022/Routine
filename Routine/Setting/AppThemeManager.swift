//
//  AppThemeManager.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import Foundation
import UIKit.UIApplication

public class AppThemeManager{
    
    public static let share = AppThemeManager()
    
    public var theme: AppTheme{ AppTheme(rawValue:PreferenceStorage.shared.apptheme) ?? .system}
    
    func setup(){
        setTheme()
    }
    
    func updateTheme(){
        setTheme()
    }
    
    func setSystemMode(){
        PreferenceStorage.shared.apptheme = AppTheme.system.rawValue
    }
    
    func setLightMode(){
        PreferenceStorage.shared.apptheme = AppTheme.light.rawValue
    }
    
    func setDarkMode(){
        PreferenceStorage.shared.apptheme = AppTheme.dark.rawValue
    }
    


    private func window() -> UIWindow?{
        guard let delegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
              let window = delegate.window else{ return nil}
        return window
    }
    
    private func setTheme(){
        guard let window = window() else { return }
        switch theme {
        case .system:
            window.overrideUserInterfaceStyle = .unspecified
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        case .light:
            window.overrideUserInterfaceStyle = .light
        }
    }
    
}

public enum AppTheme: String{
    case system
    case light
    case dark
}



private extension PreferenceKeys{
    var apptheme : PrefKey<String>{ .init(name: "kAppTheme", defaultValue: AppTheme.system.rawValue) } //AppTheme
}
