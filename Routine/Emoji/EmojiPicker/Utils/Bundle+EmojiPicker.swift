//
//  Bundle+EmojiPicker.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import Foundation

/// We don't want `Bundle.module` that is being generated automatically for Swift Package to be overriden by our property.
#if !SWIFT_PACKAGE
extension Bundle {
    /**
     Resources bundle.
     
     Since CocoaPods resources bundle is something other than SPM's `Bundle.module`, we need to create it.
     
     - Note: It was named same as for Swift Package to simplify usage.
     */
    static var module: Bundle {
        let path = Bundle(for: EmojiManager.self).path(forResource: "Resource", ofType: "bundle") ?? ""
        return Bundle(path: path) ?? Bundle.main
    }
}
#endif
