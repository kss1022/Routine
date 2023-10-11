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
        
    var titleSubject: CurrentValuePublisher<String>{ get }
    var descriptionSubject: CurrentValuePublisher<String>{ get }
    
    var repeatType: ReadOnlyCurrentValuePublisher<RepeatTypeViewModel>{ get }
    var repeatValue: ReadOnlyCurrentValuePublisher<RepeatValueViewModel>{ get }

    var tint: ReadOnlyCurrentValuePublisher<String>{ get }
    var tintSubject: CurrentValuePublisher<String>{ get }
        
    var emojiSubject: CurrentValuePublisher<String>{ get }
}

final class RoutineEditInteractor: PresentableInteractor<RoutineEditPresentable>, RoutineEditInteractable, RoutineEditPresentableListener {

    weak var router: RoutineEditRouting?
    weak var listener: RoutineEditListener?

    private var cancelables: Set<AnyCancellable>
    private let dependency: RoutineEditInteractorDependency
    
    // in constructor.
    init(
        presenter: RoutineEditPresentable,
        dependency: RoutineEditInteractorDependency
    ) {
        self.cancelables = .init()
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachRoutineTitle()
        router?.attachRoutineRepeat()
        router?.attachRoutineTint()
        router?.attachRoutineEmojiIcon()
        
        dependency.tint
            .receive(on: DispatchQueue.main)
            .sink { tint in
                self.presenter.setTint(tint)
            }
            .store(in: &cancelables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
    }
    
    func doneButtonDidTap() {
        let updateRoutine = UpdateRoutine(
            routineId: dependency.routineId,
            name: dependency.titleSubject.value,
            description: dependency.descriptionSubject.value,
            repeatType: dependency.repeatType.value.rawValue,
            repeatValue: dependency.repeatValue.value.rawValue(),
            emoji: dependency.emojiSubject.value,
            tint: dependency.tintSubject.value
        )
        
        Task{
            do{
                try await dependency.routineApplicationService.when(updateRoutine)
                try await dependency.routineRepository.fetchLists()
                try await dependency.routineRepository.fetchDetail(dependency.routineId)
                await MainActor.run{ listener?.routineEditDoneButtonDidTap() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.msg)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
            }
        }
    }
    
    func deleteButtonDidTap() {
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
}
