//
//  TimerHomeInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import ModernRIBs

protocol TimerHomeRouting: ViewableRouting {
    func attachCreateTimer()
    func detachCreateTimer()
    
    func attachTimerDetail()
    func detachTimerDetail()
    
    func attachTimerList()
}

protocol TimerHomePresentable: Presentable {
    var listener: TimerHomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol TimerHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol TimerHomeInteractorDependency{
    var timerRepository: TimerRepository{ get }
}

final class TimerHomeInteractor: PresentableInteractor<TimerHomePresentable>, TimerHomeInteractable, TimerHomePresentableListener, AdaptivePresentationControllerDelegate {

    

    weak var router: TimerHomeRouting?
    weak var listener: TimerHomeListener?
    
    private let dependency: TimerHomeInteractorDependency
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    private var isCreate: Bool
    
    
    // in constructor.
    init(
        presenter: TimerHomePresentable,
        dependency: TimerHomeInteractorDependency
    ) {
        self.dependency = dependency
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.isCreate = false
        super.init(presenter: presenter)
        presenter.listener = self
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachTimerList()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    //MARK: CreateTimer
    func creatTimerBarButtonDidTap() {
        isCreate = true
        router?.attachCreateTimer()
    }
    
    func createTimerDismiss() {
        isCreate = false
        router?.detachCreateTimer()
    }
    
    //MARK: TimerDetail
    func timerDetailDidTapClose() {
        router?.detachTimerDetail()
    }
    
    //MARK: TimerList
    func timerListDidSelectAt(timerId: UUID) {
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await self.dependency.timerRepository.fetchSectionLists(timerId: timerId)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.router?.attachTimerDetail()
                }
            }catch{
                Log.e("\(error)")
            }
        }
    }
    
    
    func presentationControllerDidDismiss() {
        if isCreate{
            isCreate = false
            router?.detachCreateTimer()
        }else{
            router?.detachTimerDetail()
        }
    }
    

    
    
    
    
}
