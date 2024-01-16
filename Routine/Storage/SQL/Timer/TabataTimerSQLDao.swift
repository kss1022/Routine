//
//  TabataTimerSQLDao.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation
import SQLite


final class TabataTimerSQLDao: TabataTimerDao{

    
    private let db: Connection
    private let table: Table
    
    
    //MARK: Columns
    internal static let tableName = "TABATATIMER"
    private let timerId: Expression<UUID>
    private let name: Expression<String>
    private let emoji: Expression<String>
    private let tint: Expression<String>
    
    
    private let readyName: Expression<String>
    private let readyDescription: Expression<String>
    private let readyEmoji: Expression<String>
    private let readyTint: Expression<String>
    private let readyMin: Expression<Int>
    private let readySec: Expression<Int>
        
    private let exerciseName: Expression<String>
    private let exerciseDescription: Expression<String>
    private let exerciseEmoji: Expression<String>
    private let exerciseTint: Expression<String>
    private let exerciseMin: Expression<Int>
    private let exerciseSec: Expression<Int>
    
    private let restName: Expression<String>
    private let restDescription: Expression<String>
    private let restEmoji: Expression<String>
    private let restTint: Expression<String>
    private let restMin: Expression<Int>
    private let restSec: Expression<Int>
    
    private let roundName: Expression<String>
    private let roundDescription: Expression<String>
    private let roundEmoji: Expression<String>
    private let roundTint: Expression<String>
    private let roundRepeat: Expression<Int>
    
    private let cycleName: Expression<String>
    private let cycleDescription: Expression<String>
    private let cycleEmoji: Expression<String>
    private let cycleTint: Expression<String>
    private let cycleRepeat: Expression<Int>
    
    private let cycleRestName: Expression<String>
    private let cycleRestDescription: Expression<String>
    private let cycleRestEmoji: Expression<String>
    private let cycleRestTint: Expression<String>
    private let cycleRestMin: Expression<Int>
    private let cycleRestSec: Expression<Int>
    
    private let cooldownName: Expression<String>
    private let cooldownDescription: Expression<String>
    private let cooldownEmoji: Expression<String>
    private let cooldownTint: Expression<String>
    private let cooldownMin: Expression<Int>
    private let cooldownSec: Expression<Int>
    
    
    init(db: Connection) throws{
        self.db = db
        table = Table(TabataTimerSQLDao.tableName)
        timerId = Expression<UUID>("timerId")
        name = Expression<String>("name")
        tint = Expression<String>("tint")
        emoji = Expression<String>("emoji")
                
        readyName = Expression<String>("readyName")
        readyDescription = Expression<String>("readyDescription")
        readyEmoji = Expression<String>("readyEmoji")
        readyTint = Expression<String>("readyTint")
        readyMin = Expression<Int>("readyMin")
        readySec = Expression<Int>("readySec")
        
        exerciseName = Expression<String>("exerciseName")
        exerciseDescription = Expression<String>("exerciseDescription")
        exerciseEmoji = Expression<String>("exerciseEmoji")
        exerciseTint = Expression<String>("exerciseTint")
        exerciseMin = Expression<Int>("exerciseMin")
        exerciseSec = Expression<Int>("exerciseSec")
        
        restName = Expression<String>("restName")
        restDescription = Expression<String>("restDescription")
        restEmoji = Expression<String>("restEmoji")
        restTint = Expression<String>("restTint")
        restMin = Expression<Int>("restMin")
        restSec = Expression<Int>("restSec")
        
        roundName = Expression<String>("roundName")
        roundDescription = Expression<String>("roundDescription")
        roundEmoji = Expression<String>("roundEmoji")
        roundTint = Expression<String>("roundTint")
        roundRepeat = Expression<Int>("roundRepeat")
        
        cycleName = Expression<String>("cycleName")
        cycleDescription = Expression<String>("cycleDescription")
        cycleEmoji = Expression<String>("cycleEmoji")
        cycleTint = Expression<String>("cycleTint")
        cycleRepeat = Expression<Int>("cycleRepaet")
        
        
        cycleRestName = Expression<String>("cycleRestName")
        cycleRestDescription = Expression<String>("cycleRestDescription")
        cycleRestEmoji = Expression<String>("cycleRestEmoji")
        cycleRestTint = Expression<String>("cycleRestTint")
        cycleRestMin = Expression<Int>("cycleRestMin")
        cycleRestSec = Expression<Int>("cycleRestSec")
        
        cooldownName = Expression<String>("cooldownName")
        cooldownDescription = Expression<String>("cooldownDescription")
        cooldownEmoji = Expression<String>("cooldownEmoji")
        cooldownTint = Expression<String>("cooldownTint")
        cooldownMin = Expression<Int>("cooldownMin")
        cooldownSec = Expression<Int>("cooldownSec")
        
        try setup()
    }
    
    
    internal static func dropTable(db: Connection) throws{
        try db.execute("DROP TABLE IF EXISTS \(tableName)")
        Log.v("DROP Table: \(tableName )")
    }
    
    private func setup() throws{
        let listTable = Table(TimerListSQLDao.tableName)
        
        try db.run(table.create(ifNotExists: true){ table in
            table.column(timerId)
            table.column(name)
            table.column(emoji)
            table.column(tint)
            
            table.column(readyName)
            table.column(readyDescription)
            table.column(readyEmoji)
            table.column(readyTint)
            table.column(readyMin)
            table.column(readySec)
            
            table.column(exerciseName)
            table.column(exerciseDescription)
            table.column(exerciseEmoji)
            table.column(exerciseTint)
            table.column(exerciseMin)
            table.column(exerciseSec)
            
            table.column(restName)
            table.column(restDescription)
            table.column(restEmoji)
            table.column(restTint)
            table.column(restMin)
            table.column(restSec)
            
            table.column(roundName)
            table.column(roundDescription)
            table.column(roundEmoji)
            table.column(roundTint)
            table.column(roundRepeat)
            
            table.column(cycleName)
            table.column(cycleDescription)
            table.column(cycleEmoji)
            table.column(cycleTint)
            table.column(cycleRepeat)
            
            table.column(cycleRestName)
            table.column(cycleRestDescription)
            table.column(cycleRestEmoji)
            table.column(cycleRestTint)
            table.column(cycleRestMin)
            table.column(cycleRestSec)
            
            table.column(cooldownName)
            table.column(cooldownEmoji)
            table.column(cooldownDescription)
            table.column(cooldownTint)
            table.column(cooldownMin)
            table.column(cooldownSec)
                        
            table.foreignKey(timerId, references: listTable, timerId, delete: .cascade)
        })
        
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(TabataTimerSQLDao.tableName)")
    }
    
    
    func save(_ dto: TabataTimerDto) throws {
        let insert = table.insert(
            timerId <- dto.id,
            name <- dto.name,
            emoji <- dto.emoji,
            tint <- dto.tint,
            
            readyName <- dto.readyName,
            readyDescription <- dto.readyDescription,
            readyEmoji <- dto.readyEmoji,
            readyTint <- dto.readyTint,
            readyMin <- dto.readyMin,
            readySec <- dto.readySec,
            
            exerciseName <- dto.exerciseName,
            exerciseDescription <- dto.exerciseDescription,
            exerciseEmoji <- dto.exerciseEmoji,
            exerciseTint <- dto.exerciseTint,
            exerciseMin <- dto.exerciseMin,
            exerciseSec <- dto.exerciseSec,
            
            restName <- dto.restName,
            restDescription <- dto.restDescription,
            restEmoji <- dto.restEmoji,
            restTint <- dto.restTint,
            restMin <- dto.restMin,
            restSec <- dto.restSec,
            
            roundName <- dto.roundName,
            roundDescription <- dto.roundDescription,
            roundEmoji <- dto.roundEmoji,
            roundTint <- dto.roundTint,
            roundRepeat <- dto.roundRepeat,
            restMin <- dto.restMin,
            restSec <- dto.restSec,
            
            cycleName <- dto.cycleName,
            cycleDescription <- dto.cycleDescription,
            cycleEmoji <- dto.cycleEmoji,
            cycleTint <- dto.cycleTint,
            roundRepeat <- dto.cycleRepeat,
            cycleRepeat <- dto.cycleRepeat,
            
            cycleRestName <- dto.cycleRestName,
            cycleRestDescription <- dto.cycleRestDescription,
            cycleRestEmoji <- dto.cycleRestEmoji,
            cycleRestTint <- dto.cycleRestTint,
            cycleRestMin <- dto.cycleRestMin,
            cycleRestSec <- dto.cycleRestSec,
            
            cooldownName <- dto.cooldownName,
            cooldownDescription <- dto.cooldownDescription,
            cooldownEmoji <- dto.cooldownEmoji,
            cooldownTint <- dto.cooldownTint,
            cooldownMin <- dto.cooldownMin,
            cooldownSec <- dto.cooldownSec
        )
        
        
        try db.run(insert)
        Log.v("Insert \(TabataTimerDto.self): \(dto)")
    }
    
    func update(_ dto: TabataTimerDto) throws {
        let query = table.filter(timerId == dto.id)
            .limit(1)
        
        let update = query.update(
            timerId <- dto.id,
            name <- dto.name,
            emoji <- dto.emoji,
            tint <- dto.tint,
            
            readyName <- dto.readyName,
            readyDescription <- dto.readyDescription,
            readyEmoji <- dto.readyEmoji,
            readyTint <- dto.readyTint,
            readyMin <- dto.readyMin,
            readySec <- dto.readySec,
            
            exerciseName <- dto.exerciseName,
            exerciseDescription <- dto.exerciseDescription,
            exerciseEmoji <- dto.exerciseEmoji,
            exerciseTint <- dto.exerciseTint,
            exerciseMin <- dto.exerciseMin,
            exerciseSec <- dto.exerciseSec,
            
            restName <- dto.restName,
            restDescription <- dto.restDescription,
            restEmoji <- dto.restEmoji,
            restTint <- dto.restTint,
            restMin <- dto.restMin,
            restSec <- dto.restSec,
            
            roundName <- dto.roundName,
            roundDescription <- dto.roundDescription,
            roundEmoji <- dto.roundEmoji,
            roundTint <- dto.roundTint,
            roundRepeat <- dto.roundRepeat,
            restMin <- dto.restMin,
            restSec <- dto.restSec,
            
            cycleName <- dto.cycleName,
            cycleDescription <- dto.cycleDescription,
            cycleEmoji <- dto.cycleEmoji,
            cycleTint <- dto.cycleTint,
            roundRepeat <- dto.cycleRepeat,
            cycleRepeat <- dto.cycleRepeat,
            
            cycleRestName <- dto.cycleRestName,
            cycleRestDescription <- dto.cycleRestDescription,
            cycleRestEmoji <- dto.cycleRestEmoji,
            cycleRestTint <- dto.cycleRestTint,
            cycleRestMin <- dto.cycleRestMin,
            cycleRestSec <- dto.cycleRestSec,
            
            cooldownName <- dto.cooldownName,
            cooldownDescription <- dto.cooldownDescription,
            cooldownEmoji <- dto.cooldownEmoji,
            cooldownTint <- dto.cooldownTint,
            cooldownMin <- dto.cooldownMin,
            cooldownSec <- dto.cooldownSec
        )
        
        try db.run(update)
        Log.v("Update \(TabataTimerDto.self): \(dto)")
    }
    
    func find(_ id: UUID) throws -> TabataTimerDto? {
        let query = table.filter(timerId == id)
            .limit(1)
        
        return try db.pluck(query).map {
            TabataTimerDto(
                id: $0[timerId],
                name: $0[name],
                emoji: $0[emoji],
                tint: $0[tint],
                
                readyName: $0[readyName],
                readyDescription: $0[readyDescription],
                readyEmoji: $0[readyEmoji],
                readyTint: $0[readyTint],
                readyMin: $0[readyMin],
                readySec: $0[readySec],
                
                exerciseName: $0[exerciseName],
                exerciseDescription: $0[exerciseDescription],
                exerciseEmoji: $0[exerciseEmoji],
                exerciseTint: $0[exerciseTint],
                exerciseMin: $0[exerciseMin],
                exerciseSec: $0[exerciseSec],
                
                restName: $0[restName],
                restDescription: $0[restDescription],
                restEmoji: $0[restEmoji],
                restTint: $0[restTint],
                restMin: $0[restMin],
                restSec: $0[restSec],
                
                roundName: $0[roundName],
                roundDescription: $0[roundDescription],
                roundEmoji: $0[roundEmoji],
                roundTint: $0[roundTint],
                roundRepeat: $0[roundRepeat],
                                
                cycleName: $0[cycleName],
                cycleDescription: $0[cycleDescription],
                cycleEmoji: $0[cycleEmoji],
                cycleTint: $0[cycleTint],
                cycleRepeat: $0[cycleRepeat],
                
                cycleRestName: $0[cycleRestName],
                cycleRestDescription: $0[cycleRestDescription],
                cycleRestEmoji: $0[cycleRestEmoji],
                cycleRestTint: $0[cycleRestTint],
                cycleRestMin: $0[cycleRestMin],
                cycleRestSec: $0[cycleRestSec],
                
                cooldownName: $0[cooldownName],
                cooldownDescription: $0[cooldownDescription],
                cooldownEmoji: $0[cooldownEmoji],
                cooldownTint: $0[cooldownTint],
                cooldownMin: $0[cooldownMin],
                cooldownSec: $0[cooldownSec]
            )
        }
    }

    
    func delete(_ id: UUID) throws {
        let query = table.filter(timerId == id)
            .limit(1)
        
        try db.run(query.delete())
        Log.v("Delete \(TabataTimerDto.self): \(id)")
    }
    
}
