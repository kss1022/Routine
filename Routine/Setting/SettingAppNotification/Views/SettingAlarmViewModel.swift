//
//  SettingAlarmViewModel.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import Foundation
import UIKit.UIImage



struct SettingAlarmViewModel{
    let title: String
    let image: UIImage?
    let isOn: Bool
    
    init(_ model: SettingAlarmModel) {
        self.title = model.title
        self.image = UIImage(systemName: model.imageName)
        self.isOn = model.isOn        
    }
}


