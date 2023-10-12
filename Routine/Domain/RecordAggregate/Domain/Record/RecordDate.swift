//
//  RecordDate.swift
//  Routine
//
//  Created by 한현규 on 10/11/23.
//

import Foundation


struct RecordDate: ValueObject{

    let year: Int
    let month: Int
    let day: Int
    
    init(date: Date){
        let calendar = Calendar.current
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
    }
    
    

    func encode(with coder: NSCoder) {
        coder.encodeInteger(year, forKey: CodingKeys.year.rawValue)
        coder.encodeInteger(month, forKey: CodingKeys.month.rawValue)
        coder.encodeInteger(day, forKey: CodingKeys.day.rawValue)
    }

    init?(coder: NSCoder) {
        self.year = coder.decodeInteger(forKey: CodingKeys.year.rawValue)
        self.month = coder.decodeInteger(forKey: CodingKeys.month.rawValue)
        self.day = coder.decodeInteger(forKey: CodingKeys.day.rawValue)
    }

    private enum CodingKeys: String{
        case year
        case month
        case day
    }

    
}



