//
//  RoutineRepository.swift
//  Routine
//
//  Created by 한현규 on 10/4/23.
//

import Foundation
import Combine

                      
protocol RoutineRepository{

    var lists: ReadOnlyCurrentValuePublisher<[RoutineListModel]> { get }
    var homeLists: ReadOnlyCurrentValuePublisher<[RoutineHomeListModel]> { get }
    var detail: ReadOnlyCurrentValuePublisher<RoutineDetailModel?> { get }
    var detailRecords: ReadOnlyCurrentValuePublisher<RoutineDetailRecordModel?>{ get }
    
    func fetchLists() async throws
    func fetchDetail(_ routineId: UUID) async throws
    func fetchHomeList(date: Date) async throws
}


final class RoutineRepositoryImp: RoutineRepository{
    
    var lists: ReadOnlyCurrentValuePublisher<[RoutineListModel]>{ listsSubject }
    private let listsSubject = CurrentValuePublisher<[RoutineListModel]>([])

    private var recordDate = Date()
    var homeLists: ReadOnlyCurrentValuePublisher<[RoutineHomeListModel]>{ homeListsSubject }
    private let homeListsSubject = CurrentValuePublisher<[RoutineHomeListModel]>([])
        
    var detail: ReadOnlyCurrentValuePublisher<RoutineDetailModel?>{ detailSubject }
    private let detailSubject = CurrentValuePublisher<RoutineDetailModel?>(nil)
        
    var detailRecords: ReadOnlyCurrentValuePublisher<RoutineDetailRecordModel?>{ detailRecordsSubject }
    private let detailRecordsSubject = CurrentValuePublisher<RoutineDetailRecordModel?>(nil)
    
            
    
    func fetchLists() async throws {
        let list = try routineReadModel.routineLists()
            .map(RoutineListModel.init)
        self.listsSubject.send(list)
        
        Log.v("RoutineRepository: fetch lists")
        try await fetchHomeList(date: self.recordDate)
    }

    
    func fetchHomeList(date: Date) async throws{
        self.recordDate = date
        let lists = self.lists.value
        
        let calendar = Calendar.current
                
        var dayOfList: [RoutineListModel] = .init()
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
            case .weekly:
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
        
        
        let recordSet : Set<RoutineRecordDto> = Set(
            try fetchRecord(date: date)
        )
                
        let homeListModel = dayOfList.map { RoutineHomeListModel(listModel: $0, set: recordSet, recordDate: recordDate)}
        
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
    
    
    private func fetchRecord(date: Date) throws -> [RoutineRecordDto] {
        let list = try recordReadModel.records(date: date)
        Log.v("RoutineRepository: fetch Record \(date)")
        return list
    }
    
    
    
    private let routineReadModel: RoutineReadModelFacade
    private let repeatReadModel: RepeatReadModelFacade
    private let recordReadModel: RoutineRecordReadModelFacade
    private let reminderReadModel: ReminderReadModelFacade
    
    private var cancelables: Set<AnyCancellable>
    
    init(
        routineReadModel: RoutineReadModelFacade,
        repeatReadModel: RepeatReadModelFacade,
        recordReadModel: RoutineRecordReadModelFacade,
        reminderReadModel: ReminderReadModelFacade
    ) {
        self.routineReadModel = routineReadModel
        self.repeatReadModel = repeatReadModel
        self.recordReadModel = recordReadModel
        self.reminderReadModel = reminderReadModel
        self.cancelables = .init()
    }

}

extension RoutineRecordDto: Hashable{
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.recordId)
    }
    
    
    public static func == (lhs: RoutineRecordDto, rhs: RoutineRecordDto) -> Bool {
        lhs.recordId == rhs.recordId
    }
    
}
