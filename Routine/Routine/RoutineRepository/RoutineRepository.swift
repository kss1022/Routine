//
//  RoutineRepository.swift
//  Routine
//
//  Created by 한현규 on 10/4/23.
//

import Foundation
import Combine

                      
protocol RoutineRepository{
    
    var emojis : [EmojiDto]{ get }
    func fetchEmojis() async throws
    
    var tints: [TintDto]{ get }
    func fetchTints() async throws
    
    var routineLists: ReadOnlyCurrentValuePublisher<[RoutineListDto]> { get }
    func fetchRoutineLists() async throws
    
    var currentRoutineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailDto?> { get }
    func fetchRoutineDetail(_ routineId: UUID) async throws
    
}


final class RoutineRepositoryImp: RoutineRepository{
    
    
    var routineLists: ReadOnlyCurrentValuePublisher<[RoutineListDto]>{ routineListsSubject }
    let routineListsSubject = CurrentValuePublisher<[RoutineListDto]>([])
    
    var currentRoutineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailDto?>{ currentRoutineDetailSubject }
    var currentRoutineDetailSubject = CurrentValuePublisher<RoutineDetailDto?>(nil)
    
            
    private(set) var emojis = [EmojiDto]()
    private(set) var tints = [TintDto]()
    
    
    func fetchRoutineLists() async throws {
        let routineLists = try routineReadModel.routineLists()
        self.routineListsSubject.send(routineLists)
        
        Log.v("Read Data: \([RoutineListDto].self)")
    }
    
    func fetchRoutineDetail(_ routineId: UUID) async throws {
        let routineDetail = try routineReadModel.routineDetail(id: routineId)
        self.currentRoutineDetailSubject.send(routineDetail)
        
        Log.v("Read Data: \(RoutineDetailDto.self) (\(routineId))")
    }
    
    func fetchEmojis() async throws{
        if emojis.isEmpty{
            let path = Bundle.main.path(forResource: "emojis", ofType: "json")!
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let emojis = try JSONDecoder().decode([EmojiDto].self, from: data)
                        
            if emojis.isEmpty{
                throw RepositoryError.decodeError(type: "\([EmojiDto].self)", reason: "List is Empty")
            }
            
            self.emojis = emojis
        }

        Log.v("Decode Data with the contest of URL (IF NOT EXISTS): \([EmojiDto].self)")
    }
    
    func fetchTints() async throws{
        if tints.isEmpty{
            let path = Bundle.main.path(forResource: "tints", ofType: "json")!
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let tints = try JSONDecoder().decode([TintDto].self, from: data)
            
            if tints.isEmpty{
                throw RepositoryError.decodeError(type: "\([TintDto].self)", reason: "List is Empty")
            }
            
            self.tints = tints
        }
                        
        Log.v("Decode Data with the contest of URL (IF NOT EXISTS): \([TintDto].self)")
    }
    
    
    private let routineReadModel: RoutineReadModelFacade
    
    init(routineReadModel: RoutineReadModelFacade) {
        self.routineReadModel = routineReadModel
        
        Task{ try? await fetchRoutineLists() }
    }

    
}

