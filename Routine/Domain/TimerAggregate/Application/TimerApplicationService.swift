//
//  TimerApplicationService.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation



final class TimerApplicationService: ApplicationService{
    
    
    internal var eventStore: EventStore
    internal var snapshotRepository: SnapshotRepository
    
    private let timerFactory: TimerFactory
    
    
    init(
        eventStore: EventStore,
        snapshotRepository: SnapshotRepository,
        timerFactory: TimerFactory) {
        self.eventStore = eventStore
        self.snapshotRepository = snapshotRepository
        self.timerFactory = timerFactory
    }
    
  
    
    func when(_ command: CreateFocusTimer) async throws{
        do{
            Log.v("When (\(CreateFocusTimer.self)):  \(command)")
            
            let timerId = TimerId(UUID())
            let timerName = try TimerName(command.name)
            let emoji = Emoji(command.emoji)
            let tint = Tint(command.tint)
            let timerType = TimerType.focus
            let minutes = try Minutes(min: command.min)
            
            let timer = timerFactory.create(timerId: timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, minutes: minutes)
                        
            try eventStore.appendToStream(id: timer.timerId.id, expectedVersion: -1, events: timer.changes)
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: UpdateFocusTimer) async throws{
        do{
            Log.v("When (\(UpdateFocusTimer.self)):  \(command)")
            
            let timerName = try TimerName(command.name)
            let emoji = Emoji(command.emoji)
            let tint = Tint(command.tint)
            let timerType = TimerType.focus
            let minutes = try Minutes(min: command.min)
         
            try update(id: command.id) { (timer: FocusTimer) in
                timer.updateTimer(timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, minutes: minutes)
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    func when(_ command: DeleteFocusTimer) async throws{
        do{
            Log.v("When (\(DeleteFocusTimer.self)):   \(command)")
            
            try update(id: command.id) { (timer: FocusTimer) in
                timer.deleteTimer()
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
    //MARK: TabatTimer
    func when(_ command: CreateTabataTimer) async throws{
        do{
            Log.v("When (\(CreateTabataTimer.self)):  \(command)")
            
            let timerId = TimerId(UUID())
            let timerName = try TimerName(command.name)
            let emoji = Emoji(command.emoji)
            let tint = Tint(command.tint)
            let timerType = TimerType.tabata
            
            let ready = try Ready(command.ready)
            let exercise = try Exercise(command.exercise)
            let rest = try Rest(command.rest)
            let round = try Round(command.round)
            let cycle = try Cycle(command.cycle)
            let cycleRest = try CycleRest(command.cycleRest)
            let cooldown = try Cooldown(command.cooldown)
            
            let timer = timerFactory.create(
                timerId: timerId,
                timerName: timerName,
                emoji: emoji,
                tint: tint,
                timerType: timerType,
                ready: ready,
                exercise: exercise,
                rest: rest,
                round: round,
                cycle: cycle,
                cycleRest: cycleRest,
                cooldown: cooldown
            )
            
            try eventStore.appendToStream(id: timerId.id, expectedVersion: -1, events: timer.changes)                        
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
    func when(_ command: UpdateTabataTimer) async throws{
        do{
            Log.v("When (\(UpdateTabataTimer.self)):  \(command)")
            
            let timerId = TimerId(UUID())
            let timerName = try TimerName(command.name)
            let emoji = Emoji(command.emoji)
            let tint = Tint(command.tint)
            let timerType = TimerType.tabata
            
            let ready = try Ready(command.ready)
            let exercise = try Exercise(command.exercise)
            let rest = try Rest(command.rest)
            let round = try Round(command.round)
            let cycle = try Cycle(command.cycle)
            let cycleRest = try CycleRest(command.cycleRest)
            let cooldown = try Cooldown(command.cooldown)
            
            try update(id: command.id) { (timer: TabataTimer) in
                timer.updateTimer(
                    timerName: timerName,
                    emoji: emoji,
                    tint: tint,
                    timerType: timerType,
                    ready: ready,
                    exercise: exercise,
                    rest: rest,
                    round: round,
                    cycle: cycle,
                    cycleRest: cycleRest,
                    cooldown: cooldown
                )
            }
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
    func when(_ command: DeleteTabataTimer) async throws{
        do{
            Log.v("When (\(DeleteTabataTimer.self)):   \(command)")
            
            try update(id: command.id) { (timer: TabataTimer) in
                timer.deleteTimer()
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    //MARK: RoundTimer
    func when(_ command: CreateRoundTimer) async throws{
        do{
            Log.v("When (\(CreateRoundTimer.self)):  \(command)")
            
            let timerId = TimerId(UUID())
            let timerName = try TimerName(command.name)
            let emoji = Emoji(command.emoji)
            let tint = Tint(command.tint)
            let timerType = TimerType.round
            
            let ready = try Ready(command.ready)
            let exercise = try Exercise(command.exercise)
            let rest = try Rest(command.rest)
            let round = try Round(command.round)
            let cooldown = try Cooldown(command.cooldown)
            
            let timer = timerFactory.create(
                timerId: timerId,
                timerName: timerName,
                emoji: emoji,
                tint: tint,
                timerType: timerType,
                ready: ready,
                exercise: exercise,
                rest: rest,
                round: round,
                cooldown: cooldown
            )
            
            try eventStore.appendToStream(id: timerId.id, expectedVersion: -1, events: timer.changes)
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
    func when(_ command: UpdateRoundTimer) async throws{
        do{
            Log.v("When (\(UpdateRoundTimer.self)):  \(command)")
            
            let timerId = TimerId(UUID())
            let timerName = try TimerName(command.name)
            let emoji = Emoji(command.emoji)
            let tint = Tint(command.tint)
            let timerType = TimerType.round
            
            let ready = try Ready(command.ready)
            let exercise = try Exercise(command.exercise)
            let rest = try Rest(command.rest)
            let round = try Round(command.round)
            let cooldown = try Cooldown(command.cooldown)
            
            try update(id: command.id) { (timer: RoundTimer) in
                timer.updateTimer(
                    timerName: timerName,
                    emoji: emoji,
                    tint: tint,
                    timerType: timerType,
                    ready: ready,
                    exercise: exercise,
                    rest: rest,
                    round: round,
                    cooldown: cooldown
                )
            }
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
    func when(_ command: DeleteRoundTimer) async throws{
        do{
            Log.v("When (\(DeleteRoundTimer.self)):   \(command)")
            
            try update(id: command.id) { (timer: RoundTimer) in
                timer.deleteTimer()
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    //MARK: SectionTimer
    
    func when(_ command: CreateSectionTimer) async throws{
        do{
            Log.v("When (\(CreateSectionTimer.self)):  \(command)")
            
            let timerId = TimerId(UUID())
            let timerName = try TimerName(command.name)
            let emoji = Emoji(command.emoji)
            let tint = Tint(command.tint)
            let timerType = try TimerType(timerType: command.timerType)
            
            let sections = try command.createSections.map {
                try TimerSection(command: $0)
            }
            let timerSections = try TimerSections(sections: sections)
            


            let timer = timerFactory.create(timerId: timerId, timerName: timerName, emoji: emoji, tint: tint, timerType: timerType, timerSections: timerSections)
            
            //section을 생성해준다.
            try eventStore.appendToStream(id: timer.timerId.id, expectedVersion: -1, events: timer.changes)
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
        
    }
    
    
    
    func when(_ command: UpdateSectionTimer) async throws{
        do{
            Log.v("When (\(UpdateSectionTimer.self)):  \(command)")
                        
            let timerName = try TimerName(command.name)
            let emoji = Emoji(command.emoji)
            let tint = Tint(command.tint)
            let sections = try command.updateSections.map {
                try TimerSection(command: $0)
            }
            let timerSections = try TimerSections(sections: sections)
            

            try update(id: command.timerId) { (timer: SectionTimer) in
                timer.updateTimer(timerName: timerName, emoji: emoji, tint: tint, timerSections: timerSections)
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
    }
    
    
    func when(_ command: DeleteSectionTimer) async throws{
        do{
            Log.v("When (\(DeleteSectionTimer.self)):   \(command)")
            
            try update(id: command.timerId) { (timer: SectionTimer) in
                timer.deleteTimer()
            }
            
            try Transaction.commit()
        }catch{
            try Transaction.rollback()
            throw error
        }
        
    }
}
