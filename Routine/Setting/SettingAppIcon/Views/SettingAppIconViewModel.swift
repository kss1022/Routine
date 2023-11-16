//
//  SettingAppIconViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import Foundation
import UIKit.UIImage



struct SettingAppIconViewModel: Hashable{
    let id: UUID
    let image: UIImage?
    
    init(image: String) {
        self.id = UUID()
        self.image = UIImage(named: image)
    }
}
