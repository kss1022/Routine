//
//  DatabaseManager.swift
//  Routine
//  https://github.com/stephencelis/SQLite.swift/blob/master/Documentation/Index.md#sqliteswift-documentation
//
//  https://www.sqlite.org/foreignkeys.html#fk_actions
//  Created by 한현규 on 2023/09/21.
//

import Foundation
import SQLite



class DatabaseManager{
    
    
    // MARK: Private
    private let db : Connection
    
    // MARK: Public
    public static let `default` = try? DatabaseManager()
    public let routineListDao: RoutineListDao
    public let routineDetailDao: RoutineDetailDao
    public let repeatDao: RepeatDao
    public let reminderDao: ReminderDao
        
    public let routineTotalRecordDao: RoutineTotalRecordDao
    public let routineMonthRecordDao: RoutineMonthRecordDao
    public let routineRecordDao: RoutineRecordDao
    public let timerRecordDao: TimerRecordDao
    
    public let timerListDao: TimerListDao
    public let timerCountdownDao: TimerCountdownDao
    public let timerSectionListDao: TimerSectionListDao
    
    private init() throws {
        guard let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else{
            throw DatabaseException.couldNotFindPathToCreateDatabasePath
        }
        
        let path = (directoryPath as NSString).appendingPathComponent("RoutineDB.sqlite3")
        Log.d("RoutineSQLitePath \(path)")
        
        db = try Connection(path)
        db.foreignKeys = true
        
#if DEBUG
        //        try RoutineListSQLDao.dropTable(db: db)
        //        try RoutineDetailSQLDao.dropTable(db: db)
        //        try RepeatSQLDao.dropTable(db: db)
        //        try ReminderSQLDao.dropTable(db: db)
        //
        //        try TimerListSQLDao.dropTable(db: db)
        //        try TimerCountdownSQLDao.dropTable(db: db)
        //        try TimerSectionListSQLDao.dropTable(db: db)
        //
        //        try RoutineTotalRecordSQLDao.dropTable(db: db)
        //        try RoutineMonthRecordSQLDao.dropTable(db: db)
        //        try RoutineRecordSQLDao.dropTable(db: db)
        //        try TimerRecordSQLDao.dropTable(db: db)
#endif
        
        self.routineListDao = try RoutineListSQLDao(db: db)
        self.routineDetailDao = try RoutineDetailSQLDao(db: db)
        self.repeatDao = try RepeatSQLDao(db: db)
        self.reminderDao = try ReminderSQLDao(db: db)
        
        self.timerListDao = try TimerListSQLDao(db: db)
        self.timerCountdownDao = try TimerCountdownSQLDao(db: db)
        self.timerSectionListDao = try TimerSectionListSQLDao(db: db)

        self.routineTotalRecordDao = try RoutineTotalRecordSQLDao(db: db)
        self.routineMonthRecordDao = try RoutineMonthRecordSQLDao(db: db)
        self.routineRecordDao = try RoutineRecordSQLDao(db: db)
        self.timerRecordDao = try TimerRecordSQLDao(db: db)
    }
    
}


