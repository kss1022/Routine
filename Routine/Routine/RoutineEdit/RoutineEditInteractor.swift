//
//  RoutineEditInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/1/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineEditRouting: ViewableRouting {
    func attachRoutineTitle()
    func attachRoutineTint()
    func attachRoutineEmojiIcon()
    func attachRoutineRepeat()
    func attachRoutineReminder()
}

protocol RoutineEditPresentable: Presentable {
    var listener: RoutineEditPresentableListener? { get set }
    func setTint(_ color: String)
}

protocol RoutineEditListener: AnyObject {
    func routineEditDoneButtonDidTap()
    func routineEditDeleteButtonDidTap()
}

protocol RoutineEditInteractorDependency{
    
    var routineId: UUID{ get }
    
    var routineApplicationService: RoutineApplicationService{ get }
    var routineRepository: RoutineRepository{ get }
    
    var detail: RoutineDetailModel?{ get }
    var emojiSubject: CurrentValuePublisher<String>{ get }
}

final class RoutineEditInteractor: PresentableInteractor<RoutineEditPresentable>, RoutineEditInteractable, RoutineEditPresentableListener {

    weak var router: RoutineEditRouting?
    weak var listener: RoutineEditListener?

    private var cancelables: Set<AnyCancellable>
    private let dependency: RoutineEditInteractorDependency
    
    private var name: String
    private var description: String
    
    private var repeatType: RepeatTypeViewModel
    private var repeatValue: RepeatValueViewModel
    
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
        self.cancelables = .init()
        self.dependency = dependency
        
        let detail = dependency.detail!
        name = detail.routineName
        description = detail.routineName
        repeatType = RepeatTypeViewModel(rawValue: detail.repeatType.rawValue)!
        repeatValue = RepeatValueViewModel(
            type: detail.repeatType,
            value: detail.repeatValue
        )!
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
        router?.attachRoutineTint()
        router?.attachRoutineEmojiIcon()
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
    }
    
    func doneButtonDidTap() {
        let updateRoutine = UpdateRoutine(
            routineId: dependency.routineId,
            name: name,
            description: description,
            repeatType: repeatType.rawValue,
            reminderTime: reminderIsON ? (reminderHour!, reminderMinute!) : nil,
            repeatValue: repeatValue.rawValue(),
            emoji: emoji,
            tint: tint
        )
        
        Task{
            do{
                try await dependency.routineApplicationService.when(updateRoutine)
                try await dependency.routineRepository.fetchLists()
                try await dependency.routineRepository.fetchDetail(dependency.routineId)
                await MainActor.run{ listener?.routineEditDoneButtonDidTap() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
            }
        }
    }
    
    func deleteBarButtonDidTap() {
        let deleteRoutine = DeleteRoutine(routineId: dependency.routineId)
        
        Task{
            do{
                try await dependency.routineApplicationService.when(deleteRoutine)
                try await dependency.routineRepository.fetchLists()
                await MainActor.run{ listener?.routineEditDeleteButtonDidTap() }
            }catch{
                Log.e("\(error)")
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
    
    //MARK: RoutineEditRepeat
    func routineEditRepeatSetType(type: RepeatTypeViewModel) {
        self.repeatType = type
    }
    
    func routineEditRepeatSetValue(value: RepeatValueViewModel) {
        self.repeatValue = value
    }
            
    //MARK: RoutineEditReminder
    func routineReminderValueChange(isOn: Bool, hour: Int?, minute: Int?) {
        self.reminderIsON = isOn
        self.reminderHour = hour
        self.reminderMinute = minute
    }
    
    
    //MARK: RoutineTint
    func routineTintSetTint(color: String) {
        self.tint = color
        self.presenter.setTint(tint)
    }
    

    //MARK: RoutineEmoji
    func routineEmojiSetEmoji(emoji: String) {
        self.emoji = emoji
        self.dependency.emojiSubject.send(emoji)
    }
    

    
}
