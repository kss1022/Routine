//
//  RecordTimerListInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/9/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RecordTimerListRouting: ViewableRouting {
}

protocol RecordTimerListPresentable: Presentable {
    var listener: RecordTimerListPresentableListener? { get set }
    func setTimerLists(_ viewModels: [RecordTimerListViewModel])
    
    func showEmpty()
    func hideEmpty()
}

protocol RecordTimerListListener: AnyObject {
    func recordTimerListTitleButtonDidTap()
    func recordTimerListDidTap(timerId: UUID)
}

protocol RecordTimerListInteractorDependency{
    var timerRecordRepository: TimerRecordRepository{ get }
}

final class RecordTimerListInteractor: PresentableInteractor<RecordTimerListPresentable>, RecordTimerListInteractable, RecordTimerListPresentableListener {
    
    weak var router: RecordTimerListRouting?
    weak var listener: RecordTimerListListener?

    private let dependency: RecordTimerListInteractorDependency
    private let timerRecordRepository: TimerRecordRepository
    
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RecordTimerListPresentable,
        dependency: RecordTimerListInteractorDependency
    ) {
        self.dependency = dependency
        self.timerRecordRepository = dependency.timerRecordRepository
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        Task{ [weak self] in
            try? await self?.timerRecordRepository.fetchList()
        }
                
        timerRecordRepository.lists
            .receive(on: DispatchQueue.main)
            .sink { lists in
                let viewModels = lists.map(RecordTimerListViewModel.init)
                
                if viewModels.isEmpty{
                    self.presenter.showEmpty()
                }else{
                    self.presenter.hideEmpty()
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
    
    func titleButtonDidTap() {
        listener?.recordTimerListTitleButtonDidTap()
    }
    
    func timerListDidTap(timerId: UUID) {
        listener?.recordTimerListDidTap(timerId: timerId)
    }
}
