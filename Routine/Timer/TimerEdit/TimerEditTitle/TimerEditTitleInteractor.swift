//
//  TimerEditTitleInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import ModernRIBs

protocol TimerEditTitleRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerEditTitlePresentable: Presentable {
    var listener: TimerEditTitlePresentableListener? { get set }
    func setName(_ name: String)
    func setEmoji(_ emoji: String)
}

protocol TimerEditTitleListener: AnyObject {
    func timerEditTitleDidSetEmoji(emoji: String)
    func timerEditTitleDidSetName(name: String)
}

final class TimerEditTitleInteractor: PresentableInteractor<TimerEditTitlePresentable>, TimerEditTitleInteractable, TimerEditTitlePresentableListener {


    weak var router: TimerEditTitleRouting?
    weak var listener: TimerEditTitleListener?
    
    private let name: String
    private let emoji: String
        
    // in constructor.
    init(
        presenter: TimerEditTitlePresentable,
        name: String,
        emoji: String
    ) {
        self.name = name
        self.emoji = emoji
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        presenter.setName(name)
        presenter.setEmoji(emoji)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didSetName(name: String) {
        listener?.timerEditTitleDidSetName(name: name)
    }
    
    func didSetEmoji(emoji: String) {
        presenter.setEmoji(emoji)
        listener?.timerEditTitleDidSetEmoji(emoji: emoji)
    }
    
}
