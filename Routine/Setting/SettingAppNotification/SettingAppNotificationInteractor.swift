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
    
    
    func updateReminderDate(_ viewModel: SettingDaliyReminderViewModel)
    
    func showReminderDatePicker(_ viewModel: SettingDaliyReminderViewModel)
    func hideReminderDatePicker(_ viewModel: SettingDaliyReminderViewModel)
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
    
    private let preferenceStorage: PreferenceStorage
    
    private var alarmModel: SettingAlarmModel!
    private var reminderModel: SettingDaliyReminderModel!
    
    // in constructor.
    init(
        presenter: SettingAppNotificationPresentable,
        dependency: SettingAppNotificationInteractorDependency
    ) {
        self.dependency = dependency
        cancellables = .init()
        preferenceStorage = PreferenceStorage.shared

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
        ) { isOn in
            Log.v("Alarm value Change: \(isOn)")
        }
                
        
        reminderModel = SettingDaliyReminderModel(
            title: "Daliy Reminder",
            imageName: "bell.square.fill",
            isOn: preferenceStorage.setDaliyReminder,
            date: preferenceStorage.daliyReminderDate ?? Date(), // or Today
            isShow: false,
            onOffChanged: { [weak self] isOn in
                guard let self = self else { return }
                if isOn{
                    self.preferenceStorage.setDaliyReminder = true
                    self.fetchReminder()
                    self.showReminder()
                }else{
                    self.preferenceStorage.setDaliyReminder = false
                    self.fetchReminder()
                    self.hideReminder()
                }
            },
            dateChanged: { [weak self] date in
                guard let self = self else { return }
                self.preferenceStorage.daliyReminderDate = date
                self.fetchReminder()
                self.presenter.updateReminderDate(SettingDaliyReminderViewModel(self.reminderModel))
            }
        )
                
        dependency.reminderRepository.reminders
            .receive(on: DispatchQueue.main)
            .sink { models in
                let viewModels =  models.map{ model in
                    SettingRoutineReminderViewModel(model) { isOn in
                        Log.v("\(model): change to  \(isOn)")
                    }
                }
                self.presenter.setRoutineReminders(viewModels)
            }
            .store(in: &cancellables)
        
        presenter.setAlarm(SettingAlarmViewModel(alarmModel))
        presenter.setReminder(SettingDaliyReminderViewModel(reminderModel))
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func didMove() {
        listener?.settingAppNotificationDidMove()
    }

    
    func reminderDidTap() {
        if !reminderModel.isOn{
            return
        }
        
        if reminderModel.isShow{
            hideReminder()
        }else{
            showReminder()
        }
    }
    
    //MARK: Private
    
    private func fetchReminder(){
        let clone = SettingDaliyReminderModel(
            title: reminderModel.title,
            imageName: reminderModel.imageName,
            isOn: preferenceStorage.setDaliyReminder,
            date: preferenceStorage.daliyReminderDate ?? Date(),
            isShow: reminderModel.isShow,
            onOffChanged: reminderModel.onOffChanged,
            dateChanged: reminderModel.dateChanged
        )
        reminderModel = clone
    }
    
    
    private func showReminder(){
        if reminderModel.isShow{
            return
        }
        
        let clone = SettingDaliyReminderModel(
            title: reminderModel.title,
            imageName: reminderModel.imageName,
            isOn: reminderModel.isOn,
            date: reminderModel.date,
            isShow: true,
            onOffChanged: reminderModel.onOffChanged,
            dateChanged: reminderModel.dateChanged
        )
        reminderModel = clone
        presenter.showReminderDatePicker(SettingDaliyReminderViewModel(reminderModel))
    }
    
    private func hideReminder(){
        if !reminderModel.isShow{
            return
        }
        
        let clone = SettingDaliyReminderModel(
            title: reminderModel.title,
            imageName: reminderModel.imageName,
            isOn: reminderModel.isOn,
            date: reminderModel.date,
            isShow: false,
            onOffChanged: reminderModel.onOffChanged,
            dateChanged: reminderModel.dateChanged
        )
        reminderModel = clone
        presenter.hideReminderDatePicker(SettingDaliyReminderViewModel(reminderModel))
    }

}
