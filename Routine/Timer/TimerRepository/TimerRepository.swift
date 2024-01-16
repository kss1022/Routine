//
//  TimerRepository.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation



protocol TimerRepository{
    
    var lists: ReadOnlyCurrentValuePublisher<[TimerListModel]>{ get }
    var focus: ReadOnlyCurrentValuePublisher<FocusTimerModel?>{ get}
    var sections: ReadOnlyCurrentValuePublisher<SectionTimerModel?>{ get }
    
    func focus(timerId: UUID) async throws -> FocusTimerModel?
    func tabata(timerId: UUID) async throws -> TabataTimerModel?
    func round(timerId: UUID) async throws -> RoundTimerModel?
                
    func fetchLists() async throws
    func fetchFocus(timerId: UUID) async throws
    
    func recordId(timerId: UUID, startAt: Date) async throws -> UUID?
}


final class TimerRepositoryImp: TimerRepository{

        
    var lists: ReadOnlyCurrentValuePublisher<[TimerListModel]>{ listsSubject }
    private let listsSubject = CurrentValuePublisher<[TimerListModel]>([])
    
    var focus: ReadOnlyCurrentValuePublisher<FocusTimerModel?>{ focusSubject }
    private let focusSubject = CurrentValuePublisher<FocusTimerModel?>(nil)
    
    var sections: ReadOnlyCurrentValuePublisher<SectionTimerModel?>{ sectionsSubject }
    private let sectionsSubject = CurrentValuePublisher<SectionTimerModel?>(nil)
    
    
    func fetchLists() async throws {
        let models = try timerReadModel.timerLists()
            .map(TimerListModel.init)
        Log.v("TimerRepository: fetch Lists")
        listsSubject.send(models)
    }
    
    
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
    
    func fetchFocus(timerId: UUID) async throws {
        let focusTimer = try timerReadModel.focusTimer(id: timerId).map(FocusTimerModel.init)
        Log.v("TimerRepository: fetch focus")
        focusSubject.send(focusTimer)
    }
    
    
    func recordId(timerId: UUID, startAt: Date) async throws -> UUID?{
        try recordReadModel.record(timerId: timerId, startAt: startAt)?.recordId
    }
    
    private let timerReadModel: TimerReadModelFacade
    private let recordReadModel: TimerRecordReadModelFacade
    
    init(
        timerReadModel: TimerReadModelFacade,
        recordModel: TimerRecordReadModelFacade
    ) {
        self.timerReadModel = timerReadModel
        self.recordReadModel = recordModel        
    }
    

}
