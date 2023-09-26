//
//  CheckList.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation




final class CheckList: DomainEntity{

    
    
    private(set) var routineId: RoutineId!
    private(set) var checkListId: CheckListId!
    private(set) var checkListName: CheckListName!
    private(set) var reps : Repetition!
    private(set) var set: SetCount!
    private(set) var weight: Weight!
    
    public required init(_ events: [Event]) {
        fatalError("init(_:) has not been implemented")
    }
    
    init(routineId: RoutineId, checkListId: CheckListId, checkListName: CheckListName, reps: Repetition, set: SetCount, weight: Weight) {
        self.routineId = routineId
        self.checkListId = checkListId
        self.checkListName = checkListName
        self.reps = reps
        self.set = set
        self.weight = weight
        super.init()
        
        self.changes.append(
            CheckListCreated(
                routineId: routineId,
                checkListId: checkListId,
                checkListName: checkListName,
                reps: reps,
                set: set,
                weight: weight
            )
        )
    }
    
    override func encode(with coder: NSCoder) {
        routineId.encode(with: coder)
        checkListId.encode(with: coder)
        checkListName.encode(with: coder)
        reps.encode(with: coder)
        set.encode(with: coder)
        weight.encode(with: coder)
        super.encode(with: coder)
    }
    
    override init?(coder: NSCoder) {
        guard let routineId = RoutineId(coder: coder),
              let checkListId = CheckListId(coder: coder),
              let checkListName = CheckListName(coder: coder),
              let reps = Repetition(coder: coder),
              let set = SetCount(coder: coder),
              let weight = Weight(coder: coder)
        else { return nil }

        
        self.routineId = routineId
        self.checkListId = checkListId
        self.checkListName = checkListName
        self.reps = reps
        self.set = set
        self.weight = weight
        
        super.init(coder: coder)
    }
    
    static var supportsSecureCoding: Bool = true
}
