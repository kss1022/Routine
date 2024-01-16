//
//  TimerSectionInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol SectionTimerRouting: ViewableRouting {
    func attachTimerRemian()
    func attachSectionRoundTimer()
    func attachTimerNextSection()
}

protocol SectionTimerPresentable: Presentable {
    var listener: SectionTimerPresentableListener? { get set }
    func setTitle(title: String)
}

protocol SectionTimerListener: AnyObject {
    func sectionTimerDidTapClose()
}

protocol SectionTimerInteractorDependency{
    var model: SectionTimerModel{ get }
}

final class SectionTimerInteractor: PresentableInteractor<SectionTimerPresentable>, SectionTimerInteractable, SectionTimerPresentableListener {

    weak var router: SectionTimerRouting?
    weak var listener: SectionTimerListener?

    private let dependency: SectionTimerInteractorDependency
    private var sectionIndex = 0
    
    // in constructor.
    init(
        presenter: SectionTimerPresentable,
        dependency: SectionTimerInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachTimerRemian()
        router?.attachSectionRoundTimer()
        router?.attachTimerNextSection()

        
        presenter.setTitle(title: dependency.model.timerName)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    func closeButtonDidTap() {
        listener?.sectionTimerDidTapClose()
    }
    

    //MARK: SectionRoundTimer
    func sectionRoundDidTapCancle() {
        listener?.sectionTimerDidTapClose()
    }

}
