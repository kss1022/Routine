//
//  Bundle+Utils.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import Foundation



extension Bundle{
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
}



