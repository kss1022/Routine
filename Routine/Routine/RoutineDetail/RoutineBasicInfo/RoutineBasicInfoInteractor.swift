//
//  RoutineBasicInfoInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineBasicInfoRouting: ViewableRouting {}

protocol RoutineBasicInfoPresentable: Presentable {
    var listener: RoutineBasicInfoPresentableListener? { get set }
    func repeatInfo(info: String)
    func reminderInfo(info: String)
}

protocol RoutineBasicInfoListener: AnyObject {
}

protocol RoutineBasicInfoInteractorDependency{
    var routineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailModel?>{ get }
}

final class RoutineBasicInfoInteractor: PresentableInteractor<RoutineBasicInfoPresentable>, RoutineBasicInfoInteractable, RoutineBasicInfoPresentableListener {

    weak var router: RoutineBasicInfoRouting?
    weak var listener: RoutineBasicInfoListener?

    private var cancellables: Set<AnyCancellable>
    private let dependency: RoutineBasicInfoInteractorDependency
    
    // in constructor.
    init(
        presenter: RoutineBasicInfoPresentable,
        depdendency: RoutineBasicInfoInteractorDependency
    ) {
        self.cancellables = .init()
        self.dependency = depdendency
        super.init(presenter: presenter)
        presenter.listener = self
        
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.routineDetail
            .receive(on: DispatchQueue.main)
            .sink {
                if let detail = $0{
                    self.setRepeatInfo(detail: detail)
                    self.setReminderInfo(detail: detail)
                }
            }
            .store(in: &cancellables)
        
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    private func setRepeatInfo(detail: RoutineDetailModel){
        switch detail.repeatModel {
        case .doitOnce(let date):
            let dateInfo =  Formatter.routineBasicInfoFormatter.string(from: date)
            self.presenter.repeatInfo(info: "basic_info_doItOnce".localizedWithFormat(tableName: "Routine", arguments: dateInfo))
        case .daliy:
            self.presenter.repeatInfo(info: "basic_info_daliy".localized(tableName: "Routine"))
        case .weekly(let weekly):
            let weekDaySimbols = Calendar.current.shortStandaloneWeekdaySymbols
            let weeklyInfo =  weekly.sorted { $0 < $1 }
                .map{ weekDaySimbols[$0] }
                .joined(separator: ", ")
            self.presenter.repeatInfo(info: "basic_info_weekly".localizedWithFormat(tableName: "Routine", arguments: weeklyInfo))
        case .monthly(let monthly):
            let monthlyInfo =  monthly.sorted { $0 < $1 }
                .map(String.init)
                .joined(separator: ", ")
            
            self.presenter.repeatInfo(info: "basic_info_Monthly".localizedWithFormat(tableName: "Routine", arguments: monthlyInfo))
        }
    }
    
    private func setReminderInfo(detail: RoutineDetailModel){
        if !detail.reminderIsON{
            self.presenter.reminderInfo(info: "basic_info_did_not_set_reminder".localized(tableName: "Routine"))
            return
        }

        
        var dateComponent = DateComponents()
        dateComponent.hour = detail.reminderHour
        dateComponent.minute = detail.reminderMinute
                
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponent)!
        
        let reminders = Formatter.reminderDateFormatter().string(from: date)
        self.presenter.reminderInfo(info: "basic_info_reminder_at".localizedWithFormat(tableName: "Routine", arguments: reminders))
    }
}
