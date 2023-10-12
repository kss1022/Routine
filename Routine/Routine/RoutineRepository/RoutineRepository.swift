//
//  RoutineRepository.swift
//  Routine
//
//  Created by 한현규 on 10/4/23.
//

import Foundation
import Combine

                      
protocol RoutineRepository{

    var lists: ReadOnlyCurrentValuePublisher<[RoutineListDto]> { get }
    var homeLists: ReadOnlyCurrentValuePublisher<[RoutineHomeListModel]> { get }
    var detail: ReadOnlyCurrentValuePublisher<RoutineDetailModel?> { get }
    var detailRecords: ReadOnlyCurrentValuePublisher<RoutineDetailRecordModel?>{ get }
    
    func fetchLists() async throws
    func fetchDetail(_ routineId: UUID) async throws
    func fetchHomeList(date: Date) async throws

    
    var emojis : [EmojiDto]{ get }
    func fetchEmojis() async throws
    
    var tints: [TintDto]{ get }
    func fetchTints() async throws
}


final class RoutineRepositoryImp: RoutineRepository{
    
    var lists: ReadOnlyCurrentValuePublisher<[RoutineListDto]>{ listsSubject }
    let listsSubject = CurrentValuePublisher<[RoutineListDto]>([])

    private var recordDate = Date()
    var homeLists: ReadOnlyCurrentValuePublisher<[RoutineHomeListModel]>{ homeListsSubject }
    let homeListsSubject = CurrentValuePublisher<[RoutineHomeListModel]>([])    
        
    var detail: ReadOnlyCurrentValuePublisher<RoutineDetailModel?>{ detailSubject }
    var detailSubject = CurrentValuePublisher<RoutineDetailModel?>(nil)
        
    var detailRecords: ReadOnlyCurrentValuePublisher<RoutineDetailRecordModel?>{ detailRecordsSubject }
    var detailRecordsSubject = CurrentValuePublisher<RoutineDetailRecordModel?>(nil)
    
            
    private(set) var emojis = [EmojiDto]()
    private(set) var tints = [TintDto]()
    
    func fetchLists() async throws {
        let list = try routineReadModel.routineLists()
        self.listsSubject.send(list)
        
        Log.v("RoutineRepository: fetch lists")
        try await fetchHomeList(date: self.recordDate)
    }

    
    func fetchHomeList(date: Date) async throws{
        self.recordDate = date
        let lists = self.lists.value
        
        let calendar = Calendar.current
                
        var dayOfList: [RoutineListDto] = .init()
        let dayOfWeek = calendar.component(.weekday, from: date) - 1 // sun = 0 , mon = 1 ...
        let dayOfMonth = calendar.component(.day, from: date)
        
        lists.forEach { list in
            switch list.repeatType {
            case .doItOnce:
                guard let getDate = list.repeatValue.date() else { break }
                if getDate == date{
                    dayOfList.append(list)
                }
            case .daliy:
                dayOfList.append(list)
            case .weekliy:
                guard let set = list.repeatValue.set() else { break }
                if set.contains(dayOfWeek){
                    dayOfList.append(list)
                }
            case .monthly:
                guard let set = list.repeatValue.set() else { break }
                if set.contains(dayOfMonth){
                    dayOfList.append(list)
                }
            }
        }
        
        
        let recordSet : Set<RecordDto> = Set(
            try fetchRecord(date: date)
        )
                
        let homeListModel = dayOfList.map { RoutineHomeListModel(routineListDto: $0, set: recordSet, recordDate: recordDate)}
        
        homeListsSubject.send(homeListModel)
        
        Log.v("RoutineRepository: fetch homeList \(date)")

    }

    
    func fetchDetail(_ routineId: UUID) async throws {
        let detail = try routineReadModel.routineDetail(id: routineId)
        
        let record = try recordReadModel.record(routineId: routineId, date: recordDate)
        let records = try recordReadModel.records(routineId: routineId)
        
        
        let detailModel = detail.map(RoutineDetailModel.init)
        self.detailSubject.send(detailModel)
        
        let detailRecordModel = RoutineDetailRecordModel(recordDto: record, recordDate: recordDate, recordDtos: records)
        self.detailRecordsSubject.send(detailRecordModel)
        
        
        Log.v("RoutineRepository: fetch detail")
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
    
    
    
    private func fetchRecord(date: Date) throws -> [RecordDto] {
        let list = try recordReadModel.records(date: date)
        Log.v("RoutineRepository: fetch Record \(date)")
        return list
    }
    
    
    
    private let routineReadModel: RoutineReadModelFacade
    private let repeatReadModel: RepeatReadModelFacade
    private let recordReadModel: RecordReadModelFacade
    
    private var cancelables: Set<AnyCancellable>
    
    init(
        routineReadModel: RoutineReadModelFacade,
        repeatReadModel: RepeatReadModelFacade,
        recordReadModel: RecordReadModelFacade
    ) {
        self.routineReadModel = routineReadModel
        self.repeatReadModel = repeatReadModel
        self.recordReadModel = recordReadModel
        self.cancelables = .init()
        
        Task{
            try? await fetchLists()
        }
    }

}

extension RecordDto: Hashable{
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.recordId)
    }
    
    
    public static func == (lhs: RecordDto, rhs: RecordDto) -> Bool {
        lhs.recordId == rhs.recordId
    }
    
}

