//
//  RecordTimerListDetailInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RecordTimerListDetailRouting: ViewableRouting {
    func attachTimerData(timerId: UUID)
    func detachTimerData()
}

protocol RecordTimerListDetailPresentable: Presentable {
    var listener: RecordTimerListDetailPresentableListener? { get set }
    func setTimerLists(_ viewModels: [RecordTimerListViewModel])
}

protocol RecordTimerListDetailListener: AnyObject {
    func recordTimerListDetailDidMove()
}

protocol RecordTimerListDetailInteractableDependency{
    var timerRecordRepository: TimerRecordRepository{ get }
}

final class RecordTimerListDetailInteractor: PresentableInteractor<RecordTimerListDetailPresentable>, RecordTimerListDetailInteractable, RecordTimerListDetailPresentableListener {

    weak var router: RecordTimerListDetailRouting?
    weak var listener: RecordTimerListDetailListener?

    private let dependency: RecordTimerListDetailInteractableDependency
    private let timerRecordRepository: TimerRecordRepository
    
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RecordTimerListDetailPresentable,
        dependency: RecordTimerListDetailInteractableDependency
    ) {
        self.dependency = dependency
        self.timerRecordRepository = dependency.timerRecordRepository
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
     
        
        timerRecordRepository.lists
            .receive(on: DispatchQueue.main)
            .sink { lists in
                let viewModels = lists.map(RecordTimerListViewModel.init)
                self.presenter.setTimerLists(viewModels)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    

    
    func didMove() {
        listener?.recordTimerListDetailDidMove()
    }
    
    
    //MARK: TimerDetail
    func timerListDidTap(timerId: UUID) {
        router?.attachTimerData(timerId: timerId)
    }
    
    func timerDataDidMove() {
        router?.detachTimerData()
    }
}
