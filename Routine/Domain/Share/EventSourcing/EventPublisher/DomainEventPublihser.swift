//
//  DomainEventPublihser.swift
//  Routine
//  https://github.com/mtynior/SwiftBus
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import Combine

public final class DomainEventPublihser{

    private static let eventPublisher = ThreadLocal {
        DomainEventPublihser(listenersRegistry: EventListenersRegistry())
    }
    
    static let share = try! eventPublisher.get()
    
    private let listenersRegistry: EventListenersRegistry
    
    init(listenersRegistry: EventListenersRegistry) {
        self.listenersRegistry = listenersRegistry
    }

    
    func publish<T: Event>(_ domainEvent: T){        
        let listener = listenersRegistry.getListener(domainEvent)
        listener?.send(domainEvent)
    }
    
    
    @discardableResult
    public func onReceive<E>(_ eventType: E.Type, action: @escaping (E) -> Void) -> AnyCancellable where E: Event {
        let listener: EventListener = getOrCreateEventListener(for: E.self)
        return listener.registerSubscription(action: action)
    }
    
    @discardableResult
    public func onReceive<E: Event, S: Scheduler>(_ eventType: E.Type, performOn scheduler: S, action: @escaping (E) -> Void) -> AnyCancellable {
        let listener: EventListener = getOrCreateEventListener(for: E.self)
        return listener.registerSubscription(scheduler: scheduler, action: action)
    }
}


// MARK: - helpers
private extension DomainEventPublihser {
    func getOrCreateEventListener<E: Event>(for eventType: E.Type) -> EventListener {
        guard let listener = listenersRegistry.getListener(E.self) else {
              return listenersRegistry.createListener(E.self)
          }
          return listener
      }
}
