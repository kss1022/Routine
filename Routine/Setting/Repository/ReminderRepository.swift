//
//  ReminderRepository.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import Foundation



protocol ReminderRepository{
    var reminders: ReadOnlyCurrentValuePublisher<[ReminderModel]>{ get }
    
    func fetchReminders() async throws
}

final class ReminderRepositoryImp: ReminderRepository{
    
    var reminders: ReadOnlyCurrentValuePublisher<[ReminderModel]>{ remindersSubject }
    private let remindersSubject = CurrentValuePublisher<[ReminderModel]>([])
    
    func fetchReminders() async throws{
        let models = try reminderReadModel.reminders()
            .map(ReminderModel.init)
        
        remindersSubject.send(models)
        
        Log.v("Fetch Reminders : \(models)")
    }
    

    private let reminderReadModel: ReminderReadModelFacade
    
    init(reminderReadModel: ReminderReadModelFacade) {
        self.reminderReadModel = reminderReadModel
    }
}
