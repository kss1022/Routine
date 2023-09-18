//
//  Specification.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation


class Specification<T>{
    func isSatisfiedBy(_ canidate: T) -> Bool {
        fatalError("You must overide this func")
    }
    
    func and(_ other: Specification) -> Specification{
        AndSpecification<T>(self, other)
    }
    func or(_ other: Specification) -> Specification{
        OrSpecification<T>(self, other)
    }
    func not() -> Specification{
        NotSpecification<T>(self)
    }
    
    func subsumes(_ other: Specification) -> Bool{
        fatalError("You must overide this func")
    }
}

class CompositeSpecification<T> : Specification<T>{
    
    let specification : [Specification<T>]
    
    init(specification: [Specification<T>]) {
        self.specification = specification
    }
    
    func leafSpecfications() -> [Specification<T>]{
        specification
    }
    
}

class AndSpecification<T>: Specification<T>{
    let one: Specification<T>
    let other: Specification<T>
    
    init(_ one: Specification<T>,_ two: Specification<T>) {
        self.one = one
        self.other = two
    }
    
    override func isSatisfiedBy(_ canidate: T) -> Bool {
        one.isSatisfiedBy(canidate) && other.isSatisfiedBy(canidate)
    }
}


class OrSpecification<T>: Specification<T>{
    let one: Specification<T>
    let other: Specification<T>
    
    init(_ one: Specification<T>,_ two: Specification<T>) {
        self.one = one
        self.other = two
    }
    
    override func isSatisfiedBy(_ canidate: T) -> Bool {
        one.isSatisfiedBy(canidate) || other.isSatisfiedBy(canidate)
    }
}

class NotSpecification<T>: Specification<T>{
    let wrapped: Specification<T>
        
    init(_ x: Specification<T>) {
        self.wrapped = x
    }
    
    override func isSatisfiedBy(_ canidate: T) -> Bool {
        !wrapped.isSatisfiedBy(canidate)
    }
}
