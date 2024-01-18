//
//  StartTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import Foundation
import ModernRIBs
import Combine

protocol StartTimerRouting: Routing {
    func cleanupViews()
        
    func attachFocusTimer()
    func detachFocusTimer()
    
    func attachTabataTimer()
    func detachTabataTimer()
    
    func attachRoundTimer()
    func detachRoundTimer()
}

protocol StartTimerListener: AnyObject {
    func startTimerDidClose()
    func startTimerDidFinish()
}

protocol StarTimerInteractorDependency{
    var timerRepository: TimerRepository{ get }
    
    var focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>{ get }
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ get }
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ get }
}

final class StartTimerInteractor: Interactor, StartTimerInteractable, AdaptivePresentationControllerDelegate {

 
    
    
    weak var router: StartTimerRouting?
    weak var listener: StartTimerListener?
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    
    private let dependency: StarTimerInteractorDependency
    private let timerRepository: TimerRepository
    
    private let focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>
    private let tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>
    private let roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>
    
    private let timerId: UUID
    
    // in constructor.
    init(dependency: StarTimerInteractorDependency, timerId: UUID) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        self.dependency = dependency
        self.timerRepository = dependency.timerRepository
        self.focusTimerSubject = dependency.focusTimerSubject
        self.tabataTimerSubject = dependency.tabataTimerSubject
        self.roundTimerSubject = dependency.roundTimerSubject
        self.timerId = timerId
        super.init()
        self.presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        let timer = dependency.timerRepository.lists.value.first { $0.timerId ==  timerId}!
        
        switch timer.timerType {
        case .focus:
            self.showFocus()
        case .tabata:
            self.showTabata()
        case .round:
            self.showRound()
        }
    }
    
    
    override func willResignActive() {
        super.willResignActive()
        
        router?.cleanupViews()
        // TODO: Pause any business logic.
    }
    
    func presentationControllerDidDismiss() {
        listener?.startTimerDidClose()
    }
    
    
    //MARK: FocusTimer
    func focusTimerDidCancel() {
        router?.detachFocusTimer()
        listener?.startTimerDidFinish()
    }
    

    func focusTimerDidTapClose() {
        router?.detachFocusTimer()
        listener?.startTimerDidClose()
    }
    
    func focusTimerDidTapCancel() {
        router?.detachFocusTimer()
        listener?.startTimerDidClose()
    }
    

    
    //MARK: Tabata
    func tabataTimerDidCancel() {
        router?.detachTabataTimer()
        listener?.startTimerDidFinish()
    }
    
    
    func tabataTimerDidTapClose() {
        router?.detachTabataTimer()
        listener?.startTimerDidClose()
    }
    
    func tabataTimerDidTapCancel() {
        router?.detachTabataTimer()
        listener?.startTimerDidClose()
    }
    
    //MARK: Round    
    func roundTimerDidCancel() {
        router?.detachRoundTimer()
        listener?.startTimerDidFinish()
    }
    
    func roundTimerDidTapClose() {
        router?.detachRoundTimer()
        listener?.startTimerDidClose()
    }
    
    func roundTimerDidTapCancel() {
        router?.detachRoundTimer()
        listener?.startTimerDidClose()
    }
    
    private func showFocus(){
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                let focus = try await timerRepository.focus(timerId: timerId)
                
                if focus == nil{
                    throw TimerException.couldNotFindTimer
                }
                
                focusTimerSubject.send(focus!)
            }catch{
                try? await Task.sleep(nanoseconds: UInt64(1e9))
                focusTimerSubject.send(completion: .failure(error))
            }
        }
        
        router?.attachFocusTimer()
    }
    
    private func showTabata(){
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                let tabata = try await timerRepository.tabata(timerId: timerId)
                
                if tabata == nil{
                    throw TimerException.couldNotFindTimer
                }
                
                tabataTimerSubject.send(tabata!)
            }catch{
                try? await Task.sleep(nanoseconds: UInt64(1e9))
                tabataTimerSubject.send(completion: .failure(error))
            }
        }
        
        router?.attachTabataTimer()
    }
    
    private func showRound(){
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                let round = try await timerRepository.round(timerId: timerId)
                
                if round == nil{
                    throw TimerException.couldNotFindTimer
                }
                
                roundTimerSubject.send(round!)
            }catch{
                try? await Task.sleep(nanoseconds: UInt64(1e9))
                roundTimerSubject.send(completion: .failure(error))
            }
        }
        
        router?.attachRoundTimer()
    }

    
}
