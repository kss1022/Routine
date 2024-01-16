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
}

final class TimerSectionEditTitleInteractor: PresentableInteractor<TimerSectionEditTitlePresentable>, TimerSectionEditTitleInteractable, TimerSectionEditTitlePresentableListener {

    weak var router: TimerSectionEditTitleRouting?
    weak var listener: TimerSectionEditTitleListener?

    private let dependency: TimerSectionEditTitleInteractorDependency
    
    private let emoji: String
    private let name: String
    private let description: String
    
    // in constructor.
    init(
        presenter: TimerSectionEditTitlePresentable,
        dependency: TimerSectionEditTitleInteractorDependency,
        emoji: String,
        name: String,
        description: String
    ) {
        self.dependency = dependency
        self.emoji = emoji
        self.name = name
        self.description = description
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        presenter.setTitle(
            emoji: emoji,
            name: name,
            description: description
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
