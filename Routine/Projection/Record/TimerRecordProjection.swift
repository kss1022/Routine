//
//  TimerRecordProjection.swift
//  Routine
//
//  Created by 한현규 on 1/19/24.
//


import Foundation
import Combine


final class TimerRecordProjection{

    private let timerTotalRecordDao: TimerTotalRecordDao
    private let timerMonthRecordDao: TimerMonthRecordDao
    private let timerWeekRecordDao: TimerWeekRecordDao
    private let timerStreakDao: TimerStreakDao
    private let timerRecordDao: TimerRecordDao
    
    private var cancellables: Set<AnyCancellable>

    
    init() throws{
        guard let dbManager = DatabaseManager.default else {
            throw DatabaseException.couldNotGetDatabaseManagerInstance
        }
                
        
        self.timerTotalRecordDao = dbManager.timerTotalRecordDao
        self.timerMonthRecordDao = dbManager.timerMonthRecordDao
        self.timerWeekRecordDao = dbManager.timerWeekRecordDao
        self.timerStreakDao = dbManager.timerStreakDao
        self.timerRecordDao = dbManager.timerRecordDao
        cancellables = .init()
        
        registerReceiver()
    }
    
    
    private func registerReceiver(){
        DomainEventPublihser.shared
            .onReceive(TimerRecordCreated.self, action: when)
            .store(in: &cancellables)
    }

    //MARK: TimerRecord
    private func when(event: TimerRecordCreated){
        do{
            let timerId = event.timerId.id
            let time = event.timeRecord.duration
            let today = Formatter.recordDateFormatter().string(from: event.recordDate.date)
            let yesterdayDate = event.recordDate.date.addingTimeInterval(-60 * 60 * 24)
            let yesterday = Formatter.recordDateFormatter().string(from: yesterdayDate)
            
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: event.recordDate.date)
            let startOfWeek = calendar.date(from: components)!
            let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
            let weekFormatter = Formatter.weekRecordFormatter()
            
            
            let record = TimerRecordDto(
                timerId: timerId,
                recordId: event.recordId.id,
                recordDate: today,
                startAt: event.timeRecord.startAt,
                endAt: event.timeRecord.endAt,
                duration: event.timeRecord.duration
            )
                                                 
            try timerRecordDao.save(record)
            try timerTotalRecordDao.update(timerId: timerId, time: time)
            try timerMonthRecordDao.update(timerId: timerId, month: Formatter.recordMonth(event.recordDate), time: time)
            try timerWeekRecordDao.update(timerId: timerId, startOfWeek: weekFormatter.string(from: startOfWeek), endOfWeek: weekFormatter.string(from: endOfWeek), dayOfWeek: event.recordDate.dayOfWeek, time: time)
            try timerStreakDao.update(timerId: timerId, today: today, yesterday: yesterday)
        }catch{
            Log.e("EventHandler Error: RecordCreated \(error)")
        }
    }
    
}

