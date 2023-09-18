//
//  RoutineHomeInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs
import Combine
import Foundation

protocol RoutineHomeRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineHomePresentable: Presentable {
    var listener: RoutineHomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RoutineHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RoutineHomeInteractor: PresentableInteractor<RoutineHomePresentable>, RoutineHomeInteractable, RoutineHomePresentableListener {

    weak var router: RoutineHomeRouting?
    weak var listener: RoutineHomeListener?

    private var cancellables: Set<AnyCancellable>

    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RoutineHomePresentable) {
        self.cancellables = .init()

        super.init(presenter: presenter)
        presenter.listener = self
        
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        
        
       
        
        DomainEventPublihser.share.onReceive(MyDomainEvent.self, performOn: DispatchQueue.global()) { event in
            Log.v("\(event)")
        }
        .store(in: &cancellables)
        

        
        Task{
            await DomainEventPublihser.share.publish(MyDomainEvent() as Event)
            await publish(MyDomainEvent())
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func publish(_ event: Event) async{
        await DomainEventPublihser.share.publish(event)
    }
}



class MyDomainEvent : Event{
    let id = 10
}
