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
    func attachCreateTimer()
    func detachCreateTimer()
    
    func attachStartTimer(timerId: UUID)
    func detachStartTimer()
    
    func attachSelectTimer()
    func detachSelectTimer()
}

protocol TimerHomePresentable: Presentable {
    var listener: TimerHomePresentableListener? { get set }
    
    func setTimer(name: String, time: String)
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
    private var isSelect: Bool
    
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
        self.isSelect = false
        super.init(presenter: presenter)
        presenter.listener = self
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()   
        
        Log.v("Timer Home DidBecome Active ⏰")
        
        Task{
            try? await dependency.timerRepository.fetchLists()
        }
        
        
        dependency.timerRepository.lists
            .receive(on: DispatchQueue.main)
            .sink { list  in
                if PreferenceStorage.shared.timerId.isEmpty{
                    if let focusTimer = list.first(where: { $0.timerType == .focus }){
                        PreferenceStorage.shared.timerId = focusTimer.timerId.uuidString
                    }
                }
                
                let timerId = PreferenceStorage.shared.timerId
                if let currentTimer = list.first(where: { $0.timerId.uuidString == timerId }){
                    let time: String
                    if currentTimer.timerCountdown == nil{
                        time = currentTimer.name
                    }else{
                        time = "\(currentTimer.timerCountdown!)"
                    }
                    
                    self.presenter.setTimer(name: currentTimer.name, time: time)
                }
            }
            .store(in: &cancellables)

    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
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
    
    //MARK: StartTimer
    func startTimerButtonDidTap() {
        let timerId = UUID(uuidString: PreferenceStorage.shared.timerId)!
        self.isStart = true
        self.router?.attachStartTimer(timerId: timerId)
    }
    
    func startTimerDidClose() {
        self.isStart = false
        router?.detachStartTimer()
    }
    
    // MARK: SelectTimer
    func currentTimerButtonDidTap() {
        self.isSelect = true
        router?.attachSelectTimer()
    }
    
    func timerDetailDidTapClose() {
        self.isSelect = false
        router?.detachStartTimer()
    }
    
    func timerSelectDidSelectItem(timerId: UUID) {
        let preference = PreferenceStorage.shared
        preference.timerId = timerId.uuidString
                
        if let currentTimer = dependency.timerRepository.lists.value.first(where: { $0.timerId.uuidString == timerId.uuidString }){
            let time: String
            if currentTimer.timerCountdown == nil{
                time = currentTimer.name
            }else{
                time = "\(currentTimer.timerCountdown!)"
            }
            
            self.presenter.setTimer(name: currentTimer.name, time: time)
        }
        
        self.isSelect = true
        router?.detachSelectTimer()
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
        
        if isSelect{
            isSelect = false
            router?.detachSelectTimer()
            return
        }
        
    }
    

    
    
    
    
}
