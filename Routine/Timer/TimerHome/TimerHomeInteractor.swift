//
//  TimerHomeInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import Foundation
import ModernRIBs
import Combine

protocol TimerHomeRouting: ViewableRouting {
    func attachTimerList()
    
    
    func attachCreateTimer()
    func detachCreateTimer()
    
    func attachStartTimer(timerId: UUID)
    func detachStartTimer()
}

protocol TimerHomePresentable: Presentable {
    var listener: TimerHomePresentableListener? { get set }
    func showError(title: String, message: String)
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
    private var cancellables: Set<AnyCancellable>
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    
    private var isCreate: Bool
    private var isStart: Bool
    
    // in constructor.
    init(
        presenter: TimerHomePresentable,
        dependency: TimerHomeInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.isCreate = false
        self.isStart = false
        super.init(presenter: presenter)
        presenter.listener = self
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()   
        
        Log.v("Timer Home DidBecome Active ⏰")
        
        router?.attachTimerList()
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await self.dependency.timerRepository.fetchLists()
            }catch{
                Log.e(error.localizedDescription)
                await self.showFetchListFailed()
            }
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func presentationControllerDidDismiss() {
        if isCreate{
            isCreate = false
            router?.detachCreateTimer()
            return
        }
        
        if isStart{
            isStart = false
            router?.detachStartTimer()
            return
        }
    }
    
    
    //MARK: TimerList
    func timerListTimerDidTap(timerId: UUID) {        
        self.isStart = true
        self.router?.attachStartTimer(timerId: timerId)
    }
    
    
    //MARK: CreateTimer
    func creatTimerButtonDidTap() {
        isCreate = true
        router?.attachCreateTimer()
    }
    
    func createTimerCloseButtonDidTap() {
        isCreate = false
        router?.detachCreateTimer()
    }
    
    func createTimerDidAddNewTimer() {
        isCreate = false
        router?.detachCreateTimer()
    }
    

    //MARK: StartTimer
    func startTimerDidClose() {
        self.isStart = false
        router?.detachStartTimer()
    }
    
}


private extension TimerHomeInteractor{
    @MainActor
    func showFetchListFailed(){
        let title = "try_again_later".localized(tableName: "Timer")
        let message = "fetch_list_failed".localized(tableName: "Timer")
        presenter.showError(title: title, message: message)
    }
}
