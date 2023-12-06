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
    
    private let userDefaults = UserDefaults.standard
    
    public var theme: AppTheme{
        userDefaults.string(forKey: kAppTheme)
            .flatMap(AppTheme.init) ?? .system
    }
    
    func setup(){
        setTheme()
    }
    
    func updateTheme(){
        setTheme()
    }
    
    func setSystemMode(){
        userDefaults.set(AppTheme.system.rawValue, forKey: kAppTheme)
        Log.v("Saved to PreferenceStorage: \(kAppTheme) <- system")
    }
    
    func setLightMode(){
        userDefaults.set(AppTheme.light.rawValue, forKey: kAppTheme)
        Log.v("Saved to PreferenceStorage: \(kAppTheme) <- light")
    }
    
    func setDarkMode(){
        userDefaults.set(AppTheme.dark.rawValue, forKey: kAppTheme)
        Log.v("Saved to PreferenceStorage: \(kAppTheme) <- dark")
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
    
    private let kAppTheme = "kAppTheme"
    

}

public enum AppTheme: String{
    case system
    case light
    case dark
}

