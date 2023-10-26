//
//  TimerSelectInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation
import ModernRIBs
import Combine

protocol TimerSelectRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerSelectPresentable: Presentable {
    var listener: TimerSelectPresentableListener? { get set }
    func setTimerList(_ viewModels : [TimerListViewModel])
}

protocol TimerSelectListener: AnyObject {
    func timerSelectDidSelectItem(timerId: UUID)
}

protocol TimerSelectInteractorDependency{
    var timerRepository: TimerRepository{ get }
}

final class TimerSelectInteractor: PresentableInteractor<TimerSelectPresentable>, TimerSelectInteractable, TimerSelectPresentableListener {

    weak var router: TimerSelectRouting?
    weak var listener: TimerSelectListener?

    private let dependency: TimerSelectInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: TimerSelectPresentable,
        dependency: TimerSelectInteractorDependency
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
    
    func collectionViewDidSelectItemAt(timerId: UUID) {
        listener?.timerSelectDidSelectItem(timerId: timerId)
    }

}
