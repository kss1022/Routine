//
//  AppInfoContactViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import Foundation
import UIKit.UIColor


struct AppInfoContactViewModel{
    let emoji: String
    let title: String
    let backgroundColor: UIColor?
    let tapHandler: () -> ()
    
    
    init(_ model: AppInfoContactModel) {
        self.emoji = model.emoji
        self.title = model.title
        self.backgroundColor = UIColor(hex: model.backgroundColor)
        self.tapHandler = model.tapHandler
    }
}
