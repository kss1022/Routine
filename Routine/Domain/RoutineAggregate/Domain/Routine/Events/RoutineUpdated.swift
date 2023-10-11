//
//  RoutineUpdated.swift
//  Routine
//
//  Created by 한현규 on 10/4/23.
//

import Foundation



final class RoutineUpdated: DomainEvent{
        
    let routineId: RoutineId
    let routineName: RoutineName
    let routineDescription: RoutineDescription
    let `repeat`: Repeat
    let emoji: Emoji
    let tint: Tint
    
    init(routineId: RoutineId, routineName: RoutineName, routineDescription: RoutineDescription, repeat: Repeat, emoji: Emoji, tint: Tint) {
        self.routineId = routineId
        self.routineName = routineName
        self.routineDescription = routineDescription
        self.repeat = `repeat`
        self.emoji = emoji
        self.tint = tint
        super.init()
    }
    

    
    override func encode(with coder: NSCoder) {
        routineId.encode(with: coder)
        routineName.encode(with: coder)
        routineDescription.encode(with: coder)
        `repeat`.encode(with: coder)
        emoji.encode(with: coder)
        tint.encode(with: coder)
        super.encode(with: coder)
    }
    
    
    override init?(coder: NSCoder) {
        guard let routineId = RoutineId(coder: coder),
              let routineName = RoutineName(coder: coder),
              let routineDescription = RoutineDescription(coder: coder),
              let `repeat`  = Repeat(coder: coder),
              let icon = Emoji(coder: coder),
              let tint = Tint(coder: coder)
        else { return nil }
                    
        self.routineId =  routineId
        self.routineName = routineName
        self.routineDescription = routineDescription
        self.repeat = `repeat`
        self.emoji = icon
        self.tint = tint
        
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
    
    
}
