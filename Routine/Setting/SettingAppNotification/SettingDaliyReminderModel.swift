//
//  SettingReminderModel.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import Foundation



struct SettingDaliyReminderModel{
    let title: String
    let imageName: String
    let isOn: Bool
    let date : Date
    let isShow: Bool
    let onOffChanged: (Bool) -> Void
    let dateChanged: (Date) -> Void
}
