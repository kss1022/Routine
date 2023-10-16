//
//  DatabaseException.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation



enum DatabaseException: Error{
    case couldNotFindPathToCreateDatabasePath
    case couldNotGetDatabaseManagerInstance
}
