//
//  CheckListProjection.swift
//  Routine
//
//  Created by 한현규 on 2023/09/21.
//

import Foundation
import Combine


final class CheckListProjection{
    
    private var cancellables: Set<AnyCancellable>
    
    init() {
        self.cancellables = .init()
        
        registerReceiver()
    }
    
    
    func registerReceiver(){
        DomainEventPublihser.share.onReceive(CheckListCreated.self, action: when)
            .store(in: &cancellables)
    }
    
    
    func when(event: CheckListCreated){
        Log.v("Recive: CheckListCreate \(event)")
    }
}
