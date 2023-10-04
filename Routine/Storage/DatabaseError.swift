//
//  DatabaseError.swift
//  Routine
//
//  Created by 한현규 on 10/4/23.
//

import Foundation



enum DatabaseError: Error{
    case couldNotFindPathToCreateDatabasePath
    case couldNotGetDatabaseManagerInstance
}
