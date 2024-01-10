//
//  SettingAppNotificationInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import Foundation
import ModernRIBs
import Combine

protocol SettingAppNotificationRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SettingAppNotificationPresentable: Presentable {
    var listener: SettingAppNotificationPresentableListener? { get set }
    
    func setAlarm(_ viewModel: SettingAlarmViewModel)
    func setDaliyReminder(_ viewModel: SettingDaliyReminderViewModel)
    func setRoutineReminders(_ viewModels: [SettingRoutineReminderViewModel])
    
    func showDaliyReminderDatePicker()
    func hideDaliyReminderDatePicker()
}

protocol SettingAppNotificationListener: AnyObject {
    func settingAppNotificationDidMove()
}

protocol SettingAppNotificationInteractorDependency{
    var reminderRepository: ReminderRepository{ get }
}

final class SettingAppNotificationInteractor: PresentableInteractor<SettingAppNotificationPresentable>, SettingAppNotificationInteractable, SettingAppNotificationPresentableListener {
    
    weak var router: SettingAppNotificationRouting?
    weak var listener: SettingAppNotificationListener?

    private let dependency: SettingAppNotificationInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    private let alarmService: AppAlarmService
    private let daliyReminderService: DaliyReminderService
    private let routineReminderService: RoutineReminderService
        

    
    private var isDaliyRemindeDatePickerShow: Bool
    
    // in constructor.
    init(
        presenter: SettingAppNotificationPresentable,
        dependency: SettingAppNotificationInteractorDependency
    ) {
        self.dependency = dependency
        cancellables = .init()
        
        alarmService = AppAlarmServiceImp()
        daliyReminderService = DaliyReminderServiceImp()
        routineReminderService = RoutineReminderServiceImp()
        
        isDaliyRemindeDatePickerShow = false

        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
                
        Task{
            do{
                alarmService.fetch()
                daliyReminderService.fetch()
                try await dependency.reminderRepository.fetchReminders()
            }catch{
                Log.e(error.localizedDescription)
            }
        }
        
                                     
        alarmService.alarm
            .removeDuplicates(by: { $0 == $1 })
            .receive(on: DispatchQueue.main)
            .sink { alarm in
                self.presenter.setAlarm(SettingAlarmViewModel(alarm))
            }
            .store(in: &cancellables)
        
        daliyReminderService.daliy
            .receive(on: DispatchQueue.main)
            .sink { reminder in
                let isShow = self.isDaliyRemindeDatePickerShow
                self.presenter.setDaliyReminder(SettingDaliyReminderViewModel(reminder, isShow: isShow))
            }
            .store(in: &cancellables)
        
        
        dependency.reminderRepository.reminders
            .receive(on: DispatchQueue.main)
            .sink { models in
                self.fetchRoutineReminder()
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func didMove() {
        listener?.settingAppNotificationDidMove()
    }

    //MARK: Alarm
    func alarmToogleValueChanged(isOn: Bool) {
        self.alarmService.update(isOn: isOn)
//        Task{ [weak self] in
//            do{
//                guard let self = self else { return }
//                
//                //Update Alarm
//                self.alarmService.update(isOn: isOn)
//                //Update DaliyReminder
//                try await self.daliyReminderService.update(isOn: isOn)
//                
//                await MainActor.run { [weak self] in
//                    if !isOn{ self?.hideDaliyReminderDatePicker() }
//                }
//                
//                //Update RoutineReminder
//                for reminderModel in self.dependency.reminderRepository.reminders.value{
//                    if !isOn{
//                        await self.routineReminderService.off(routineId: reminderModel.routineId)
//                    }else{
//                        try await self.routineReminderService.on(model: reminderModel)
//                    }
//                    
//                    self.fetchRoutineReminder()
//                }
//            }catch{
//                Log.e(error.localizedDescription)
//            }
//        }        
    }
    


    //MARK: DaliyReminder
    func daliyReminderToolgeValueChanged(isOn: Bool) {
        Task{ [weak self] in
            guard let self = self else { return }
            
            do{
                try await daliyReminderService.update(isOn: isOn)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                                        
                    if isOn{
                        showDaliyReminderDatePicker()
                    }else{
                        hideDaliyReminderDatePicker()
                    }
                }
            }catch{
                Log.e(error.localizedDescription)
            }
        }
    }
    
    func daliyReminderDateValueChanged(date: Date) {
        Task{ [weak self] in
            do{
                try await self?.daliyReminderService.update(date: date)
            }catch{
                Log.e(error.localizedDescription)
            }
        }
    }
    
    func daliyReminderDidTap() {
        if !daliyReminderService.daliy.value.isOn{
            return
        }
        
        if isDaliyRemindeDatePickerShow{
            hideDaliyReminderDatePicker()
        }else{
            showDaliyReminderDatePicker()
        }
    }
    

    private func showDaliyReminderDatePicker(){
        if isDaliyRemindeDatePickerShow{
            return
        }
        
        isDaliyRemindeDatePickerShow = true
        presenter.showDaliyReminderDatePicker()
    }
        
    private func hideDaliyReminderDatePicker(){
        if !isDaliyRemindeDatePickerShow{
            return
        }
        
        isDaliyRemindeDatePickerShow = false
        presenter.hideDaliyReminderDatePicker()
    }

    
    //MARK: RoutineReminder
    
    func routineReminderToogleValueChanged(isOn: Bool, routineId: UUID) {
        guard let reminderModel = dependency.reminderRepository.reminders.value.first(where: { $0.routineId == routineId }) else { return }
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                if !isOn{
                    await routineReminderService.off(routineId: reminderModel.routineId)
                }else{
                    try await routineReminderService.on(model: reminderModel)
                }
                
                fetchRoutineReminder()
            }catch{
                Log.e(error.localizedDescription)
            }
        }
        
    }

    private func fetchRoutineReminder(){
        Task{ [weak self] in
            guard let self = self else { return }
            
            let routineIds = await routineReminderService.routineIds
            let reminders = dependency.reminderRepository.reminders.value
            
            let viewModels = reminders.map { reminder in
                let isOn = routineIds.contains{ $0 == reminder.routineId.uuidString }
                return SettingRoutineReminderViewModel(reminder, isOn: isOn)
            }

            await MainActor.run{ [weak self] in  self?.presenter.setRoutineReminders(viewModels) }
        }
    }

}
