//
//  UIDevice+Utils.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import UIKit


extension UIDevice{
    
    static func frame() -> CGRect{
        let bounds = UIScreen.main.bounds
        
        if !UIDevice.current.orientation.isLandscape{
            //TODO: The isLandscape value is incorrect immediately after the app is launched
            if bounds.width > bounds.height{
                return CGRect(x: 0, y: 0, width: bounds.height, height: bounds.width)
            }
            
            return bounds
        }else{
            return CGRect(x: 0, y: 0, width: bounds.height, height: bounds.width)
        }
    }        
}

