//
//  CreateTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs


protocol CreateTimerRouting: ViewableRouting {
    func attachAddYourTimer(timerType: AddTimerType)
    func detachAddYourTimer()
}

protocol CreateTimerPresentable: Presentable {
    var listener: CreateTimerPresentableListener? { get set }
    func setCreateButtons(_ viewModels: [CreatTimerViewModel])
}

protocol CreateTimerListener: AnyObject {
    func createTimerCloseButtonDidTap()
    func createTimerDidAddNewTimer()
}

final class CreateTimerInteractor: PresentableInteractor<CreateTimerPresentable>, CreateTimerInteractable, CreateTimerPresentableListener, AdaptivePresentationControllerDelegate {
    

    weak var router: CreateTimerRouting?
    weak var listener: CreateTimerListener?
    
    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy

    
    // in constructor.
    override init(presenter: CreateTimerPresentable) {
        presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        super.init(presenter: presenter)
        presentationDelegateProxy.delegate = self
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        let models = [
            CreateTimerModel(
                title: "focus".localized(tableName: "Timer"),
                description: "Focus",
                imageName: "createYourTimer_3",
                timerType: .focus,
                tapHandler: { [weak self] in
                    self?.router?.attachAddYourTimer(timerType: .focus)
                }),
            CreateTimerModel(
                title: "tabata".localized(tableName: "Timer"),
                description: "Tabata",
                imageName: "createYourTimer_1",
                timerType: .tabata,
                tapHandler: { [weak self] in
                    self?.router?.attachAddYourTimer(timerType: .tabata)
                }),
            CreateTimerModel(
                title: "round".localized(tableName: "Timer"),
                description: "Round",
                imageName: "createYourTimer_2",
                timerType: .round,
                tapHandler: { [weak self] in
                    self?.router?.attachAddYourTimer(timerType: .round)
                })
        ]
        
        presenter.setCreateButtons(models.map(CreatTimerViewModel.init))
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func presentationControllerDidDismiss() {     
    }
    
    func closeButtonDidTap() {
        listener?.createTimerCloseButtonDidTap()
    }
    
    //MARK: AddYourTimer
    
    func addYourTimerDidClose() {
        router?.detachAddYourTimer()        
    }
    
    func addYourTimerDidAddNewTimer() {
        router?.detachAddYourTimer()
        listener?.createTimerDidAddNewTimer()
    }
    
}
