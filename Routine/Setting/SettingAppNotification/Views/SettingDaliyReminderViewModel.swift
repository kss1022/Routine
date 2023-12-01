//
//  SettingReminderViewModel.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import Foundation
import UIKit.UIImage



struct SettingDaliyReminderViewModel{
    let title: String
    let subTitle: String
    let image: UIImage?
    let isOn: Bool
    let date : Date
    let isShow: Bool
    let onOffChanged: (Bool) -> Void
    let dateChanged: (Date) -> Void
    
    init(_ model: SettingDaliyReminderModel) {
        self.title = model.title
        self.subTitle = Formatter.settingReminderDateFormatter().string(from: model.date)
        self.image = UIImage(systemName: model.imageName)
        self.isOn = model.isOn
        self.date = model.date
        self.isShow = model.isShow
        self.onOffChanged = model.onOffChanged
        self.dateChanged = model.dateChanged
    }
}
