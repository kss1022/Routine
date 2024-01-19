//
//  TimerRepository.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation



protocol TimerRepository{
    var lists: ReadOnlyCurrentValuePublisher<[TimerListModel]>{ get }
    
    func focus(timerId: UUID) async throws -> FocusTimerModel?
    func tabata(timerId: UUID) async throws -> TabataTimerModel?
    func round(timerId: UUID) async throws -> RoundTimerModel?
                
    func fetchLists() async throws
}


final class TimerRepositoryImp: TimerRepository{

        
    var lists: ReadOnlyCurrentValuePublisher<[TimerListModel]>{ listsSubject }
    private let listsSubject = CurrentValuePublisher<[TimerListModel]>([])
    
    
    func focus(timerId: UUID) async throws -> FocusTimerModel? {
        let focusTimer = try timerReadModel.focusTimer(id: timerId).map(FocusTimerModel.init)
        Log.v("TimerRepository: fetch focus")
        return focusTimer
    }
    
    func tabata(timerId: UUID) async throws -> TabataTimerModel? {
        let tabataTimer = try timerReadModel.tabatTimer(id: timerId).map(TabataTimerModel.init)
        Log.v("TimerRepository: fetch tabata")
        return tabataTimer
    }
    
    func round(timerId: UUID) async throws -> RoundTimerModel? {
        let roundTimer = try timerReadModel.roundTimer(id: timerId).map(RoundTimerModel.init)
        Log.v("TimerRepository: fetch round")
        return roundTimer
    }

    
    func fetchLists() async throws {
        let models = try timerReadModel.timerLists()
            .map(TimerListModel.init)
        Log.v("TimerRepository: fetch Lists")
        listsSubject.send(models)
    }
    
    
    private let timerReadModel: TimerReadModelFacade
    
    init(
        timerReadModel: TimerReadModelFacade
    ) {
        self.timerReadModel = timerReadModel
    }
    

}
