//
//  TimerListInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/15/24.
//

import Foundation
import ModernRIBs
import Combine

protocol TimerListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerListPresentable: Presentable {
    var listener: TimerListPresentableListener? { get set }
    func setTimerLists(_ viewModels: [TimerListViewModel])
}

protocol TimerListListener: AnyObject {
    func timerListTimerDidTap(timerId: UUID)
}

protocol TimerListInteractorDependency{
    var timerRepository: TimerRepository{ get }
}

final class TimerListInteractor: PresentableInteractor<TimerListPresentable>, TimerListInteractable, TimerListPresentableListener {

    weak var router: TimerListRouting?
    weak var listener: TimerListListener?
    
    private let dependency: TimerListInteractorDependency
    
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: TimerListPresentable,
        dependency: TimerListInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        dependency.timerRepository.lists
            .receive(on: DispatchQueue.main)
            .sink {  lists in
                let viewModels = lists.map{ model in
                    TimerListViewModel(model) {
                        Log.v("Tap: \(model.timerId)")
                    }
                }
                self.presenter.setTimerLists(viewModels)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
 
    func timerListDidTap(timerId: UUID) {
        listener?.timerListTimerDidTap(timerId: timerId)
    }

    
}
