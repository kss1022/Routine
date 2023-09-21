//
//  DatabaseManager.swift
//  Routine
//  https://github.com/stephencelis/SQLite.swift/blob/master/Documentation/Index.md#sqliteswift-documentation
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
    
    private init() throws {
        guard let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else{
            throw DatabaseError.couldNotFindPathToCreateDatabasePath
        }
        
        let path = (directoryPath as NSString).appendingPathComponent("RoutineDB.sqlite3")
        Log.d("RoutineSQLitePath \(path)")
        
        db = try Connection(path)
        
#if DEBUG
        try RoutineListSQLDao.dropTable(db: db)
        try RoutineDetailSQLDao.dropTable(db: db)        
#endif
        
        self.routineListDao = try RoutineListSQLDao(db: db)
        self.routineDetailDao = try RoutineDetailSQLDao(db: db)
    }
    
}



enum DatabaseError: Error{
    case couldNotFindPathToCreateDatabasePath
    case couldNotGetDatabaseManagerInstance
}
