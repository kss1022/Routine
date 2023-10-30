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
    func attachRoutineTint()
    func attachRoutineEmojiIcon()
    func attachRoutineRepeat()
    func attachRoutineReminder()
}

protocol AddYourRoutinePresentable: Presentable {
    var listener: AddYourRoutinePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func setTint(_ color: String)
}

protocol AddYourRoutineListener: AnyObject {
    func addYourRoutineCloseButtonDidTap()
    func addYourRoutineDoneButtonDidTap()
}

protocol AddYourRoutineInteractorDependency{
    var routineApplicationService: RoutineApplicationService{ get }
    var routineRepository: RoutineRepository{ get }
    var emojiSubject: CurrentValuePublisher<String>{ get }
}

final class AddYourRoutineInteractor: PresentableInteractor<AddYourRoutinePresentable>, AddYourRoutineInteractable, AddYourRoutinePresentableListener {
    

    weak var router: AddYourRoutineRouting?
    weak var listener: AddYourRoutineListener?

    private var cancellables: Set<AnyCancellable>
    private let dependency: AddYourRoutineInteractorDependency
    
    
    
    private var name: String? = nil
    private var description: String? = nil
    
    private var repeatType: RepeatTypeViewModel = .daliy
    private var repeatValue: RepeatValueViewModel = .daliy
    
    private var reminderIsON: Bool = false
    private var reminderHour: Int? = nil
    private var reminderMinute: Int? = nil
    
    private var tint: String? = nil
    private var emoji: String? = nil
    
    
    // in constructor.
    init(
        presenter: AddYourRoutinePresentable,
        dependency: AddYourRoutineInteractorDependency
    ) {
        self.cancellables = .init()
        self.dependency = dependency
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
            repeatType: repeatType.rawValue,
            repeatValue: repeatValue.rawValue(),
            reminderTime: reminderIsON ? (reminderHour!, reminderMinute!) : nil,
            emoji: emoji ?? "",
            tint: tint ?? ""
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
                }else{
                    Log.e("UnkownError\n\(error)" )
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
        self.presenter.setTint(tint!)
    }
    
    //MARK: RoutineEmoji
    func routineEmojiSetEmoji(emoji: String) {
        self.emoji = emoji        
        self.dependency.emojiSubject.send(emoji)
    }
    
}
