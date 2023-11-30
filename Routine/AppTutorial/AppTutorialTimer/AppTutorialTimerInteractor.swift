//
//  AppTutorialTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/29/23.
//

import Foundation
import ModernRIBs

protocol AppTutorialTimerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AppTutorialTimerPresentable: Presentable {
    var listener: AppTutorialTimerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AppTutorialTimerListener: AnyObject {
    func AppTutorialTimerDidFinish()
}

protocol AppTutorialTimerInteractorDependency{
    var timerApplicationService: TimerApplicationService{ get }
}

final class AppTutorialTimerInteractor: PresentableInteractor<AppTutorialTimerPresentable>, AppTutorialTimerInteractable, AppTutorialTimerPresentableListener {
    

    weak var router: AppTutorialTimerRouting?
    weak var listener: AppTutorialTimerListener?

    private let dependency: AppTutorialTimerInteractorDependency
    private let notificationManager: AppNotificationManager
    
    private var date: Date
    
    // in constructor.
    init(
        presenter: AppTutorialTimerPresentable,
        dependency: AppTutorialTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.notificationManager = AppNotificationManager.share
        self.date = Date()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        Task{
            try await notificationManager.setupNotification()
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func reminderTimePickerValueChange(date: Date) {
        self.date = date
    }
    
    func allowReminderButtonDidTap() {
        Task{ [weak self] in
            
            do{
                guard let self = self else { return }
                            
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: self.date)
                let minute = calendar.component(.minute, from: self.date)
                
                let localNotification = try LocalNotification.Builder()
                    .setContent(title: "Embrace the Start of Your Routine.", body: "A gentle reminder that it's time for your special routine. Enjoy the beginning in a relaxed manner.")
                    .setTimeTrigger(hour: hour, minute: minute, repeats: true)
                    .build()
                                    
                try await notificationManager.localAdapter.registerNotifcation(notification: localNotification)
                PreferenceStorage.shared.setDaliyReminder = true
                PreferenceStorage.shared.daliyReminderDate = self.date                
                try await initTimer()
                await MainActor.run { [weak self] in self?.listener?.AppTutorialTimerDidFinish() }
            }catch{
                Log.e("\(error.localizedDescription)")
            }
            
        }
    }
    
    func notNowButtonDidTap() {
        Task{ [weak self] in
            do{
                guard let self = self else { return }
                try await self.initTimer()
                await MainActor.run { [weak self] in self?.listener?.AppTutorialTimerDidFinish() }
            }catch{
                Log.e("\(error.localizedDescription)")
            }
        }
        
        listener?.AppTutorialTimerDidFinish()
    }
    
    
    //MARK: Private
    private func initTimer() async throws{
        let preference = PreferenceStorage.shared
        if preference.timerSetup{
            return
        }
        
        try await TimerSetup(
            timerApplicationService: dependency.timerApplicationService
        ).initTimer()
        preference.timerSetup = true
    }
    
}
