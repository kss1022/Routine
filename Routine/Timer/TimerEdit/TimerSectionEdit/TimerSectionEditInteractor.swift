//
//  TimerSectionEditInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import Foundation
import ModernRIBs

protocol TimerSectionEditRouting: ViewableRouting {
    func attachTimerSectionEditTitle()
    func attachTimerEditCountDown()
}

protocol TimerSectionEditPresentable: Presentable {
    var listener: TimerSectionEditPresentableListener? { get set }
}

protocol TimerSectionEditListener: AnyObject {
    func timerSectionEditDidMoved()
}

protocol TimerSectionEditInteractorDependency{
    var sectionList: TimerSectionListViewModel{ get }
    var sectionListsSubject: CurrentValuePublisher<[TimerSectionListModel]>{ get }
}

final class TimerSectionEditInteractor: PresentableInteractor<TimerSectionEditPresentable>, TimerSectionEditInteractable, TimerSectionEditPresentableListener {
    

    weak var router: TimerSectionEditRouting?
    weak var listener: TimerSectionEditListener?
    
    private let dependency: TimerSectionEditInteractorDependency

    private var name: String
    private var description: String
    private var value: TimerSectionValueModel
    
    
    // in constructor.
    init(
        presenter: TimerSectionEditPresentable,
        dependency: TimerSectionEditInteractorDependency
    ) {
        self.dependency = dependency
        self.name = dependency.sectionList.name
        self.description = dependency.sectionList.description
        self.value = dependency.sectionList.value
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachTimerSectionEditTitle()
        router?.attachTimerEditCountDown()
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
    func timerSectionEditValueSetCount(count: Int) {
        self.value = .count(count: count)
        updateList()
    }
    
    func timerSectionEditValueSetCountdown(min: Int, sec: Int) {
        self.value = .countdown(min: min, sec: sec)
        updateList()
    }
        
    func updateList(){
        var lists = dependency.sectionListsSubject.value
        var before = dependency.sectionList
        
        let newModel = TimerSectionListModel(
            emoji: before.emoji,
            name: self.name,
            description: self.description, 
            sequence: before.sequence,
            type: before.type,
            value: self.value,
            color: before.color?.toHex()
        )
        
        lists[before.sequence] = newModel
        dependency.sectionListsSubject.send(lists)        
    }

}
