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
    func attachRoutingTitle()
}

protocol RoutineEditPresentable: Presentable {
    var listener: RoutineEditPresentableListener? { get set }
    func setTint(_ color: String)
}

protocol RoutineEditListener: AnyObject {
    func routineEditDoneButtonDidTap()
}

protocol RoutineEditInteractorDependency{
    
    var routineId: UUID{ get }
    
    var routineApplicationService: RoutineApplicationService{ get }
    var routineRepository: RoutineRepository{ get }
        
    var titleSubject: CurrentValuePublisher<String>{ get }
        
    var descriptionSubject: CurrentValuePublisher<String>{ get }

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
        
        self.router?.attachRoutingTitle()
        
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
        let changeRoutineName = ChangeRoutineName(
            routineId: dependency.routineId,
            routineName: dependency.titleSubject.value
        )
        
        Task{
            do{
                try await dependency.routineApplicationService.when(changeRoutineName)
                try await dependency.routineRepository.fetchRoutineLists()
                try await dependency.routineRepository.fetchRoutineDetail(dependency.routineId)
                await MainActor.run{ listener?.routineEditDoneButtonDidTap() }
            }catch{
                Log.e("\(error)")
            }
        }
    }
}
