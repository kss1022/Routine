//
//  EventStream.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation


public class EventStream{
    
    public var version : Int
    public var events : [Event]
    
    init() {
        self.version = 1
        self.events = []
    }
    
    init(version: Int, events: [Event]) {
        self.version = version
        self.events = events
    }
}
