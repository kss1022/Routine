//
//  TimerSectionListInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import Foundation
import ModernRIBs
import Combine

protocol TimerSectionListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerSectionListPresentable: Presentable {
    var listener: TimerSectionListPresentableListener? { get set }
    func setSections(_ viewModels: [TimerSectionListViewModel])

}

protocol TimerSectionListListener: AnyObject {    
    func timeSectionListDidTap(sectionList: TimerSectionListModel)
}

protocol TimerSectionListInternalDependency{
    var sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ get }
}

final class TimerSectionListInteractor: PresentableInteractor<TimerSectionListPresentable>, TimerSectionListInteractable, TimerSectionListPresentableListener {

    weak var router: TimerSectionListRouting?
    weak var listener: TimerSectionListListener?
    
    private let dependency: TimerSectionListInternalDependency
    private let sectionLists: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>

    
    private var cancellables: Set<AnyCancellable>
        
    // in constructor.
    init(
        presenter: TimerSectionListPresentable,
        dependency: TimerSectionListInternalDependency
    ) {
        self.dependency = dependency
        self.sectionLists = dependency.sectionLists
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        dependency.sectionLists.receive(on: DispatchQueue.main)
            .sink { lists in
                self.presenter.setSections(lists.map(TimerSectionListViewModel.init))
            }
            .store(in: &cancellables)

    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    //MARK: Listener
    func tableViewDidTap(row: Int) {
        let sectionList = sectionLists.value[row]
        listener?.timeSectionListDidTap(sectionList: sectionList)
    }

}
