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
    
    func attachTimerSection()
    func detachTimerSection()
    
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
    
    
    //private var isCreate: Bool
    private var isDetail: Bool
    
    // in constructor.
    init(
        presenter: TimerHomePresentable,
        dependency: TimerHomeInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        //self.isCreate = false
        self.isDetail = false
        super.init(presenter: presenter)
        presenter.listener = self
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()   
        
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
        //isCreate = true
        //router?.attachCreateTimer()
    }
    
    func createTimerDismiss() {
        //isCreate = false
        //router?.detachCreateTimer()
    }
    
    //MARK: TimerDetail
    func startTimerButtonDidTap() {
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await self.dependency.timerRepository.fetchDetail(timerId: UUID(uuidString: PreferenceStorage.shared.timerId)!)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.isDetail = true
                    self.router?.attachTimerSection()
                }
            }catch{
                Log.e("\(error)")
            }
        }
    }
    
    // MARK: SelectTimer
    func currentTimerButtonDidTap() {
        router?.attachSelectTimer()
    }
    
    func timerDetailDidTapClose() {
        router?.detachTimerSection()
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
        
        router?.detachSelectTimer()
    }
        
    
    func presentationControllerDidDismiss() {
//        if isCreate{
//            isCreate = false
//            router?.detachCreateTimer()
//        }else{
//            router?.detachTimerSection()
//        }
        if isDetail{
            isDetail = false
            router?.detachTimerSection()
        }else{
            router?.detachSelectTimer()
        }
    }
    

    
    
    
    
}
