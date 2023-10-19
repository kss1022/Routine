//
//  TimerNextSectionInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation
import ModernRIBs
import Combine

protocol TimerNextSectionRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerNextSectionPresentable: Presentable {
    var listener: TimerNextSectionPresentableListener? { get set }
    func setNextSection(_ viewModel: TimerSectionListViewModel)

}

protocol TimerNextSectionListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol TimerNextSectionInteractorDependency{    
    var sections: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ get }
    var sectionIndex: ReadOnlyCurrentValuePublisher<Int>{ get }
}

final class TimerNextSectionInteractor: PresentableInteractor<TimerNextSectionPresentable>, TimerNextSectionInteractable, TimerNextSectionPresentableListener {

    weak var router: TimerNextSectionRouting?
    weak var listener: TimerNextSectionListener?

    private let dependency: TimerNextSectionInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: TimerNextSectionPresentable,
        dependency: TimerNextSectionInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()


        Publishers.CombineLatest(dependency.sections,dependency.sectionIndex)
            .receive(on: DispatchQueue.main)
            .sink { (lists, index) in
                if let section = lists[safe: index + 1]{
                    self.presenter.setNextSection(TimerSectionListViewModel(section))
                }
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
