//
//  TimerProjection.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import Foundation
import Combine


final class TimerProjection{
    
    private let timerListDao: TimerListDao
    private let focusTimerDao: FocusTimerDao
    private let tabataTimerDao: TabataTimerDao
    private let roundTimerDao: RoundTimerDao
    private let timerSectionListDao: TimerSectionListDao
    
    
    private var cancellables: Set<AnyCancellable>

    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        timerListDao = dbManager.timerListDao
        focusTimerDao =  dbManager.focusTimerDao
        tabataTimerDao = dbManager.tabataTimerDao
        roundTimerDao = dbManager.roundTimerDao
        timerSectionListDao = dbManager.timerSectionListDao
        
        cancellables = .init()
        
        registerReceiver()
    }
    
    private func registerReceiver(){
        //FocusTimer
        DomainEventPublihser.shared
            .onReceive(FocusTimerCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(FocusTimerUpdated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(FocusTimerDeleted.self, action: when)
            .store(in: &cancellables)
        
        //TabataTimer
        DomainEventPublihser.shared
            .onReceive(TabataTimerCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(TabataTimerUpdated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(TabataTimerDeleted.self, action: when)
            .store(in: &cancellables)
        
        //RoundTimer
        DomainEventPublihser.shared
            .onReceive(RoundTimerCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(RoundTimerUpdated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(RoundTimerDeleted.self, action: when)
            .store(in: &cancellables)
                
        //SectionTimer
        DomainEventPublihser.shared
            .onReceive(SectionTimerCreated.self, action: when)
            .store(in: &cancellables)
                
        DomainEventPublihser.shared
            .onReceive(SectionTimerUpdated.self, action: when)
            .store(in: &cancellables)
                
        DomainEventPublihser.shared
            .onReceive(SectionTimerDeleted.self, action: when)
            .store(in: &cancellables)
    }
    
    
    //MARK: FocusTimer
    private func when(event: FocusTimerCreated){
        do{
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
                emoji: event.emoji.emoji,
                tint: event.tint.color,
                timerType: event.timerType
            )
            
            let focusTimer = FocusTimerDto(
                id: event.timerId.id,
                name: event.timerName.name,
                emoji: event.emoji.emoji,
                tint: event.tint.color,
                minutes: event.minutes.min
            )
            
                  
            try timerListDao.save(timerList)            
            try focusTimerDao.save(focusTimer)
        }catch{
            Log.e("EventHandler Error: FocusTimerCreated \(error)")
        }
    }
    
    
    private func when(event: FocusTimerUpdated){
        do{
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
                emoji: event.emoji.emoji,
                tint: event.tint.color,
                timerType: event.timerType
            )
            
            let focusTimer = FocusTimerDto(
                id: event.timerId.id,
                name: event.timerName.name,
                emoji: event.emoji.emoji,
                tint: event.tint.color,
                minutes: event.minutes.min
            )
            
               
            try timerListDao.update(timerList)
            try focusTimerDao.update(focusTimer)
        }catch{
            Log.e("EventHandler Error: FocusTimerUpdated \(error)")
        }
    }
    
    
    private func when(event: FocusTimerDeleted){
        do{
            let timerId = event.timerId.id
            
            try timerListDao.delete(timerId)
            //try focusTimerDao.delete(timerId)
        }catch{
            Log.e("EventHandler Error: FocusTimerDeleted \(error)")
        }
    }
    
    
    //MARK: TabataTimer
    
    private func when(event: TabataTimerCreated){
        do{
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
                emoji: event.emoji.emoji,
                tint: event.tint.color,
                timerType: event.timerType
            )
            
            let tabatTimer = TabataTimerDto(event)
            
            try timerListDao.save(timerList)
            try tabataTimerDao.save(tabatTimer)
        }catch{
            Log.e("EventHandler Error: TabataTimerCreated \(error)")
        }
    }
    
    private func when(event: TabataTimerUpdated){
        do{
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
                emoji: event.emoji.emoji,
                tint: event.tint.color,
                timerType: event.timerType
            )
            
            let tabatTimer = TabataTimerDto(event)
            
            try timerListDao.update(timerList)
            try tabataTimerDao.update(tabatTimer)
        }catch{
            Log.e("EventHandler Error: TabataTimerUpdated \(error)")
        }
    }
    
    private func when(event: TabataTimerDeleted){
        do{
            let id = event.timerId.id
            try timerListDao.delete(id)
            //try tabataTimerDao.delete(id)
        }catch{
            Log.e("EventHandler Error: TabataTimerDeleted \(error)")
        }
    }
    
    //MARK: RoundTimer
    
    private func when(event: RoundTimerCreated){
        do{
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
                emoji: event.emoji.emoji,
                tint: event.tint.color,
                timerType: event.timerType
            )
            
            let tabatTimer = RoundTimerDto(event)
            
            try timerListDao.save(timerList)
            try roundTimerDao.save(tabatTimer)
        }catch{
            Log.e("EventHandler Error: RoundTimerCreated \(error)")
        }
    }
    
    private func when(event: RoundTimerUpdated){
        do{
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
                emoji: event.emoji.emoji,
                tint: event.tint.color,
                timerType: event.timerType
            )
            
            let tabatTimer = RoundTimerDto(event)
            
            try timerListDao.update(timerList)
            try roundTimerDao.update(tabatTimer)
        }catch{
            Log.e("EventHandler Error: RoundTimerUpdated \(error)")
        }
    }
    
    private func when(event: RoundTimerDeleted){
        do{
            let id = event.timerId.id
            try timerListDao.delete(id)
            //try roundTimerDao.delete(id)
        }catch{
            Log.e("EventHandler Error: RoundTimerDeleted \(error)")
        }
    }

    
    //MARK: SectionTimer
    private func when(event: SectionTimerCreated){
        do{
            
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
                emoji: event.emoji.emoji,
                tint: event.tint.color,
                timerType: event.timerType
            )
            
                                    

            let timerSections = sectionDtos(
                timerId: event.timerId,
                sections: event.timerSections
            )
            
            
               
            try timerListDao.save(timerList)
            try timerSectionListDao.save(timerSections)
        }catch{
            Log.e("EventHandler Error: SectionTimerCreated \(error)")
        }
    }
    
    
    private func when(event: SectionTimerUpdated){
        do{
            
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
                emoji: event.emoji.emoji,
                tint: event.tint.color,
                timerType: event.timerType
            )
            
                                    

            let timerSections = sectionDtos(
                timerId: event.timerId,
                sections: event.timerSections
            )
            
            
               
            try timerListDao.update(timerList)
            try timerSectionListDao.update(timerSections)
        }catch{
            Log.e("EventHandler Error: SectionTimerUpdated \(error)")
        }
    }
   
    
    private func when(event: SectionTimerDeleted){
        do{
            let timerId = event.timerId.id
            
            try timerListDao.delete(timerId)
            //try timerSectionListDao.delete(timerId)
        }catch{
            Log.e("EventHandler Error: SectionTimerDeleted \(error)")
        }
    }
 
}


private extension TimerProjection{
    
    func sectionDtos(timerId: TimerId, sections: TimerSections) -> [TimerSectionListDto]{
        let ready = TimerSectionListDto(timerId: timerId, section: sections.ready)
        let exercise = TimerSectionListDto(timerId: timerId, section: sections.exercise)
        let rest = TimerSectionListDto(timerId: timerId, section: sections.rest)
        let round = TimerSectionListDto(timerId: timerId, section: sections.round)
        let cycle = sections.cycle.flatMap { TimerSectionListDto(timerId: timerId, section: $0) }
        let cycleRest = sections.cycleRest.flatMap { TimerSectionListDto(timerId: timerId, section: $0) }
        let cooldown = TimerSectionListDto(timerId: timerId, section: sections.cooldown)
        return [ ready, exercise, rest, round, cycle , cycleRest, cooldown ].compactMap { $0 }
    }
}


