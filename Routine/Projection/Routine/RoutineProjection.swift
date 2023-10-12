//
//  RoutineProjection.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation
import Combine


final class RoutineProjection{
        
    
    private let routineListDao: RoutineListDao
    private let routineDetailDao: RoutineDetailDao
    private let repeatDao: RepeatDao
    
    private var cancellables: Set<AnyCancellable>

    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseError.couldNotGetDatabaseManagerInstance
        }
        
        routineListDao = dbManager.routineListDao
        routineDetailDao = dbManager.routineDetailDao
        repeatDao = dbManager.repeatDao
        
        cancellables = .init()
        
        registerReciver()
    }
    

    
    func registerReciver(){
        DomainEventPublihser.share
            .onReceive(RoutineCreated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.share
            .onReceive(RoutineUpdated.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.share
            .onReceive(RoutineNameChanged.self, action: when)
            .store(in: &cancellables)
        
        DomainEventPublihser.share
            .onReceive(RoutineDeleted.self, action: when)
            .store(in: &cancellables)
    }
    
    
    func when(event: RoutineCreated){
        do{
            let routineList = RoutineListDto(
                routineId: event.routineId.id,
                routineName: event.routineName.name,
                routineDescription: event.routineDescription.description,
                repeatType: RepeatTypeDto(event.repeat.repeatType),
                repeatValue: RepeatValueDto(event.repeat.repeatValue),
                emojiIcon: event.emoji.emoji,
                tint: event.tint.color,
                sequence: 0
            )
            
            let routineDetail = RoutineDetailDto(
                routineId: event.routineId.id,
                routineName: event.routineName.name,
                routineDescription: event.routineDescription.description,
                repeatType: RepeatTypeDto(event.repeat.repeatType),
                repeatValue: RepeatValueDto(event.repeat.repeatValue),
                emojiIcon: event.emoji.emoji,
                tint: event.tint.color,
                updatedAt: event.occurredOn
            )
            
            let `repeat` = RepeatDto(
                routineId: event.routineId.id,
                repeatType: RepeatTypeDto(event.repeat.repeatType),
                repeatValue: RepeatValueDto(event.repeat.repeatValue)
            )
            
            try routineListDao.save(routineList)
            try routineDetailDao.save(routineDetail)
            try repeatDao.save(`repeat`)
        }catch{
            Log.e("EventHandler Error: RoutineCreated \(error)")
        }
    }
    
    func when(event: RoutineUpdated){
        do{
            let routineList = RoutineListDto(
                routineId: event.routineId.id,
                routineName: event.routineName.name,
                routineDescription: event.routineDescription.description,
                repeatType: RepeatTypeDto(event.repeat.repeatType),
                repeatValue: RepeatValueDto(event.repeat.repeatValue),
                emojiIcon: event.emoji.emoji,
                tint: event.tint.color,
                sequence: 0
            )
            
            let routineDetail = RoutineDetailDto(
                routineId: event.routineId.id,
                routineName: event.routineName.name,
                routineDescription: event.routineDescription.description,
                repeatType: RepeatTypeDto(event.repeat.repeatType),
                repeatValue: RepeatValueDto(event.repeat.repeatValue),
                emojiIcon: event.emoji.emoji,
                tint: event.tint.color,
                updatedAt: event.occurredOn
            )
            
            try routineListDao.update(routineList)
            try routineDetailDao.update(routineDetail)
        }catch{
            Log.e("EventHandler Error: RoutineUpdated \(error)")
        }
    }
    
    
    func when(event: RoutineNameChanged){
        do{
            let routineId = event.routineId.id
            let changedName = event.routineName.name
            
            try routineListDao.updateName(routineId, name: changedName)
            try routineDetailDao.updateName(routineId, name: changedName)
        }catch{
            Log.e("EventHandler Error: RoutineNameChanged \(error)")
        }
    }
    
    func when(event: RoutineDeleted){
        do{
            let routineId = event.routineId.id
            try routineListDao.delete(routineId)
            try routineDetailDao.delete(routineId)
        }catch{
            Log.e("EventHandler Error: RoutineDeleted \(error)")
        }
    }
    
    
}
