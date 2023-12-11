//
//  UIPasteboardManager.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//


import UIKit



final class UIPasteboardManager{
    
    public static let shared = UIPasteboardManager()
    
    private init(){}
    
    
    func copyClipboard(content: String){
        UIPasteboard.general.string = content
    }
    
    
    
}
