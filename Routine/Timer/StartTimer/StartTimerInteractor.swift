//
//  StartTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/26/23.
//

import ModernRIBs
import Foundation

protocol StartTimerRouting: Routing {
    func cleanupViews()
    
    
    func attachFocusTimer(model: TimerFocusModel)
    func detachFocusTimer()
    
    func attachSectionTimer(model: TimerSectionsModel)
    func detachSectionTimer()
}

protocol StartTimerListener: AnyObject {
    func startTimerDidClose()
}

protocol StarTimerInteractorDependency{
    var timerRepository: TimerRepository{ get }
    var timerId: UUID{ get }
}

final class StartTimerInteractor: Interactor, StartTimerInteractable, AdaptivePresentationControllerDelegate {
    
    
    weak var router: StartTimerRouting?
    weak var listener: StartTimerListener?
    
    private let dependency: StarTimerInteractorDependency
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    
    // in constructor.
    init(dependency: StarTimerInteractorDependency) {
        self.dependency = dependency
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        
        super.init()
        self.presentationDelegateProxy.delegate = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.                
        let timerId = dependency.timerId
        let find = dependency.timerRepository.lists.value.first { $0.timerId ==  timerId}!
        
        if find.timerType == .section{
            Task{ [weak self] in
                guard let self = self else { return }
                do{
                    try await self.dependency.timerRepository.fetchSections(timerId: timerId)
                    
                    guard let sections =  self.dependency.timerRepository.sections.value else {
                        await MainActor.run { self.listener?.startTimerDidClose() }
                        return
                    }
                    await MainActor.run { [weak self] in self?.router?.attachSectionTimer(model: sections) }
                }catch{
                    Log.e("\(error)")
                }
            }
        }else{
            Task{ [weak self] in
                guard let self = self else { return }
                do{
                    try await self.dependency.timerRepository.fetchFocus(timerId: timerId)
                    guard let focus = self.dependency.timerRepository.focus.value else {
                        
                        await MainActor.run { self.listener?.startTimerDidClose() }
                        return
                    }
                    
                    await MainActor.run { [weak self] in self?.router?.attachFocusTimer(model: focus) }
                }catch{
                    Log.e("\(error)")
                }
            }
            
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
    func focusTimerDidTapClose() {
        //router?.detachFocusTimer()
        listener?.startTimerDidClose()
    }
    
    
    //MARK: SectionTimer
    func sectionTimerDidTapClose() {
        //router?.detachSectionTimer()
        listener?.startTimerDidClose()
    }
    

    
}
