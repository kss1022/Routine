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
    private let timerCountdownDao: TimerCountdownDao
    private let timerSectionListDao: TimerSectionListDao
    
    
    private var cancellables: Set<AnyCancellable>

    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        timerListDao = dbManager.timerListDao
        timerCountdownDao = dbManager.timerCountdownDao
        timerSectionListDao = dbManager.timerSectionListDao
        
        cancellables = .init()
        
        registerReceiver()
    }
    
    private func registerReceiver(){
        DomainEventPublihser.shared
            .onReceive(SectionTimerCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(FocusTimerCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(SectionTimerUpdated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(FocusTimerUpdated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(SectionTimerDeleted.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.shared
            .onReceive(FocusTimerDeleted.self, action: when)
            .store(in: &cancellables)
    }
    
    
    private func when(event: SectionTimerCreated){
        do{
            
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
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
    
    private func when(event: FocusTimerCreated){
        do{
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
                timerType: event.timerType
            )
            
            let timerCountdown = TimerCountdownDto(
                timerId: event.timerId.id,
                minute: event.timerCountdown.min
            )
            
               
            try timerListDao.save(timerList)
            try timerCountdownDao.save(timerCountdown)
        }catch{
            Log.e("EventHandler Error: FocusTimerCreated \(error)")
        }
    }
    
    private func when(event: SectionTimerUpdated){
        do{
            
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
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
    
    private func when(event: FocusTimerUpdated){
        do{
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
                timerType: event.timerType
            )
            
            let timerCountdown = TimerCountdownDto(
                timerId: event.timerId.id,
                minute: event.timerCountdown.min
            )
            
               
            try timerListDao.update(timerList)
            try timerCountdownDao.update(timerCountdown)
        }catch{
            Log.e("EventHandler Error: FocusTimerUpdated \(error)")
        }
    }
    
    private func when(event: SectionTimerDeleted){
        do{
            let timerId = event.timerId.id
            
            try timerListDao.delete(timerId)
            try timerSectionListDao.delete(timerId)
        }catch{
            Log.e("EventHandler Error: SectionTimerDeleted \(error)")
        }
    }
    
    private func when(event: FocusTimerDeleted){
        do{
            let timerId = event.timerId.id
            
            try timerListDao.delete(timerId)
            try timerCountdownDao.delete(timerId)
            
        }catch{
            Log.e("EventHandler Error: FocusTimerDeleted \(error)")
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


