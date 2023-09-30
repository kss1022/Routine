//
//  RoutineTintInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import ModernRIBs
import Combine

protocol RoutineTintRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineTintPresentable: Presentable {
    var listener: RoutineTintPresentableListener? { get set }
    
    func setTints(tints: [String])
}

protocol RoutineTintListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineTintInteractorDependency{
    var tintSubject: CurrentValuePublisher<String>{ get }
    var routineReadModel: RoutineReadModelFacade{ get }
}

final class RoutineTintInteractor: PresentableInteractor<RoutineTintPresentable>, RoutineTintInteractable, RoutineTintPresentableListener {

    weak var router: RoutineTintRouting?
    weak var listener: RoutineTintListener?

    private var cancelables: Set<AnyCancellable>
    private let dependency: RoutineTintInteractorDependency
    
    // in constructor.
    init(
        presenter: RoutineTintPresentable,
        dependency: RoutineTintInteractorDependency
    ) {
        self.cancelables = .init()
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
            
        let tints = dependency.routineReadModel.tints.map { $0.hex }
        
        if tints.count == 0{
            fatalError()
        }
        
        dependency.tintSubject.send(tints[0])
        presenter.setTints(tints: tints)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func tintButtonDidTap(color: String) {
        dependency.tintSubject.send(color)
    }
}
