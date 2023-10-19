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
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
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
                title: "Tabata",
                description: "Tabata Tabata Tabata Tabata Tabata Tabata Tabata Tabata Tabata Tabata",
                imageName: "createYourTimer_1",
                timerType: .tabata,
                tapHandler: { [weak self] in
                    Log.d("Tap Tabata")
                    self?.router?.attachAddYourTimer(timerType: .tabata)
                }),
            CreateTimerModel(
                title: "Round",
                description: "Round Round Round",
                imageName: "createYourTimer_2",
                timerType: .round,
                tapHandler: { [weak self] in
                    Log.d("Tap Round")
                    self?.router?.attachAddYourTimer(timerType: .round)
                }),
            CreateTimerModel(
                title: "Custom",
                description: "Custom",
                imageName: "createYourTimer_3",
                timerType: .custom,
                tapHandler: { [weak self] in
                    Log.d("Tap Custom")
                    self?.router?.attachAddYourTimer(timerType: .custom)
                })
        ]
        
        presenter.setCreateButtons(models.map(CreatTimerViewModel.init))
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    //MARK: AddYourTimer
    func presentationControllerDidDismiss() {
        router?.detachAddYourTimer()
    }
}
