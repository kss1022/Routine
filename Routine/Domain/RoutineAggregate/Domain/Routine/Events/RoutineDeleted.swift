//
//  RoutineDeleted.swift
//  Routine
//
//  Created by 한현규 on 10/5/23.
//

import Foundation



final class RoutineDeleted: DomainEvent{
    let routineId: RoutineId
    
    init(routineId: RoutineId) {
        self.routineId = routineId
        super.init()
    }
    
    override func encode(with coder: NSCoder) {
        routineId.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let routineId = RoutineId(coder: coder) else { return nil }
        
        self.routineId = routineId        
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true

}
