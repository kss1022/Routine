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
    func setTint(pos: Int)
}

protocol RoutineTintListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func routineTintSetTint(color: String)
}

protocol RoutineTintInteractorDependency{
    var routineRepository : RoutineRepository { get }
    var detail: RoutineDetailModel?{ get }
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
            
        let tints = dependency.routineRepository.tints.map { $0.hex }
        
        if tints.count == 0{
            fatalError()
        }
                
        presenter.setTints(tints: tints)
        
        let currentTint = dependency.detail?.tint ?? "#FFCCCCFF"
        let pos = tints.firstIndex(of: currentTint) ?? 0
        self.presenter.setTint(pos: pos)
        self.listener?.routineTintSetTint(color: currentTint)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func tintButtonDidTap(color: String) {
        listener?.routineTintSetTint(color: color)
    }
}
