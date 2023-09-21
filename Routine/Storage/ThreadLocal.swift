//
//  ThreadLocal.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation



public class ThreadLocal<T>: NSObject, NSCopying{
    private let mCreate: () throws -> T

    public init(create: @escaping () throws -> T) {
        mCreate = create
    }

    public func get()  throws -> T {
        let threadDictionary = Thread.current.threadDictionary
        if let cachedObject = threadDictionary[self] as? T {
            return cachedObject
        } else {
            let newObject = try mCreate()
            threadDictionary.setObject(newObject, forKey: self)
            return newObject
        }
    }

    public func set(_ newObject: T) {
        let threadDictionary = Thread.current.threadDictionary
        threadDictionary.setObject(newObject, forKey: self)
    }

    public func remove() {
        let threadDictionary = Thread.current.threadDictionary
        threadDictionary.removeObject(forKey: self)
    }

    public func copy(with zone: NSZone? = nil) -> Any {
        self
    }
}
