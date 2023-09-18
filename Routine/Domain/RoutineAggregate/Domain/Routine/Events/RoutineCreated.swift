//
//  RoutineEvents.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation




final class RoutineCreated : DomainEvent{
    
    let routinId: RoutineId
    let routineName: RoutineName
    
    init(routinId: RoutineId, routineName: RoutineName) {
        self.routinId = routinId
        self.routineName = routineName
        super.init()
    }
        
    override func encode(with coder: NSCoder) {
        coder.encode(routinId.id.uuidString, forKey: "routineId")
        coder.encode(routineName.name, forKey: "routineName")
        super.encode(with: coder)
    }

    required override init?(coder: NSCoder) {
        guard let routineId = coder.decodeObject(of: NSString.self, forKey: "routineId") as? String,
              let name = coder.decodeObject(of: NSString.self, forKey: "routineName")  as? String else { return nil }
        
        self.routinId =  RoutineId(id: UUID(uuidString: routineId as String)!)
        self.routineName = try! RoutineName(name)
        
        super.init(coder: coder)
    }

    static var supportsSecureCoding: Bool = true
}
