//
//  TimerHomeInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

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

final class TimerHomeInteractor: PresentableInteractor<TimerHomePresentable>, TimerHomeInteractable, TimerHomePresentableListener, AdaptivePresentationControllerDelegate {

    

    weak var router: TimerHomeRouting?
    weak var listener: TimerHomeListener?
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    private var isCreate: Bool
    
    
    // in constructor.
    override init(presenter: TimerHomePresentable) {
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
    
    //MARK: TimerDetail
    func timerDetailDidTapClose() {
        router?.detachTimerDetail()
    }
    
    //MARK: TimerList
    func timerListDidSelectAt() {
        router?.attachTimerDetail()
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
