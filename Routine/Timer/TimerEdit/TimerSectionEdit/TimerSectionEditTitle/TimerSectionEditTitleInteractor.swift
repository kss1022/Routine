//
//  TimerSectionEditTitleInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs

protocol TimerSectionEditTitleRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerSectionEditTitlePresentable: Presentable {
    var listener: TimerSectionEditTitlePresentableListener? { get set }
    func setTitle(emoji: String, name: String, description: String)
}

protocol TimerSectionEditTitleListener: AnyObject {
    func timerSectionEditTitleSetName(name: String)
    func timerSectionEditTitleSetDescription(description: String)
}

protocol TimerSectionEditTitleInteractorDependency{
    var sectionList: TimerSectionListViewModel{ get }
}

final class TimerSectionEditTitleInteractor: PresentableInteractor<TimerSectionEditTitlePresentable>, TimerSectionEditTitleInteractable, TimerSectionEditTitlePresentableListener {

    weak var router: TimerSectionEditTitleRouting?
    weak var listener: TimerSectionEditTitleListener?

    private let dependency: TimerSectionEditTitleInteractorDependency
    
    // in constructor.
    init(
        presenter: TimerSectionEditTitlePresentable,
        dependency: TimerSectionEditTitleInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        let sectionList = dependency.sectionList
        
        presenter.setTitle(
            emoji: sectionList.emoji,
            name: sectionList.name,
            description: sectionList.description
        )
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func sectionNameDidEndEditing(name: String) {
        listener?.timerSectionEditTitleSetName(name: name)
    }
    
    func sectionDescriptionDidEndEditing(description: String) {
        listener?.timerSectionEditTitleSetDescription(description: description)
    }
}
