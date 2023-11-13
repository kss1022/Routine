//
//  RoutineDataOfWeekViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

import Foundation
import UIKit


struct RoutineDataOfWeekViewModel{
    let date: String
    let week: String
    let image: UIImage?
    let imageTintColor: UIColor
    
    init(date: Date, imageName: String, done: Bool) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "d"
        self.date = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "E"
        self.week = dateFormatter.string(from: date)
        
        self.image = UIImage(systemName: imageName)
        self.imageTintColor = done ? .primaryColor : .secondaryLabel
    }
}
