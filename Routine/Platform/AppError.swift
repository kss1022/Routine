//
//  AppError.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation



class ArgumentException : Error{
    let msg : String
    
    init(_ predicateFormat: String, _ args: CVarArg...) {
        self.msg = String(format: predicateFormat, [args])
    }
}



enum RepositoryError: Error{
    case decodeError( type: String , reason: String)
}
