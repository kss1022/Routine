//
//  RoutineProjection.swift
//  Routine
//
//  Created by 한현규 on 2023/09/18.
//

import Foundation
import Combine


// TODO: Projection  데이터 재구성 및 ReadModel 구현

final class RoutineProjection{
    
    var cancellables: Set<AnyCancellable>
    
    init(){
        cancellables = .init()
        registerReciver()
    }
    
    func registerReciver(){
        DomainEventPublihser.share.onReceive(RoutineCreated.self, performOn: DispatchQueue.global()) { event in
            Log.v("\(event.routineName.name)")
        }
        .store(in: &cancellables)
    }
    
    
}
