//
//  RoutineNameChanged.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation




final class RoutineNameChanged : DomainEvent{
    
    let routineId: RoutineId
    let routineName: RoutineName
    
    init(routineId: RoutineId, routineName: RoutineName) {
        self.routineId = routineId
        self.routineName = routineName
        super.init()
    }
        
    override func encode(with coder: NSCoder) {
        routineId.encode(with: coder)
        routineName.encode(with: coder)
        super.encode(with: coder)
    }

    required override init?(coder: NSCoder) {
        guard let routineId = RoutineId(coder: coder),
            let routineName = RoutineName(coder: coder) else { return nil }
        
        self.routineId =  routineId
        self.routineName = routineName
        
        super.init(coder: coder)
    }

    static var supportsSecureCoding: Bool = true
}

