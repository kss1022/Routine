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
    public let routineWeekRecordDao: RoutineWeekRecordDao
    public let routineStreakDao: RoutineStreakDao
    public let routineRecordDao: RoutineRecordDao
    public let routineTopAcheiveDao: RoutineTopAcheiveDao
            
    public let timerTotalRecordDao: TimerTotalRecordDao
    public let timerMonthRecordDao: TimerMonthRecordDao
    public let timerWeekRecordDao: TimerWeekRecordDao
    public let timerRecordDao: TimerRecordDao
    public let timerStreakDao: TimerStreakDao
    
    public let timerListDao: TimerListDao
    public let focusTimerDao: FocusTimerDao
    public let tabataTimerDao: TabataTimerDao
    public let roundTimerDao: RoundTimerDao
    public let timerSectionListDao: TimerSectionListDao
        
    public let profileDao: ProfileDao
    
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
        //        try FocusTimerSQLDao.dropTable(db: db)
        //        try TabataTimerSQLDao.dropTable(db: db)
        //        try RoundTimerSQLDao.dropTable(db: db)
        //        try TimerCountdownSQLDao.dropTable(db: db)
        //        try TimerSectionListSQLDao.dropTable(db: db)
        //
        //        try RoutineTotalRecordSQLDao.dropTable(db: db)
        //        try RoutineMonthRecordSQLDao.dropTable(db: db)
        //        try RoutineWeekRecordSQLDao.dropTable(db: db)
        //        try RoutineStreakSQLDao.dropTable(db: db)
        //        try RoutineRecordSQLDao.dropTable(db: db)
        
        //        try TimerTotalRecordSQLDao.dropTable(db: db)
        //        try TimerMonthRecordSQLDao.dropTable(db: db)
        //        try TimerWeekRecordSQLDao.dropTable(db: db)
        //        try TimerStreakSQLDao.dropTable(db: db)
        //        try TimerRecordSQLDao.dropTable(db: db)
#endif
        let routineListSQLDao = try RoutineListSQLDao(db: db)
        self.routineListDao = routineListSQLDao
        self.routineDetailDao = try RoutineDetailSQLDao(db: db)
        self.repeatDao = try RepeatSQLDao(db: db)
        self.reminderDao = try ReminderSQLDao(db: db)
        
        self.timerListDao = try TimerListSQLDao(db: db)
        self.focusTimerDao = try FocusTimerSQLDao(db: db)
        self.tabataTimerDao = try TabataTimerSQLDao(db: db)
        self.roundTimerDao = try RoundTimerSQLDao(db: db)
        self.timerSectionListDao = try TimerSectionListSQLDao(db: db)

        self.routineTotalRecordDao = try RoutineTotalRecordSQLDao(db: db)
        self.routineMonthRecordDao = try RoutineMonthRecordSQLDao(db: db)
        self.routineWeekRecordDao = try RoutineWeekRecordSQLDao(db: db)
        self.routineStreakDao = try RoutineStreakSQLDao(db: db)
        self.routineRecordDao = try RoutineRecordSQLDao(db: db)
        
        self.timerTotalRecordDao = try TimerTotalRecordSQLDao(db: db)
        self.timerMonthRecordDao = try TimerMonthRecordSQLDao(db: db)
        self.timerWeekRecordDao = try TimerWeekRecordSQLDao(db: db)
        self.timerStreakDao = try TimerStreakSQLDao(db: db)
        self.timerRecordDao = try TimerRecordSQLDao(db: db)        
        
        self.profileDao = ProfilepPreferencesDao(preferenceStorage: PreferenceStorage.shared)
        
        //Join
        self.routineTopAcheiveDao = RoutineTopAcheiveSQLDao(db: db)
    }
    
}


