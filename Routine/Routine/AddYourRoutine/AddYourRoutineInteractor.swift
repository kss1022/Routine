//
//  AddYourRoutineInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import Foundation
import ModernRIBs
import Combine

protocol AddYourRoutineRouting: ViewableRouting {
    func attachRoutineTitle()    
    func attachRoutineRepeat()
    func attachRoutineReminder()
    func attachRoutineStyle()
}

protocol AddYourRoutinePresentable: Presentable {
    var listener: AddYourRoutinePresentableListener? { get set }

    func setTint(_ color: String)
    func showError(title: String, message: String)
}

protocol AddYourRoutineListener: AnyObject {
    func addYourRoutineCloseButtonDidTap()
    func addYourRoutineDoneButtonDidTap()
}

protocol AddYourRoutineInteractorDependency{
    var routineApplicationService: RoutineApplicationService{ get }
    var routineRepository: RoutineRepository{ get }
    
    var detail: RoutineDetailModel?{ get }
}

final class AddYourRoutineInteractor: PresentableInteractor<AddYourRoutinePresentable>, AddYourRoutineInteractable, AddYourRoutinePresentableListener {

    

    weak var router: AddYourRoutineRouting?
    weak var listener: AddYourRoutineListener?

    private var cancellables: Set<AnyCancellable>
    private let dependency: AddYourRoutineInteractorDependency
    
    
    
    private var name: String? = nil
    private var description: String? = nil
        
    private var repeatModel: RepeatModel = .daliy
    
    private var reminderIsON: Bool = false
    private var reminderHour: Int? = nil
    private var reminderMinute: Int? = nil
    
    private var tint: String
    private var emoji: String
    
    
    // in constructor.
    init(
        presenter: AddYourRoutinePresentable,
        dependency: AddYourRoutineInteractorDependency
    ) {
        cancellables = .init()
        self.dependency = dependency
        
        let detail = dependency.detail
        tint = detail?.tint ?? "#A8ADBAFF"
        emoji = detail?.emojiIcon ?? "🍎"
        
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
        
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    //TODO: check input date (null check)
    func closeButtonDidTap() {
        listener?.addYourRoutineCloseButtonDidTap()
    }
    
    func doneBarButtonDidTap() {
        let createRoutine = CreateRoutine(
            name: name ?? "",
            description: description ?? "",
            repeatType: repeatModel.rawValue(),
            repeatValue: repeatModel.value(),
            reminderTime: reminderIsON ? (reminderHour!, reminderMinute!) : nil,
            emoji: emoji,
            tint: tint
        )
         
        Task{ [weak self] in
            guard let self = self else { return
            }
            do{
                try await self.dependency.routineApplicationService.when(createRoutine)
                try await self.dependency.routineRepository.fetchLists()
                await MainActor.run{ self.listener?.addYourRoutineDoneButtonDidTap() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                    await self.showAddRoutineFailed()
                }else{
                    Log.e("UnkownError\n\(error)" )
                    await self.showSystemFailed()
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
        repeatModel = `repeat`
    }        
    
    //MARK: RoutineEditReminder
    func routineReminderValueChange(isOn: Bool, hour: Int?, minute: Int?) {
        reminderIsON = isOn
        reminderHour = hour
        reminderMinute = minute
    }
    
    //MARK: RoutineEditStyle

    func routineEditStyleDidSetStyle(style: EmojiStyle) {
        tint = style.hex
        presenter.setTint(tint)
    }

}



// MARK: Error Message
private extension AddYourRoutineInteractor{
    
    @MainActor
    func showAddRoutineFailed(){
        let title = "oops".localized(tableName: "Routine")
        let message = "add_routine_failed".localized(tableName: "Routine")
        presenter.showError(title: title, message: message)
    }
    
    @MainActor
    func showSystemFailed(){
        let title = "error".localized(tableName: "Routine")
        let message = "sorry_there_are_proble_with_request".localized(tableName: "Routine")
        presenter.showError(title: title, message: message)
    }

}
