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
    func setReminder(_ viewModel: SettingDaliyReminderViewModel)
    func setRoutineReminders(_ viewModels: [SettingRoutineReminderViewModel])
    
    
    func updateDaliyReminder(_ viewModel: SettingDaliyReminderViewModel)
    func showDaliyReminderDatePicker(_ viewModel: SettingDaliyReminderViewModel)
    func hideDaliyReminderDatePicker(_ viewModel: SettingDaliyReminderViewModel)
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
    
    private let daliyReminderService: DaliyReminderService
    private let routineReminderService: RoutineReminderService
    
    private var alarmModel: SettingAlarmModel!
    private var reminderModel: SettingDaliyReminderModel!
    
    
    private var isDaliyRemindeShow: Bool
    
    // in constructor.
    init(
        presenter: SettingAppNotificationPresentable,
        dependency: SettingAppNotificationInteractorDependency
    ) {
        self.dependency = dependency
        cancellables = .init()
        
        daliyReminderService = DaliyReminderServiceImp()
        routineReminderService = RoutineReminderServiceImp()
        
        isDaliyRemindeShow = false

        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        Task{
            do{
                try await dependency.reminderRepository.fetchReminders()
            }catch{
                Log.e(error.localizedDescription)
            }
        }
        
                     
        alarmModel = SettingAlarmModel(
            title: "Alarm",
            imageName: "app.badge",
            isOn: false
        )
                
        
        reminderModel = SettingDaliyReminderModel(
            title: "Daliy Reminder",
            imageName: "bell.square.fill",
            isOn: daliyReminderService.isOn,
            hour: daliyReminderService.hour,
            minute: daliyReminderService.minute
        )
                
        dependency.reminderRepository.reminders
            .receive(on: DispatchQueue.main)
            .sink { models in
                self.fetchRoutineReminder()
            }
            .store(in: &cancellables)
        
        presenter.setAlarm(SettingAlarmViewModel(alarmModel))
        presenter.setReminder(SettingDaliyReminderViewModel(reminderModel, isShow: false))
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func didMove() {
        listener?.settingAppNotificationDidMove()
    }

    func alarmToogleValueChanged(isOn: Bool) {
        Log.v("alarmToogleValueChanged: \(isOn)")
    }

    
    func daliyReminderToolgeValueChanged(isOn: Bool) {
        Task{ [weak self] in
            do{
                guard let self = self else { return }
                try await self.daliyReminderService.update(isOn: isOn)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.fetchDaliyReminder()
                    if isOn{
                        self.showDaliyReminder()
                    }else{
                        self.hideDaliyReminder()
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
                guard let self = self else { return }
                try await self.daliyReminderService.update(date: date)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.fetchDaliyReminder()
                    self.updateDalitReminder()                    
                }
            }catch{
                Log.e(error.localizedDescription)
            }
        }
    }
    
    func daliyReminderDidTap() {
        if !daliyReminderService.isOn{
            return
        }
        
        if isDaliyRemindeShow{
            hideDaliyReminder()
        }else{
            showDaliyReminder()
        }
    }
    
    func routineReminderToogleValueChanged(isOn: Bool, routineId: UUID) {
        guard let reminderModel = dependency.reminderRepository.reminders.value.first(where: { $0.routineId == routineId }) else { return }
        
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                if !isOn{
                    await self.routineReminderService.off(routineId: reminderModel.routineId)
                }else{
                    try await self.routineReminderService.on(model: reminderModel)
                }
                
                await MainActor.run { [weak self] in self?.fetchRoutineReminder() }
            }catch{
                Log.e(error.localizedDescription)
            }
        }
        
    }
    
    //MARK: Private
    
    /// handle daliy
    private func fetchDaliyReminder(){
        let clone = SettingDaliyReminderModel(
            title: reminderModel.title,
            imageName: reminderModel.imageName,
            isOn: daliyReminderService.isOn,
            hour: daliyReminderService.hour,
            minute: daliyReminderService.minute
        )
        reminderModel = clone
    }
    

    private func showDaliyReminder(){
        if isDaliyRemindeShow{
            updateDalitReminder()
            return
        }
        
        isDaliyRemindeShow = true
        presenter.showDaliyReminderDatePicker(SettingDaliyReminderViewModel(reminderModel, isShow: isDaliyRemindeShow))
    }
    
    private func hideDaliyReminder(){
        if !isDaliyRemindeShow{
            self.updateDalitReminder()
            return
        }
        
        isDaliyRemindeShow = false
        presenter.hideDaliyReminderDatePicker(SettingDaliyReminderViewModel(reminderModel, isShow: isDaliyRemindeShow))
    }
    
    private func updateDalitReminder(){
        self.presenter.updateDaliyReminder(SettingDaliyReminderViewModel(self.reminderModel, isShow: self.isDaliyRemindeShow))
    }
    
    
    /// handle routine
    private func fetchRoutineReminder(){
        Task{ [weak self] in
            guard let self = self else { return }
            
            let routineIds = await self.routineReminderService.routineIds
            let reminders = dependency.reminderRepository.reminders.value
            
            let viewModels = reminders.map { reminder in
                let isOn = routineIds.contains{ $0 == reminder.routineId.uuidString }
                return SettingRoutineReminderViewModel(reminder, isOn: isOn)
            }

            await MainActor.run{ [weak self] in  self?.presenter.setRoutineReminders(viewModels) }
        }
    }

}
