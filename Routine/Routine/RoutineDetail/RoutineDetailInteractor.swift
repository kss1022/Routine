//
//  RoutineDetailInteractor.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineDetailRouting: ViewableRouting {
    func attachRoutineEdit(routineId: UUID)
    func detachRoutineEdit(dissmiss: Bool)
    
    func attachRoutineTitle()
}

protocol RoutineDetailPresentable: Presentable {
    var listener: RoutineDetailPresentableListener? { get set }
    func setBackgroundColor(_ tint: String)
}

protocol RoutineDetailListener: AnyObject {
    func routineDetailDidMoved()
}

protocol RoutineDetailInteractorDependency{
    var routineId: UUID{ get }
    var routineDetail: ReadOnlyCurrentValuePublisher<RoutineDetailDto?>{ get }
}

final class RoutineDetailInteractor: PresentableInteractor<RoutineDetailPresentable>, RoutineDetailInteractable, RoutineDetailPresentableListener, AdaptivePresentationControllerDelegate {
            
    weak var router: RoutineDetailRouting?
    weak var listener: RoutineDetailListener?
        
    let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
        
    private let dependency : RoutineDetailInteractorDependency
    private var cancelables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RoutineDetailPresentable,
        dependency: RoutineDetailInteractorDependency
    ) {
        self.dependency = dependency
        self.cancelables = .init()
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init(presenter: presenter)
        presenter.listener = self
        self.presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachRoutineTitle()
    
        dependency.routineDetail
            .receive(on: DispatchQueue.main)
            .sink { detail in
                if detail?.routineId != self.dependency.routineId{
                    fatalError()
                }
                self.presenter.setBackgroundColor(detail!.tint)
            }
            .store(in: &cancelables)
    }
    
    override func willResignActive() {
        super.willResignActive()
        cancelables.forEach { $0.cancel() }
        cancelables.removeAll()
    }
    
    func didMoved() {
        listener?.routineDetailDidMoved()
    }
    
    func editButtonDidTap() {
        router?.attachRoutineEdit(routineId: dependency.routineId)
    }
    
    func presentationControllerDidDismiss() {
        router?.detachRoutineEdit(dissmiss: false)
    }
    
    func routineEditDoneButtonDidTap() {
        router?.detachRoutineEdit(dissmiss: true)
    }
}
