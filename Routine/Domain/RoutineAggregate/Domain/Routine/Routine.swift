//
//  Routine.swift
//  Routine
//
//  Created by 한현규 on 2023/09/15.
//

import Foundation



final class Routine: DomainEntity{

    private(set) var routinId: RoutineId!
    private(set) var routineName: RoutineName!
    

    init(
        routineId: RoutineId,
        name: RoutineName
    ) {
        self.routinId = routineId
        self.routineName = name
        super.init()
        
        changes.append(
            RoutineCreated(routinId: routineId, routineName: routineName)
        )
    }
   
    
    required init(_ events: [Event]) {
        super.init(events)
    }
    
    override func mutate(_ event: Event){
        if let created = event as? RoutineCreated{
            when(created)
        }
    }
    
    private func when(_ event: RoutineCreated){
        self.routinId = event.routinId
        self.routineName = event.routineName
    }

    func when(_ event: RoutineNameChanged){
        self.routinId = event.routinId
        self.routineName = event.routineName
    }
    
    func changeRoutineName(_ routineName: RoutineName){
        self.routineName = routineName
        changes.append(
            RoutineNameChanged(routinId: self.routinId, routineName: routineName)
        )
    }
    
    

    
     
 

    override func encode(with coder: NSCoder) {
        coder.encode(self.routinId.id.uuidString,forKey: "routineId")
        coder.encode(self.routineName.name,forKey: "routineName")
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

