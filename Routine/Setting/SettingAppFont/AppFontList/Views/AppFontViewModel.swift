//
//  AppFontListViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import Foundation
import UIKit.UIFont


struct AppFontListViewModel{
    let section: String
    let fonts: [AppFontViewModel]
}


struct AppFontViewModel: Hashable{
    let fontName: String
    let font: UIFont
    
    init(fontName: String) {
        self.fontName = fontName
        self.font = UIFont(name: fontName, size: 20.0).flatMap {
            UIFontMetrics(forTextStyle: .title3).scaledFont(for: $0)
        } ?? UIFont.systemFont(ofSize: 20.0, weight: .regular)          
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(fontName)
    }
    
    static func ==(lhs: AppFontViewModel, rhs: AppFontViewModel) -> Bool{
        lhs.fontName == rhs.fontName
    }
    
}
