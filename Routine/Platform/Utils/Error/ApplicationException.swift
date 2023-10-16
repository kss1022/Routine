//
//  ApplicationException.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation




class ApplicationException: Error{
    var message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    init(_ predicateFormat: String, _ args: CVarArg...) {
        self.message = String(format: predicateFormat, [args])
    }
}

//Repository에서 일어나는 에러입니다.
class RepositoryException: ApplicationException{   
}
