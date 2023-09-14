//
//  EventListener.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import Combine


final class EventListener {
    let eventType: String
    let publisher: PassthroughSubject<DomainEvent, Never>
    
    init(_ eventType : String) {
        self.eventType = eventType
        self.publisher = PassthroughSubject<DomainEvent, Never>()
    }
    
    func send(_ event: DomainEvent) {
        self.publisher.send(event)
    }
    
    func registerSubscription<E: DomainEvent>(action: @escaping (E) -> Void) -> AnyCancellable {
        return publisher.sink {
            guard let event = $0 as? E else { return }
            action(event)
        }
    }
    
    func registerSubscription<E: DomainEvent, S: Scheduler>(scheduler: S, action: @escaping (E) -> Void) -> AnyCancellable {
        return publisher
            .receive(on: scheduler)
            .sink {
                guard let event = $0 as? E else { return }
                action(event)
            }
    }
}


final class EventListenersRegistry {
    private(set) var listeners: [String: EventListener] = [:]
    
    
    //For Publish
    func getListener(_  event: DomainEvent) -> EventListener? {
        let type = "\(type(of: event))"
        return listeners["\(type)"]
    }
    
    //For Receive
    func getListener<E: DomainEvent>(_  event: E.Type) -> EventListener? {
        return listeners["\(event)"]
    }
    
    func createListener<E: DomainEvent>(_ event: E.Type) -> EventListener {
        let eventListener = EventListener("\(event)")
        listeners[eventListener.eventType] = eventListener
        return eventListener
    }
}
