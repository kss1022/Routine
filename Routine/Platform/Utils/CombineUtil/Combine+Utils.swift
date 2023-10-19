//
//  Combine+Utils.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import Combine
import CombineExt


public class ReadOnlyCurrentValuePublisher<Element>: Publisher {
  
  public typealias Output = Element
  public typealias Failure = Never
  
  public var value: Element {
    currentValueRelay.value
  }
  
  fileprivate let currentValueRelay: CurrentValueRelay<Output>
  
  fileprivate init(_ initialValue: Element) {
    currentValueRelay = CurrentValueRelay(initialValue)
  }
  
  public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Element == S.Input {
    currentValueRelay.receive(subscriber: subscriber)
  }
  
}

public final class CurrentValuePublisher<Element>: ReadOnlyCurrentValuePublisher<Element> {
  
  typealias Output = Element
  typealias Failure = Never
  
  public override init(_ initialValue: Element) {
    super.init(initialValue)
  }

  public func send(_ value: Element) {
    currentValueRelay.accept(value)
  }
  
}


public class ReadOnlyPassthroughPublisher<Element>: Publisher {
    
    public typealias Output = Element
    public typealias Failure = Never
        
//    public var value: Element? {
//        passthroughRelay.value
//    }
    
    fileprivate let passthroughRelay: PassthroughRelay<Output>
    
    fileprivate init() {
        passthroughRelay = PassthroughRelay()
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Element == S.Input {
        passthroughRelay.receive(subscriber: subscriber)
    }
    
}

public final class PassthroughPublisher<Element>: ReadOnlyPassthroughPublisher<Element> {
  
  typealias Output = Element
  typealias Failure = Never
  
  public override init() {
    super.init()
  }

  public func send(_ value: Element) {
      passthroughRelay.accept(value)
  }
  
}


extension Task {
    func store(in set: inout Set<AnyCancellable>) {
        set.insert(AnyCancellable(cancel))
    }
}
