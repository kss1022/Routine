//
//  CoreDataUtils.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//


import UIKit
import CoreData




extension NSManagedObjectContext{
    static func mainContext() throws -> NSManagedObjectContext{
        var mainContext: NSManagedObjectContext?
        
        DispatchQueue.main.async {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            mainContext = delegate?.persistentContainer.viewContext
        }
        
        if mainContext == nil{
            throw DBError.CoreDataError(reason: "Main Context nil")
        }

        return mainContext!
    }
}
