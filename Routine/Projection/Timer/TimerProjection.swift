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
    private let timerSectionListDao: TimerSectionListDao
    
    private var cancellables: Set<AnyCancellable>

    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
        
        timerListDao = dbManager.timerListDao
        timerSectionListDao = dbManager.timerSectionListDao
        
        cancellables = .init()
        
        registerReceiver()
    }
    
    private func registerReceiver(){
        DomainEventPublihser.share
            .onReceive(TimerCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.share
            .onReceive(TimerUpdated.self, action: when)
            .store(in: &cancellables)
    }
    
    
    private func when(event: TimerCreated){
        do{
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
                timerType: TimerTypeDto(timerType: event.timerType)
            )
            
            let timerSections = event.timerSections.map{
                TimerSectionListDto(
                    timerId: event.timerId.id,
                    sectionName: $0.sectionName.name,
                    sectionDescription: $0.sectionDescription.description,
                    timerSectionType: TimerSectionTypeDto($0.timerSectionType),
                    timerSectionValue: TimerSectionValueDto($0.timerSectionValue),
                    sequence: $0.sequence.sequence,
                    emoji: $0.emoji.emoji,
                    tint: $0.tint?.color
                )
            }
            
            try timerListDao.save(timerList)
            try timerSectionListDao.save(timerSections)
        }catch{
            Log.e("EventHandler Error: TimerCreated \(error)")
        }
    }
    
    private func when(event: TimerUpdated){
        do{
            let timerList = TimerListDto(
                timerId: event.timerId.id,
                timerName: event.timerName.name,
                timerType: TimerTypeDto(timerType: event.timerType)
            )
            
            try timerListDao.update(timerList)
        }catch{
            Log.e("EventHandler Error: TimerUpdated \(error)")
        }
    }
    
    
}


