//
//  Transaction.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import CoreData



class Transaction{
        
    private static let threadLocalContext = ThreadLocal<NSManagedObjectContext>{
        let mainContext =  try NSManagedObjectContext.mainContext()
        let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        childContext.parent = mainContext
        return childContext
    }
    
    static func context() throws -> NSManagedObjectContext{
        try threadLocalContext.get()
    }
    
    static func commit() throws{
        let context = try Transaction.context()
        if context.hasChanges{
            try context.save()
            try NSManagedObjectContext.mainContext().save()
            Log.v("Commit!")
        }

        remove()
    }

    static func rollback() throws{
        try Transaction.threadLocalContext.get().rollback()
        Log.v("Rollback")
        remove()
    }
}



extension Transaction{
    private static func remove(){
        Transaction.threadLocalContext.remove()
        //Log.v("Remove context Of ThraedLocal : \(Thread.current)")
    }
}
