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
    
    init(_ model: SettingDaliyReminderModel, isShow: Bool) {
        
        let calender = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.hour = model.hour
        dateComponent.minute = model.minute
        
        let date = calender.date(from: dateComponent)!
        
        
        self.title = model.title
        self.subTitle = Formatter.settingReminderDateFormatter().string(from: date)
        self.image = UIImage(systemName: model.imageName)
        self.isOn = model.isOn
        self.date = date
        self.isShow = isShow        
    }
}
