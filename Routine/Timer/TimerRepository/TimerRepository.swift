//
//  TimerRepository.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation



protocol TimerRepository{
    var lists: ReadOnlyCurrentValuePublisher<[TimerListModel]>{ get }
    var detail: ReadOnlyCurrentValuePublisher<TimerDetailModel?>{ get }
    
    var sections: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ get }
    func baseSectionList(type: AddTimerType) -> [TimerSectionListModel]
    
    
    func fetchLists() async throws
    func fetchDetail(timerId: UUID) async throws
    func fetchSectionLists(timerId: UUID) async throws
}


final class TimerRepositoryImp: TimerRepository{
    
    var lists: ReadOnlyCurrentValuePublisher<[TimerListModel]>{ listsSubject }
    var listsSubject = CurrentValuePublisher<[TimerListModel]>([])
    
    var detail: ReadOnlyCurrentValuePublisher<TimerDetailModel?>{ detailSubject }
    var detailSubject = CurrentValuePublisher<TimerDetailModel?>(nil)
    
    var sections: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ sectionsSubject }
    var sectionsSubject = CurrentValuePublisher<[TimerSectionListModel]>([])
    

    
    
    func fetchLists() async throws {
        let models = try timerReadModel.timerLists()
            .map(TimerListModel.init)
        listsSubject.send(models)
    }
    
    func fetchDetail(timerId: UUID) async throws {
        let timer = try timerReadModel.timer(id: timerId)
        let sections = try timerReadModel.timerSectionLists(id: timerId)
        
        let detailModel = timer.flatMap {
            TimerDetailModel(timerDto: $0, sections: sections)
        }
        
        detailSubject.send(detailModel)
    }
    
    func fetchSectionLists(timerId: UUID) async throws {
        let models = try timerReadModel.timerSectionLists(id: timerId).map {
            TimerSectionListModel($0)
        }
        
        sectionsSubject.send(models)
    }
    
    
    func baseSectionList(type: AddTimerType) -> [TimerSectionListModel] {
        if type == .custom{
            return []
        }
        
        var models = [
            TimerSectionListModel(
                id: UUID(),
                emoji: "🔥",
                name: "Ready",
                description: "Before start countdown",
                sequence: 0,
                type: .ready,
                value: .countdown(min: 0, sec: 5)
            ),TimerSectionListModel(
                id: UUID(),
                emoji: "🧘‍♂️",
                name: "Take a rest",
                description: "Take a rest",
                sequence: 1,
                type: .rest,
                value: .countdown(min: 1, sec: 10),
                color: "#3BD2AEff"
            ),TimerSectionListModel(
                id: UUID(),
                emoji: "🏃",
                name: "Excercise",
                description: "You can do it!!!",
                sequence: 2,
                type: .exsercise,
                value: .countdown(min: 0, sec: 5),
                color: "#3BD2AEff"
            )]
        
        if type == .round{
            models.append(contentsOf: [
                TimerSectionListModel(
                    id: UUID(),
                    emoji: "⛳️",
                    name: "Round",
                    description: "Round is excersise and take a rest",
                    sequence: 3,
                    type: .round,
                    value: .count(count: 3)
                ),
                TimerSectionListModel(
                    id: UUID(),
                    emoji: "❄️",
                    name: "Cool Down",
                    description: "After excersice cool down",
                    sequence: 4,
                    type: .cooldown,
                    value: .countdown(min: 0, sec: 30)
                )
            ])
            
            return models
        }
        
        if type == .tabata{
            models.append(contentsOf: [
                TimerSectionListModel(
                    id: UUID(),
                    emoji: "⛳️",
                    name: "Round",
                    description: "Round is excersise + rest",
                    sequence: 3,
                    type: .round,
                    value: .count(count: 3)
                ),
                TimerSectionListModel(
                    id: UUID(),
                    emoji: "🔄",
                    name: "Cycle",
                    description: "Cycle is \(3) round",
                    sequence: 4,
                    type: .cycle,
                    value: .count(count: 3),
                    color: "#6200EEFF"
                ),
                TimerSectionListModel(
                    id: UUID(),
                    emoji: "🧘‍♀️",
                    name: "Cycle Rest",
                    description: "Take a rest",
                    sequence: 5,
                    type: .cycleRest,
                    value: .countdown(min: 0, sec: 30),
                    color: "#6200EEFF"
                ),
                TimerSectionListModel(
                    id: UUID(),
                    emoji: "❄️",
                    name: "Cool Down",                    
                    description: "After excersice cool down",
                    sequence: 6,
                    type: .cooldown,
                    value: .countdown(min: 0, sec: 30)
                )
            ])
            
            return models
        }
        
        fatalError("Some types do not handle.")
    }
    
    private let timerReadModel: TimerReadModelFacade
    
    init(timerReadModel: TimerReadModelFacade) {
        self.timerReadModel = timerReadModel
        
        Task{
            try? await fetchLists()
        }
        
    }
    

}
