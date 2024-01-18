//
//  TimerSectionEditInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import Foundation
import ModernRIBs

protocol TimerSectionEditRouting: ViewableRouting {
    func attachTimerSectionEditTitle(emoji: String, name: String, description: String)
    
    func attachTimerSectionEditTime(min: Int, sec: Int)
    func attachTimerSectionEditRepeat(repeat: Int)
}

protocol TimerSectionEditPresentable: Presentable {
    var listener: TimerSectionEditPresentableListener? { get set }
}

protocol TimerSectionEditListener: AnyObject {
    func timerSectionEditDidMoved()
}

protocol TimerSectionEditInteractorDependency{
    var sectionListsSubject: CurrentValuePublisher<[TimerSectionListModel]>{ get }
}

final class TimerSectionEditInteractor: PresentableInteractor<TimerSectionEditPresentable>, TimerSectionEditInteractable, TimerSectionEditPresentableListener {

    
    weak var router: TimerSectionEditRouting?
    weak var listener: TimerSectionEditListener?
    
    private let dependency: TimerSectionEditInteractorDependency

    private var sectionList: TimerSectionListModel
    
    private var emoji: String
    private var name: String
    private var description: String
    private var type: TimerSectionTypeModel
    private var value: TimerSectionValueModel
    
    // in constructor.
    init(
        presenter: TimerSectionEditPresentable,
        dependency: TimerSectionEditInteractorDependency,
        sectionList: TimerSectionListModel
    ) {
        self.dependency = dependency
        self.sectionList = sectionList
        self.emoji = sectionList.emoji
        self.name = sectionList.name
        self.description = sectionList.description
        self.type = sectionList.type
        self.value = sectionList.value
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        router?.attachTimerSectionEditTitle(emoji: sectionList.emoji, name: sectionList.name, description: sectionList.description)
        
        switch sectionList.value {
        case .countdown(let min, let sec):
            router?.attachTimerSectionEditTime(min: min, sec: sec)
        case .count(let count):
            router?.attachTimerSectionEditRepeat(repeat: count)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didMoved() {
        listener?.timerSectionEditDidMoved()
    }
    
    
    // MARK: TimerSectionEditTitle
    func timerSectionEditTitleSetName(name: String) {
        self.name = name
        updateList()
    }
    
    func timerSectionEditTitleSetDescription(description: String) {
        self.description = description
        updateList()
    }
    
    // MARK: TimerSectionEditValue
    func timerSectionEditTimeDidSetTime(min: Int, sec: Int) {
        self.value = .countdown(min: min, sec: sec)
        updateList()
    }
    
    func timerSectionEditRepeatDidSetRepeat(repeat: Int) {
        self.value = .count(count: `repeat`)
        updateList()
    }
        
    func updateList(){
        var lists = dependency.sectionListsSubject.value
                        
    
        for i in 0..<lists.count{
            let list = lists[i]
            
            if list.type == sectionList.type{
                //find
                let newModel = TimerSectionListModel(
                    name: name,
                    description: description,
                    emoji: emoji,
                    tint: sectionList.tint,
                    type: sectionList.type,
                    value: value
                )
                lists[i] = newModel
            }
        }
        
        dependency.sectionListsSubject.send(lists)
    }

}
