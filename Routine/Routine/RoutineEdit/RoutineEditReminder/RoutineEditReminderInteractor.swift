//
//  RoutineEditReminderInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/13/23.
//

import Foundation
import ModernRIBs

protocol RoutineEditReminderRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineEditReminderPresentable: Presentable {
    var listener: RoutineEditReminderPresentableListener? { get set }
    
    func setToogle(on: Bool)
    func setDate(date: Date)


    
    func showTimePikcer()
    func hideTimePicker()
    
    func setSubTitle(subTitle: String)
}

protocol RoutineEditReminderListener: AnyObject {
    func routineReminderValueChange(isOn: Bool, hour: Int?, minute: Int?)
}

protocol RoutineEditReminderInteractorDependency{
    var detail: RoutineDetailModel?{ get }
}

final class RoutineEditReminderInteractor: PresentableInteractor<RoutineEditReminderPresentable>, RoutineEditReminderInteractable, RoutineEditReminderPresentableListener {

    weak var router: RoutineEditReminderRouting?
    weak var listener: RoutineEditReminderListener?

    private var isON: Bool
    private var date: Date
    
    private let dependency: RoutineEditReminderInteractorDependency
    
    // in constructor.
    init(
        presenter: RoutineEditReminderPresentable,
        dependency: RoutineEditReminderInteractorDependency
    ) {
        self.dependency = dependency
        self.isON = dependency.detail?.reminderIsON ?? false
        if let hour = dependency.detail?.reminderHour,
           let minute = dependency.detail?.reminderMinute{
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let calendar = Calendar.current
            self.date = calendar.date(from: dateComponents)!
            presenter.setDate(date: self.date)
        }else{
            self.date = Date()
        }

        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
                
        presenter.setToogle(on: isON)
        
        if isON{
            presenter.showTimePikcer()
            presenter.setDate(date: date)
        }                
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    //MARK: Listener
    func reminderToogleValueChange(isON: Bool) {
        self.isON = isON
        
        isON ? presenter.showTimePikcer() : presenter.hideTimePicker()
        handleValueChange()
    }
    
    func reminderTimePickerValueChange(date: Date) {
        self.date = date
        handleValueChange()
    }
    
    private func handleValueChange(){
        if !isON{
            listener?.routineReminderValueChange(isOn: false, hour: nil, minute: nil)
            presenter.setSubTitle(subTitle: "Set a reminder")
            return
        }
        
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        listener?.routineReminderValueChange(isOn: true, hour: hour, minute: minute)
        
        let subTitle = Formatter.reminderDateFormatter().string(from: date)
        presenter.setSubTitle(subTitle: subTitle)
    }
}