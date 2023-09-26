//
//  RoutineEvents.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation




final class RoutineCreated : DomainEvent{
    
    let routineId: RoutineId
    let routineName: RoutineName
    let routineDescription: RoutineDescription
    let icon: ImojiIcon
    let tint: Tint
    
    
    init(routineId: RoutineId, routineName: RoutineName, routineDescription: RoutineDescription,icon: ImojiIcon, tint: Tint) {
        self.routineId = routineId
        self.routineDescription = routineDescription
        self.routineName = routineName
        self.icon = icon
        self.tint = tint
        super.init()
    }
        
    override func encode(with coder: NSCoder) {
        routineId.encode(with: coder)
        routineName.encode(with: coder)
        routineDescription.encode(with: coder)
        icon.encode(with: coder)
        tint.encode(with: coder)
        super.encode(with: coder)
    }

    required override init?(coder: NSCoder) {
        guard let routineId = RoutineId(coder: coder),
              let routineName = RoutineName(coder: coder),
              let routineDescription = RoutineDescription(coder: coder),
              let icon = ImojiIcon(coder: coder),
              let tint = Tint(coder: coder)
        else { return nil }
                    
        self.routineId =  routineId
        self.routineName = routineName
        self.routineDescription = routineDescription
        self.icon = icon
        self.tint = tint
        
        super.init(coder: coder)
    }

    static var supportsSecureCoding: Bool = true
}
