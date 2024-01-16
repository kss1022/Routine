//
//  RoundTimerSQLDao.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import Foundation
import SQLite

final class RoundTimerSQLDao: RoundTimerDao{

    
    private let db: Connection
    private let table: Table
    
    
    //MARK: Columns
    internal static let tableName = "ROUNDTIMER"
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
        
    private let cooldownName: Expression<String>
    private let cooldownDescription: Expression<String>
    private let cooldownEmoji: Expression<String>
    private let cooldownTint: Expression<String>
    private let cooldownMin: Expression<Int>
    private let cooldownSec: Expression<Int>
    
    
    init(db: Connection) throws{
        self.db = db
        table = Table(RoundTimerSQLDao.tableName)
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
                        
            table.column(cooldownName)
            table.column(cooldownEmoji)
            table.column(cooldownDescription)
            table.column(cooldownTint)
            table.column(cooldownMin)
            table.column(cooldownSec)
                        
            table.foreignKey(timerId, references: listTable, timerId, delete: .cascade)
        })
        
        db.userVersion = 0
        Log.v("Create Table (If Not Exists): \(RoundTimerSQLDao.tableName)")
    }
    
    
    func save(_ dto: RoundTimerDto) throws {
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
                             
            cooldownName <- dto.cooldownName,
            cooldownDescription <- dto.cooldownDescription,
            cooldownEmoji <- dto.cooldownEmoji,
            cooldownTint <- dto.cooldownTint,
            cooldownMin <- dto.cooldownMin,
            cooldownSec <- dto.cooldownSec
        )
        
        
        try db.run(insert)
        Log.v("Insert \(RoundTimerDto.self): \(dto)")
    }
    
    func update(_ dto: RoundTimerDto) throws {
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
                                
            cooldownName <- dto.cooldownName,
            cooldownDescription <- dto.cooldownDescription,
            cooldownEmoji <- dto.cooldownEmoji,
            cooldownTint <- dto.cooldownTint,
            cooldownMin <- dto.cooldownMin,
            cooldownSec <- dto.cooldownSec
        )
        
        try db.run(update)
        Log.v("Update \(RoundTimerDto.self): \(dto)")
    }
    
    func find(_ id: UUID) throws -> RoundTimerDto? {
        let query = table.filter(timerId == id)
            .limit(1)
        
        return try db.pluck(query).map {
            RoundTimerDto(
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
        Log.v("Delete \(RoundTimerDto.self): \(id)")
    }
    
}
