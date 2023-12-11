//
//  AppInfoManager.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import UIKit



final class AppInfoManager{
    
    public static var shared = AppInfoManager()
    
    private init(){}
    
    //MARK: Bundle Info
    func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let bundleName = dictionary["CFBundleName"] as? String else { return "" }
        return bundleName
    }
   
    
    func version() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
    func buildVersion() -> String{
        guard let dictionary = Bundle.main.infoDictionary,
              let buildVersion = dictionary["CFBundleVersion"] as? String else { return "" }
        return buildVersion
    }

    
    //MARK: Device Info
    // 🔥 iOS Version
    var iOSVersion: String{
        let device = UIDevice.current
        return "\(device.systemName) \(device.systemVersion)"
    }
    
    
    
    var iPhoneModel: String {
        return modelDictionary[hardwareString] ?? "Unknown iPhone - \(hardwareString)"
    }
    
    
    private static var hardwareString: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let model = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return model
    }
    
    

    // 🔥 iPhone Model
    private  var hardwareString: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let model = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return model
    }
    
    
    /// Referenced the following URL.
    /// [List of iOS and iPadOS devices](https://en.wikipedia.org/wiki/List_of_iOS_and_iPadOS_devices)
    private  var modelDictionary: [String: String] {
        return [
            "i386": "Simulator",   // 32 bit
            "x86_64": "Simulator", // 64 bit
            "iPhone8,1": "iPhone 6S",
            "iPhone8,2": "iPhone 6S Plus",
            "iPhone8,4": "iPhone SE 1st generation",
            "iPhone9,1": "iPhone 7",
            "iPhone9,3": "iPhone 7",
            "iPhone9,2": "iPhone 7 Plus",
            "iPhone9,4": "iPhone 7 Plus",
            "iPhone10,1": "iPhone 8",
            "iPhone10,4": "iPhone 8",
            "iPhone10,2": "iPhone 8 Plus",
            "iPhone10,5": "iPhone 8 Plus",
            "iPhone10,3": "iPhone X",
            "iPhone10,6": "iPhone X",
            "iPhone11,2": "iPhone XS",
            "iPhone11,4": "iPhone XS Max",
            "iPhone11,6": "iPhone XS Max",
            "iPhone11,8": "iPhone XR",
            "iPhone12,1": "iPhone 11",
            "iPhone12,3": "iPhone 11 Pro",
            "iPhone12,5": "iPhone 11 Pro Max",
            "iPhone12,8": "iPhone SE 2nd generation",
            "iPhone13,1": "iPhone 12 Mini",
            "iPhone13,2": "iPhone 12",
            "iPhone13,3": "iPhone 12 Pro",
            "iPhone13,4": "iPhone 12 Pro Max",
            "iPhone14,4": "iPhone 13 Mini",
            "iPhone14,5": "iPhone 13",
            "iPhone14,2": "iPhone 13 Pro",
            "iPhone14,3": "iPhone 13 Pro Max",
            "iPhone14,6": "iPhone SE 3nd generation"
        ]
    }
 
}

