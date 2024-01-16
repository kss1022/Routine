//
//  TimerEditInteractor.swift
//  Routine
//
//  Created by 한현규 on 1/16/24.
//

import Foundation
import ModernRIBs
import Combine

protocol TimerEditRouting: Routing {
    func cleanupViews()
    
    func attachEditFocusTimer(timerId: UUID)
    func detachEditFocusTimer()
    
    func attachEditTabataTimer(timerId: UUID)
    func detachEditTabataTimer()
    
    func attachEditRoundTimer(timerId: UUID)
    func detachEditRoundTimer()
}

protocol TimerEditListener: AnyObject {
    func timerEditDidClose()
    func timerEditDidFinish()
}

protocol TimerEditInteractorDependency{
    var timerRepository: TimerRepository{ get }
    var focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>{ get }
    var tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>{ get }
    var roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>{ get }
}

final class TimerEditInteractor: Interactor, TimerEditInteractable, AdaptivePresentationControllerDelegate {
 
    

     
    weak var router: TimerEditRouting?
    weak var listener: TimerEditListener?
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy

    private let dependency: TimerEditInteractorDependency
    private let timerRepository: TimerRepository
    
    private let focusTimerSubject: CurrentValueSubject<FocusTimerModel?, Error>
    private let tabataTimerSubject: CurrentValueSubject<TabataTimerModel?, Error>
    private let roundTimerSubject: CurrentValueSubject<RoundTimerModel?, Error>
    
    private let timerId: UUID
    
    init(
        dependency: TimerEditInteractorDependency,
        timerId: UUID
    ){
        self.dependency = dependency        
        self.timerRepository = dependency.timerRepository
        self.focusTimerSubject = dependency.focusTimerSubject
        self.tabataTimerSubject = dependency.tabataTimerSubject
        self.roundTimerSubject = dependency.roundTimerSubject
        self.presentationDelegateProxy = .init()
        self.timerId = timerId
        super.init()
        self.presentationDelegateProxy.delegate = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
                
        let timer = dependency.timerRepository.lists.value.first{ $0.timerId == self.timerId }!
        if timer.timerType == .focus{
            self.showFocus()
            return
        }
        
        switch timer.timerType {
        case .focus:
            self.showFocus()
        case .tabata:
            self.showFocus()
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
        listener?.timerEditDidClose()
    }
    
    
    //MARK: Focus
    func editFocusTimerDidTapClose() {
        router?.detachEditFocusTimer()
        listener?.timerEditDidClose()
    }
    
    func editfocusTimerDidEditTimer() {
        router?.detachEditFocusTimer()
        listener?.timerEditDidFinish()
    }
    
    func editfocusTimerCancel() {
        router?.detachEditFocusTimer()
        listener?.timerEditDidFinish()
    }
    
    //MARK: Tabata
    func editTabataTimerDidTapClose() {
        router?.detachEditTabataTimer()
        listener?.timerEditDidClose()
    }
    
    func editTabataTimerDidAddFinish() {
        router?.detachEditTabataTimer()
        listener?.timerEditDidFinish()
    }
    
    func editTabataTimerDidCancel() {
        router?.detachEditTabataTimer()
        listener?.timerEditDidFinish()
    }
    
    //MARK: Round
    func editRoundTimerDidTapClose() {
        router?.detachEditRoundTimer()
        listener?.timerEditDidClose()
    }
    
    func editRoundTimerDidAddFinish() {
        router?.detachEditRoundTimer()
        listener?.timerEditDidFinish()
    }
    
    func editRoundTimerDidCancel() {
        router?.detachEditRoundTimer()
        listener?.timerEditDidFinish()
    }
    
    private func showFocus(){
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                let focusTimer = try await dependency.timerRepository.focus(timerId: timerId)
                if focusTimer == nil{
                    throw TimerException.couldNotFindTimer
                }
                
                focusTimerSubject.send(focusTimer!)
            }catch{
                try? await Task.sleep(nanoseconds: UInt64(1e9))
                focusTimerSubject.send(completion: .failure(error))
            }
        }
        
        router?.attachEditFocusTimer(timerId: timerId)
    }
    
    private func showTabata(){
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                let tabataTimer = try await self.dependency.timerRepository.tabata(timerId: timerId)
                if tabataTimer == nil{
                    throw TimerException.couldNotFindTimer
                }
                tabataTimerSubject.send(tabataTimer!)
            }catch{
                try? await Task.sleep(nanoseconds: UInt64(1e9))
                tabataTimerSubject.send(completion: .failure(error))
            }
        }
        router?.attachEditTabataTimer(timerId: timerId)
    }
    
    private func showRound(){
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                let tabataTimer = try await self.dependency.timerRepository.round(timerId: timerId)
                if tabataTimer == nil{
                    throw TimerException.couldNotFindTimer
                }
                roundTimerSubject.send(tabataTimer!)
            }catch{
                try? await Task.sleep(nanoseconds: UInt64(1e9))
                roundTimerSubject.send(completion: .failure(error))
            }
        }
        router?.attachEditRoundTimer(timerId: timerId)
    }
}
