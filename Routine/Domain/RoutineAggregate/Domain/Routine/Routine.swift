//
//  Routine.swift
//  Routine
//
//  Created by 한현규 on 2023/09/15.
//

import Foundation



// TODO: GROUP, Repeat, Reminer ,Goal

final class Routine: DomainEntity{

    private(set) var routineId: RoutineId!
    private(set) var routineName: RoutineName!
    private(set) var routineDescription: RoutineDescription!
    private(set) var icon: ImojiIcon!
    private(set) var tint: Tint!
    

    
    init(
        routineId: RoutineId,
        routineName: RoutineName,
        routineDescription: RoutineDescription,
        icon: ImojiIcon,
        tint: Tint
    ) {
        self.routineId = routineId
        self.routineName = routineName
        self.routineDescription = routineDescription
        self.icon = icon
        self.tint = tint
        super.init()

        
        changes.append(
            RoutineCreated(routineId: routineId, routineName: routineName, routineDescription: routineDescription, icon: icon, tint: tint)
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
        self.routineId = event.routineId
        self.routineName = event.routineName
        self.routineDescription = event.routineDescription
        self.icon = event.icon
        self.tint = event.tint
    }

    func when(_ event: RoutineNameChanged){
        self.routineId = event.routineId
        self.routineName = event.routineName
    }
    
    func changeRoutineName(_ routineName: RoutineName){
        self.routineName = routineName
        changes.append(
            RoutineNameChanged(routineId: self.routineId, routineName: routineName)
        )
    }
    

    // MARK: Serialize
    
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

