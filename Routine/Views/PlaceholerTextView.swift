//
//  PlaceholerTextView.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import UIKit


protocol PlaceholerTextViewDelegate: NSObject{
    
}

final class PlaceholerTextView: UITextView{
    
    var placeholder: String = ""
    var placeholerColor: UIColor = .secondaryLabel
    
    
    func didBeginEditing(){
        if text == placeholder{
            text = ""
        }
    }
    
    func didEndEditing(){
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
            text = placeholder
            textColor = .placeholderText
        }
    }
    
    
}
