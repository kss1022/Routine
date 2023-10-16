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
    private(set) var `repeat`: Repeat!
    private(set) var reminder: Reminder?
    private(set) var icon: Emoji!
    private(set) var tint: Tint!
    

    
    init(
        routineId: RoutineId,
        routineName: RoutineName,
        routineDescription: RoutineDescription,
        repeat: Repeat,
        reminder: Reminder?,
        icon: Emoji,
        tint: Tint
    ) {
        self.routineId = routineId
        self.routineName = routineName
        self.routineDescription = routineDescription
        self.repeat = `repeat`
        self.reminder = reminder
        self.icon = icon
        self.tint = tint
        super.init()

        
        changes.append(
            RoutineCreated(routineId: routineId, routineName: routineName, routineDescription: routineDescription, repeat: `repeat`, reminder: reminder, icon: icon, tint: tint)
        )
    }
   
    
    required init(_ events: [Event]) {
        super.init(events)
    }
    
    override func mutate(_ event: Event){
        if let created = event as? RoutineCreated{
            when(created)
        }else if let updated = event as? RoutineUpdated{
            when(updated)
        }else if let nameChanged = event as? RoutineNameChanged{
            when(nameChanged)
        }else if let delete = event as? RoutineDeleted{
            //nothing to do
            Log.e("Routine is Deleted: \(delete.routineId)")
        }else{
            Log.e("Event is not handling")
        }
    }
    
    private func when(_ event: RoutineCreated){
        self.routineId = event.routineId
        self.routineName = event.routineName
        self.routineDescription = event.routineDescription
        self.`repeat` = event.repeat
        self.reminder = event.reminder
        self.icon = event.emoji
        self.tint = event.tint
    }

    func when(_ event: RoutineNameChanged){
        self.routineId = event.routineId
        self.routineName = event.routineName
    }
    
    func when(_ event: RoutineUpdated){
        self.routineId = event.routineId
        self.routineName = event.routineName
        self.routineDescription = event.routineDescription
        self.repeat = event.repeat
        self.reminder = event.reminder
        self.icon = event.emoji
        self.tint = event.tint
    }
    
    func updateRoutine(_ routineName: RoutineName, routineDescription: RoutineDescription, repeat: Repeat, reminder: Reminder?, emoji: Emoji, tint: Tint){
        self.routineName = routineName
        self.routineDescription = routineDescription
        self.repeat = `repeat`
        self.reminder = reminder
        self.icon = emoji
        self.tint = tint
        
        changes.append(RoutineUpdated(routineId: self.routineId, routineName: routineName, routineDescription: routineDescription, repeat: `repeat`, reminder: reminder, emoji: icon, tint: tint))
    }
    
    func changeRoutineName(_ routineName: RoutineName){
        self.routineName = routineName
        changes.append(
            RoutineNameChanged(routineId: self.routineId, routineName: routineName)
        )
    }
    
    func deleteRoutine(){
        changes.append(
            RoutineDeleted(routineId: self.routineId)
        )
    }
    

    // MARK: Serialize
    
    override func encode(with coder: NSCoder) {
        routineId.encode(with: coder)
        routineName.encode(with: coder)
        routineDescription.encode(with: coder)
        `repeat`.encode(with: coder)
        reminder?.encode(with: coder)
        icon.encode(with: coder)
        tint.encode(with: coder)
        super.encode(with: coder)
    }

    required override init?(coder: NSCoder) {
        guard let routineId = RoutineId(coder: coder),
              let routineName = RoutineName(coder: coder),
              let routineDescription = RoutineDescription(coder: coder),
              let `Repeat` = Repeat(coder: coder),
              let icon = Emoji(coder: coder),
              let tint = Tint(coder: coder)
        else { return nil }
                    
        self.routineId =  routineId
        self.routineName = routineName
        self.routineDescription = routineDescription
        self.`repeat` = `Repeat`
        self.reminder = Reminder(coder: coder)
        self.icon = icon
        self.tint = tint
        
        super.init(coder: coder)
    }

    static var supportsSecureCoding: Bool = true

}

