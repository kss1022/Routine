//
//  AppendOnlyStore.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import CoreData


protocol AppendOnlyStore{
    func append(name:String, data : Data, expectedVersion: Int)  throws
    func append(name:String, datas : [Data], expectedVersion: Int)  throws
    func readRecord(name : String , afterVersion: Int?, maxCounut: Int?) throws -> [DataWithVersion]
    func readRecord(afterVersion: Int?, maxCount: Int?) throws -> [DataWithName]
    func close()
}



final class DataWithVersion{
    let version: Int
    let data : Data
    
    init(version: Int, data: Data) {
        self.version = version
        self.data = data
    }
    
    
    init(_ event : EventEntity){
        self.version = Int(event.version)
        self.data = event.data!
    }
}

final class DataWithName{
    let name: String
    let data: [Data]

    init(name: String, data: [Data]) {
        self.name = name
        self.data = data
    }

}
