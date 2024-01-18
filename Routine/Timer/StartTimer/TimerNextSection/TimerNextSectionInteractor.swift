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
    func setNextSection(_ viewModel: TimerNextSectionViewModel)
    func removeNextSection()
}

protocol TimerNextSectionListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol TimerNextSectionInteractorDependency{
    var nextSection: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ get }
}

final class TimerNextSectionInteractor: PresentableInteractor<TimerNextSectionPresentable>, TimerNextSectionInteractable, TimerNextSectionPresentableListener {

    weak var router: TimerNextSectionRouting?
    weak var listener: TimerNextSectionListener?

    private let dependency: TimerNextSectionInteractorDependency
    
    private let nextSection: ReadOnlyCurrentValuePublisher<TimeSectionModel?>
    private var cancellables: Set<AnyCancellable>
    

    // in constructor.
    init(
        presenter: TimerNextSectionPresentable,
        dependency: TimerNextSectionInteractorDependency
    ) {
        self.dependency = dependency
        self.nextSection = dependency.nextSection
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        nextSection
            .receive(on: DispatchQueue.main)
            .sink { section in
                guard let section = section else {
                    self.presenter.removeNextSection()
                    return
                }
                
                let viewModel = TimerNextSectionViewModel(section)
                self.presenter.setNextSection(viewModel)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
}
