//
//  TimeRecord.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



struct TimeRecord: ValueObject{
    
    let startAt: Date
    let endAt: Date?
    let duration: Double?
    
    init(_ startAt: Date){
        self.startAt = startAt
        self.endAt = nil
        self.duration = nil
    }
    
    init(startAt: Date, endAt: Date, duration: Double) throws{
        if startAt > endAt{
            throw ArgumentException("startAt cannot be greater than endAt")
        }
        
        self.startAt = startAt
        self.endAt = endAt
        self.duration = duration
    }
        
    func encode(with coder: NSCoder) {
        coder.encodeDate(startAt, forKey: CodingKeys.startAt.rawValue)
        
        if let endAt = endAt, let duration = duration{
            coder.encodeDate(endAt, forKey: CodingKeys.endAt.rawValue)
            coder.encode(duration, forKey: CodingKeys.duration.rawValue)
        }
    }
    
    init?(coder: NSCoder) {
        guard let startAt = coder.decodeDate(forKey: CodingKeys.startAt.rawValue) else{
            return nil
        }
        
        self.startAt = startAt
        
        if let endAt = coder.decodeDate(forKey: CodingKeys.endAt.rawValue){
            self.endAt = endAt
            self.duration = coder.decodeDouble(forKey: CodingKeys.duration.rawValue)
        }else{
            self.endAt = nil
            self.duration = nil
        }        
    }
    
    
    private enum CodingKeys: String{
        case startAt
        case endAt
        case duration
    }
        
}
