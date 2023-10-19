//
//  TimerSectionListInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import ModernRIBs
import Foundation

protocol TimerSectionListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerSectionListPresentable: Presentable {
    var listener: TimerSectionListPresentableListener? { get set }
    func setSections(_ viewModels: [TimerSectionListViewModel])

}

protocol TimerSectionListListener: AnyObject {
    func timeSectionListDidSelectRowAt(viewModel: TimerSectionListViewModel)
}

protocol TimerSectionListInternalDependency{
    var timerType: AddTimerType{ get }
}

final class TimerSectionListInteractor: PresentableInteractor<TimerSectionListPresentable>, TimerSectionListInteractable, TimerSectionListPresentableListener {

    weak var router: TimerSectionListRouting?
    weak var listener: TimerSectionListListener?

    
    private let dependency: TimerSectionListInternalDependency
    
    // in constructor.
    init(
        presenter: TimerSectionListPresentable,
        dependency: TimerSectionListInternalDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        var models = listModels()
                                
        
        presenter.setSections(models.map(TimerSectionListViewModel.init))
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    //MARK: Listener
    func tableViewDidSelectRowAt(viewModel: TimerSectionListViewModel) {
        listener?.timeSectionListDidSelectRowAt(viewModel: viewModel)
    }
    
    private func listModels() -> [TimerSectionListModel]{
        if dependency.timerType == .custom{
            return []
        }
        
        var models = [
            TimerSectionListModel(
                id: UUID(),
                emoji: "🔥",
                name: "Ready",
                description: "Before start countdown",
                value: .countdown(min: 0, sec: 5)
            ),TimerSectionListModel(
                id: UUID(),
                emoji: "🧘‍♂️",
                name: "Take a rest",
                description: "Take a rest",
                value: .countdown(min: 1, sec: 10),
                color: "#3BD2AEff"
            ),TimerSectionListModel(
                id: UUID(),
                emoji: "🏃",
                name: "Excercise",
                description: "You can do it!!!",
                value: .countdown(min: 0, sec: 5),
                color: "#3BD2AEff"
            )]
        
        if dependency.timerType == .round{
            models.append(contentsOf: [
                TimerSectionListModel(
                    id: UUID(),
                    emoji: "⛳️",
                    name: "Round",
                    description: "Round is excersise and take a rest",
                    value: .count(count: 3)
                ),
                TimerSectionListModel(
                    id: UUID(),
                    emoji: "❄️",
                    name: "Cool Down",
                    description: "After excersice cool down",
                    value: .countdown(min: 0, sec: 30)
                )
            ])
            
            return models
        }
        
        if dependency.timerType == .tabata{
            models.append(contentsOf: [
                TimerSectionListModel(
                    id: UUID(),
                    emoji: "⛳️",
                    name: "Round",
                    description: "Round is excersise + rest",
                    value: .count(count: 3)
                ),
                TimerSectionListModel(
                    id: UUID(),
                    emoji: "🔄",
                    name: "Cycle",
                    description: "Cycle is \(3) round",
                    value: .count(count: 3),
                    color: "#6200EEFF"
                ),
                TimerSectionListModel(
                    id: UUID(),
                    emoji: "🧘‍♀️",
                    name: "Cycle Rest",
                    description: "Take a rest",
                    value: .countdown(min: 0, sec: 30),
                    color: "#6200EEFF"
                ),
                TimerSectionListModel(
                    id: UUID(),
                    emoji: "❄️",
                    name: "Cool Down",
                    description: "After excersice cool down",
                    value: .countdown(min: 0, sec: 30)
                )
            ])
            
            return models
        }
        
        fatalError("Some types do not handle.")
    }
}
