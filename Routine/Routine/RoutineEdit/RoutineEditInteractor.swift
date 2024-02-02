//
//  RoutineEditInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/1/23.
//

import Foundation
import ModernRIBs

protocol RoutineEditRouting: ViewableRouting {
    func attachRoutineTitle()
    func attachRoutineRepeat()
    func attachRoutineReminder()
    func attachRoutineStyle()
}

protocol RoutineEditPresentable: Presentable {
    var listener: RoutineEditPresentableListener? { get set }
    func setTint(_ color: String)
    
    
    func showError(title: String, message: String)
}

protocol RoutineEditListener: AnyObject {
    func routineEditCloseButtonDidTap()
    func routineEditDoneButtonDidTap()
    func routineEditDeleteButtonDidTap()
}

protocol RoutineEditInteractorDependency{
    
    var routineId: UUID{ get }
    
    var routineApplicationService: RoutineApplicationService{ get }
    var routineRepository: RoutineRepository{ get }
    var routineRecordRepository: RoutineRecordRepository{ get }
    
    var detail: RoutineDetailModel?{ get }
}

final class RoutineEditInteractor: PresentableInteractor<RoutineEditPresentable>, RoutineEditInteractable, RoutineEditPresentableListener {
    
    
    weak var router: RoutineEditRouting?
    weak var listener: RoutineEditListener?
    
    private let dependency: RoutineEditInteractorDependency
    
    private var name: String
    private var description: String
    
    private var repeatModel: RepeatModel
    
    private var reminderIsON: Bool = false
    private var reminderHour: Int?
    private var reminderMinute: Int?
    
    private var tint: String
    private var emoji: String
    
    
    // in constructor.
    init(
        presenter: RoutineEditPresentable,
        dependency: RoutineEditInteractorDependency
    ) {
        self.dependency = dependency
        
        let detail = dependency.detail!
        name = detail.routineName
        description = detail.routineName
        repeatModel = detail.repeatModel
        reminderIsON = detail.reminderIsON
        reminderHour = detail.reminderHour
        reminderMinute = detail.reminderMinute
        tint = detail.tint
        emoji = detail.emojiIcon
        
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachRoutineTitle()
        router?.attachRoutineRepeat()
        router?.attachRoutineReminder()
        router?.attachRoutineStyle()
        
        presenter.setTint(tint)
    }
    
    override func willResignActive() {
        super.willResignActive()
        
    }
    
    func closeButtonDidTap() {
        listener?.routineEditCloseButtonDidTap()
    }
    
    func doneButtonDidTap() {
        let updateRoutine = UpdateRoutine(
            routineId: dependency.routineId,
            name: name,
            description: description,
            repeatType: repeatModel.rawValue(),
            repeatValue: repeatModel.value(),
            reminderTime: reminderIsON ? (reminderHour!, reminderMinute!) : nil,
            emoji: emoji,
            tint: tint
        )
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.routineApplicationService.when(updateRoutine)
                try await dependency.routineRepository.fetchLists()
                try await dependency.routineRepository.fetchDetail(dependency.routineId)
                try await dependency.routineRecordRepository.fetchList()
                await MainActor.run{ [weak self] in self?.listener?.routineEditDoneButtonDidTap() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                    await showUpdateRoutineFailed()
                }else{
                    Log.e("UnkownError\n\(error)" )
                    await showSystemFailed()
                }
            }
        }
    }
    
    func deleteBarButtonDidTap() {
        let deleteRoutine = DeleteRoutine(routineId: dependency.routineId)
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await dependency.routineApplicationService.when(deleteRoutine)
                try await dependency.routineRepository.fetchLists()
                try await dependency.routineRecordRepository.fetchList()
                await MainActor.run{ [weak self] in self?.listener?.routineEditDeleteButtonDidTap() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                    await showDeleteRoutineFailed()
                }else{
                    Log.e("UnkownError\n\(error)" )
                    await showSystemFailed()
                }
                
            }
        }
    }
    
    //MARK: RoutineEditTitle
    func routineEditTitleSetName(name: String) {
        self.name = name
    }
    
    func routineEditTitleSetDescription(description: String) {
        self.description = description
    }
    
    func routineEditTitleDidSetEmoji(emoji: String) {
        self.emoji = emoji
    }
    
    
    //MARK: RoutineEditRepeat
    func routineEditRepeatDidSetRepeat(repeat: RepeatModel) {
        self.repeatModel = `repeat`
    }
    
    //MARK: RoutineEditReminder
    func routineReminderValueChange(isOn: Bool, hour: Int?, minute: Int?) {
        self.reminderIsON = isOn
        self.reminderHour = hour
        self.reminderMinute = minute
    }
    
    
    //MARK: RoutineEditStyle
    func routineEditStyleDidSetStyle(style: EmojiStyle) {
        self.tint = style.hex
        self.presenter.setTint(tint)
    }
    
}

private extension RoutineEditInteractor{
    
    @MainActor
    func showUpdateRoutineFailed() {
        let title = "oops".localized(tableName: "Routine")
        let message = "update_routine_failed".localized(tableName: "Routine")
        presenter.showError(title: title, message: message)
    }
    
    @MainActor
    func showDeleteRoutineFailed() {
        let title = "oops".localized(tableName: "Routine")
        let message = "delete_routine_failed".localized(tableName: "Routine")
        presenter.showError(title: title, message: message)
    }
    
    @MainActor
    func showSystemFailed(){
        let title = "error".localized(tableName: "Routine")
        let message = "sorry_there_are_proble_with_request".localized(tableName: "Routine")
        presenter.showError(title: title, message: message)
    }
    
}
