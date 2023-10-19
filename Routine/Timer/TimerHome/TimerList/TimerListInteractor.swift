//
//  TimerListInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import Foundation
import ModernRIBs
import Combine


protocol TimerListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerListPresentable: Presentable {
    var listener: TimerListPresentableListener? { get set }
    func setTimerList(_ viewModels : [TimerListViewModel])
}

protocol TimerListListener: AnyObject {
    func timerListDidSelectAt()
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
        // TODO: Implement business logic here.
        
        dependency.timerRepository.lists
            .receive(on: DispatchQueue.main)
            .sink { lists in
                let viewModels = lists.map(TimerListViewModel.init)
                self.presenter.setTimerList(viewModels)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func collectionViewDidSelectItemAt() {
        listener?.timerListDidSelectAt()
    }
}
