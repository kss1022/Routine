//
//  RoutineTitleInteractor.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineTitleRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineTitlePresentable: Presentable {
    var listener: RoutineTitlePresentableListener? { get set }
    
    func setRoutineTitle(_ viewModel: RoutineTitleViewModel)
}

protocol RoutineTitleListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}


protocol RoutineTitleInteractorDependency{
    var routineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailDto?>{ get }
}

final class RoutineTitleInteractor: PresentableInteractor<RoutineTitlePresentable>, RoutineTitleInteractable, RoutineTitlePresentableListener {

    weak var router: RoutineTitleRouting?
    weak var listener: RoutineTitleListener?

    private let dependency: RoutineTitleInteractorDependency
    private var cancelables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RoutineTitlePresentable,
        dependency: RoutineTitleInteractorDependency
    ) {
        self.dependency = dependency
        self.cancelables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        dependency.routineDetail
            .receive(on: DispatchQueue.main)
            .sink { detail in
                if let viewModel =  detail.map(RoutineTitleViewModel.init){
                    self.presenter.setRoutineTitle(viewModel)
                }
            }
            .store(in: &cancelables)
    }

    override func willResignActive() {
        super.willResignActive()
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
    }
}
