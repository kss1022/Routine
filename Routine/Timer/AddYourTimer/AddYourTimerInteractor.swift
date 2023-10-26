//
//  AddYourTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs
import Foundation

protocol AddYourTimerRouting: ViewableRouting {
    func attachTimerSectionEdit(sectionList: TimerSectionListViewModel)
    func detachTimerSectionEdit()
    
    func attachTimerEditTitle()
    func attachTimerSectionListection()
}

protocol AddYourTimerPresentable: Presentable {
    var listener: AddYourTimerPresentableListener? { get set }
    func setTitle(title: String)
}

protocol AddYourTimerListener: AnyObject {
    func addYourTimeDoneButtonDidTap()
}

protocol AddYourTimeInteractorDependency{
    var timerApplicationService: TimerApplicationService{ get }
    var timerRepository: TimerRepository{ get }
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ get }
    var timerType: AddTimerType{ get }
}

final class AddYourTimerInteractor: PresentableInteractor<AddYourTimerPresentable>, AddYourTimerInteractable, AddYourTimerPresentableListener {


    weak var router: AddYourTimerRouting?
    weak var listener: AddYourTimerListener?

    private let dependency: AddYourTimeInteractorDependency
    private var name: String
    
    // in constructor.
    init(
        presenter: AddYourTimerPresentable,
        dependency: AddYourTimeInteractorDependency
    ) {
        self.dependency = dependency
        self.name = dependency.timerType.name
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachTimerEditTitle()
        router?.attachTimerSectionListection()
        presenter.setTitle(title: dependency.timerType.title)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    //MARK: TimerEditTitle
    func timerEditTitleSetName(name: String) {
        self.name = name
    }
    
    
    //MARK: TimerSectionList
    func timeSectionListDidSelectRowAt(sectionList: TimerSectionListViewModel) {
        router?.attachTimerSectionEdit(sectionList: sectionList)
    }
    
    //MARK: TimerSectionEdit
    func timerSectionEditDidMoved() {
        router?.detachTimerSectionEdit()
    }
    
    func doneBarButtonDidTap() {
        let createSections = dependency.sectionLists.value.enumerated().map { (sequence, section) in
            CreateSection(
                name: section.name,
                description: section.description,
                sequence: sequence,
                type: section.type.rawValue,
                min: section.value.min,
                sec: section.value.sec,
                count: section.value.count,
                emoji: section.emoji,
                color: section.tint
            )
        }
        
        let createTimer = CreateSectionTimer(
            name: self.name,
            createSections: createSections
        )
        
        
        Task{
            do{
                try await dependency.timerApplicationService.when(createTimer)
                try await dependency.timerRepository.fetchLists()
                await MainActor.run { listener?.addYourTimeDoneButtonDidTap() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
            }
        }
        
    }
}
 
