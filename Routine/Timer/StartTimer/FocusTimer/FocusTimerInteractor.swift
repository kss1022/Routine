//
//  FocusTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/27/23.
//

import Foundation
import ModernRIBs

protocol FocusTimerRouting: ViewableRouting {
    func attachFocusRoundTimer()
}

protocol FocusTimerPresentable: Presentable {
    var listener: FocusTimerPresentableListener? { get set }
    func setTitle(title: String)
    func setResumeBaackground()
    func setSuspendBackground()
    func showFinishTimer()
}

protocol FocusTimerListener: AnyObject {
    func focusTimerDidTapClose()
}

protocol FocusTimerInteractorDependency{
    var recordApplicationService: RecordApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    var model: TimerFocusModel{ get }
}

final class FocusTimerInteractor: PresentableInteractor<FocusTimerPresentable>, FocusTimerInteractable, FocusTimerPresentableListener {


    weak var router: FocusTimerRouting?
    weak var listener: FocusTimerListener?
    
    private let dependency: FocusTimerInteractorDependency
    
    // in constructor.
    init(
        presenter: FocusTimerPresentable,
        dependency: FocusTimerInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachFocusRoundTimer()
        
        presenter.setTitle(title: dependency.model.timerName)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func closeButtonDidTap() {
        listener?.focusTimerDidTapClose()
    }
    
    // MARK: FocusRoundTimer
    
    func focusRoundTimerDidStartTimer(startAt: Date) {
        let createRecord = CreateTimerRecord(
            timerId: dependency.model.timerId,
            startAt: startAt
        )
        
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                try await self.dependency.recordApplicationService.when(createRecord)
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
            }
            
        }
        
        
        presenter.setResumeBaackground()
    }
    
    func focusRoundTimerDidResume() {
        presenter.setResumeBaackground()
    }
    
    func focusRoundTimerDidSuspend() {
        presenter.setSuspendBackground()
    }
    
    func focusRoundTimerDidTapCancle() {
        listener?.focusTimerDidTapClose()
    }
    
    
    func focusRoundTimerDidFinish(startAt: Date, endAt: Date, duration: Double) {
    
        Task{ [weak self] in
            guard let self = self else { return }
            do{
                guard let recordId = try await dependency.timerRepository.recordId(timerId: dependency.model.timerId, startAt: startAt) else {
                    Log.e("Can't find RecordId: \(dependency.model.timerId) \(startAt)")
                    return
                }
                
                let setComplete = SetCompleteTimerRecord(
                    recordId: recordId,
                    endAt: Date(),
                    duration: duration
                )
                
                try await dependency.recordApplicationService.when(setComplete)
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
            }
        }

        presenter.showFinishTimer()
    }
        
}
