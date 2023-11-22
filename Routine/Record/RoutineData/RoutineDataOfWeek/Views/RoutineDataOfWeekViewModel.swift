//
//  RoutineDataOfWeekViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import Foundation
import UIKit


struct RoutineDataOfWeekListViewModel{
    let sun: RoutineDataOfWeekViewModel
    let mon: RoutineDataOfWeekViewModel
    let tue: RoutineDataOfWeekViewModel
    let wed: RoutineDataOfWeekViewModel
    let thu: RoutineDataOfWeekViewModel
    let fri: RoutineDataOfWeekViewModel
    let sat: RoutineDataOfWeekViewModel
    let image: UIImage?
    let imageTintColor: UIColor
    
    init(dates: [Date], model: RoutineWeekRecordModel?, imageName: String, imageTintColor: String) {
        self.image = UIImage(systemName: imageName)
        self.imageTintColor = UIColor(hex: imageTintColor) ?? UIColor.primaryColor
                                        
        self.sun = RoutineDataOfWeekViewModel(date: dates[0], done: model?.sunday ?? false)
        self.mon = RoutineDataOfWeekViewModel(date: dates[1], done: model?.monday ?? false)
        self.tue = RoutineDataOfWeekViewModel(date: dates[2], done: model?.tuesday ?? false)
        self.wed = RoutineDataOfWeekViewModel(date: dates[3], done: model?.wednesday ?? false)
        self.thu = RoutineDataOfWeekViewModel(date: dates[4], done: model?.thursday ?? false)
        self.fri = RoutineDataOfWeekViewModel(date: dates[5], done: model?.friday ?? false)
        self.sat = RoutineDataOfWeekViewModel(date: dates[6], done: model?.saturday ?? false)
    }
}

struct RoutineDataOfWeekViewModel{
    let date: String
    let week: String
    let done: Bool
    
    init(date: Date, done: Bool) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "d"
        self.date = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "E"
        self.week = dateFormatter.string(from: date)
        self.done = done
    }
}
