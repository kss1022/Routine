//
//  TimerRepository.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation



protocol TimerRepository{
    
    var lists: ReadOnlyCurrentValuePublisher<[TimerListModel]>{ get }
    var focus: ReadOnlyCurrentValuePublisher<TimerFocusModel?>{ get}
    var sections: ReadOnlyCurrentValuePublisher<TimerSectionsModel?>{ get }
    
        
    func fetchLists() async throws
    func fetchFocus(timerId: UUID) async throws
    func fetchSections(timerId: UUID) async throws
}


final class TimerRepositoryImp: TimerRepository{

        
    var lists: ReadOnlyCurrentValuePublisher<[TimerListModel]>{ listsSubject }
    private let listsSubject = CurrentValuePublisher<[TimerListModel]>([])
    
    var focus: ReadOnlyCurrentValuePublisher<TimerFocusModel?>{ focusSubject }
    private let focusSubject = CurrentValuePublisher<TimerFocusModel?>(nil)
    
    var sections: ReadOnlyCurrentValuePublisher<TimerSectionsModel?>{ sectionsSubject }
    private let sectionsSubject = CurrentValuePublisher<TimerSectionsModel?>(nil)
    
    
    func fetchLists() async throws {
        let models = try timerReadModel.timerLists()
            .map(TimerListModel.init)
        listsSubject.send(models)
    }
    
    
    
    func fetchFocus(timerId: UUID) async throws {
        let timerDto = try timerReadModel.timer(id: timerId)
        let countdownDto = try timerReadModel.timerCountdown(id: timerId)
        
        if let timer = timerDto,
           let countdown = countdownDto{
            let model = TimerFocusModel(timerDto: timer, countdownDto: countdown)
            focusSubject.send(model)
        }
    }
    
    
    func fetchSections(timerId: UUID) async throws {
        let timer = try timerReadModel.timer(id: timerId)
        let sections = try timerReadModel.timerSectionLists(id: timerId)
        
        let sectionModel = timer.flatMap {
            TimerSectionsModel(timerDto: $0, sections: sections)
        }
        
        sectionsSubject.send(sectionModel)
    }
    
    
    private let timerReadModel: TimerReadModelFacade
    
    init(timerReadModel: TimerReadModelFacade) {
        self.timerReadModel = timerReadModel                        
    }
    

}
