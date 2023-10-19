//
//  TimerRepository.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation



protocol TimerRepository{
    var lists: ReadOnlyCurrentValuePublisher<[TimerListModel]>{ get }
    var sections: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ get }
}


final class TimerRepositoryImp: TimerRepository{
    
    var lists: ReadOnlyCurrentValuePublisher<[TimerListModel]>{ listsSubject }
    var listsSubject = CurrentValuePublisher<[TimerListModel]>([])
    
    var sections: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ sectionsSubject }
    var sectionsSubject = CurrentValuePublisher<[TimerSectionListModel]>([])
    
    init() {
        fetchLists()
        setFetchSectionList()
    }
    
    private func fetchLists(){
        let models = [
            TimerListModel(
                timerId: UUID(),
                name: "Tabata",
                description: "Tabata",
                emoji: "🔥",
                tint: "#CCFFCCFF",
                status: .initialized
            ),
            
            TimerListModel(
                timerId: UUID(),
                name: "Round",
                description: "Roud",
                emoji: "💣",
                tint: "#FFE5CCFF",
                status: .initialized
            ),
            
            TimerListModel(
                timerId: UUID(),
                name: "chest exercises",
                description: "You can do it",
                emoji: "💪",
                tint: "#FFFFCCFF",
                status: .initialized
            ),
            
            TimerListModel(
                timerId: UUID(),
                name: "Running",
                description: "Running",
                emoji: "🏃",
                tint: "#FFCCFFFF",
                status: .initialized
            )
        ]
        listsSubject.send(models)
    }
    
    private func setFetchSectionList(){
        
        var models = [
            TimerSectionListModel(
                id: UUID(),
                emoji: "🔥",
                name: "Ready",
                description: "Before start countdown",
                value: .countdown(min: 0, sec: 10)
            ),TimerSectionListModel(
                id: UUID(),
                emoji: "🧘‍♂️",
                name: "Take a rest",
                description: "Take a rest",
                value: .countdown(min: 0, sec: 10),
                color: "#3BD2AEff"
            ),TimerSectionListModel(
                id: UUID(),
                emoji: "🏃",
                name: "Excercise",
                description: "You can do it!!!",
                value: .countdown(min: 0, sec: 5),
                color: "#3BD2AEff"
            ),
            TimerSectionListModel(
                id: UUID(),
                emoji: "🔄",
                name: "Round",
                description: "Round is excersise and take a rest",
                value: .count(count: 3)
            ),
            TimerSectionListModel(
                id: UUID(),
                emoji: "❄️",
                name: "Cool Down",
                description: "After excersice cool down",
                value: .countdown(min: 0, sec: 30)
            )
            
//            TimerSectionListModel(
//                emoji: "🔄",
//                name: "Cycle",
//                description: "Cycle is \(3) round",
//                value: .count(count: 3),
//                color: "#6200EEFF"
//            ),
//            TimerSectionListModel(
//                emoji: "🧘‍♀️",
//                name: "Cycle Rest",
//                description: "Take a rest",
//                value: .countdown(min: 0, sec: 30),
//                color: "#6200EEFF"
//            ),
        ]
        

        self.sectionsSubject.send(models)

    }

}
