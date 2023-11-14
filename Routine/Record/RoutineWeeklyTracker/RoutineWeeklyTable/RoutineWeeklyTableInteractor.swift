//
//  RoutineWeeklyTableInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineWeeklyTableRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineWeeklyTablePresentable: Presentable {
    var listener: RoutineWeeklyTablePresentableListener? { get set }
    func setWeeklyTable(_ viewModels: [WeeklyTableViewModel])
}

protocol RoutineWeeklyTableListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineWeeklyTableInteractorDependency{
    var routineWeeklyTrackers: ReadOnlyCurrentValuePublisher<[RoutineWeeklyTrackerModel]>{ get }
}

final class RoutineWeeklyTableInteractor: PresentableInteractor<RoutineWeeklyTablePresentable>, RoutineWeeklyTableInteractable, RoutineWeeklyTablePresentableListener {

    weak var router: RoutineWeeklyTableRouting?
    weak var listener: RoutineWeeklyTableListener?

    private let dependency: RoutineWeeklyTableInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RoutineWeeklyTablePresentable,
        dependency: RoutineWeeklyTableInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.routineWeeklyTrackers
            .receive(on: DispatchQueue.main)
            .sink { models in
                let viewModels = models.map(WeeklyTableViewModel.init)
                self.presenter.setWeeklyTable(viewModels)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}


//let viewModels = [
//    WeeklyTableViewModel(
//        title: "Take medicine",
//        emoji: "💊",
//        tint: "#FFCCCCFF",
//        sunday: Bool.random(),
//        monday: Bool.random(),
//        tuesday: Bool.random(),
//        wednesday: Bool.random(),
//        thursday: Bool.random(),
//        friday: Bool.random(),
//        saturday: Bool.random()
//    ),
//    WeeklyTableViewModel(
//        title: "Running",
//        emoji: "🏃",
//        tint: "#FFFFCCFF",
//        sunday: Bool.random(),
//        monday: Bool.random(),
//        tuesday: Bool.random(),
//        wednesday: Bool.random(),
//        thursday: Bool.random(),
//        friday: Bool.random(),
//        saturday: Bool.random()
//    ),
//    WeeklyTableViewModel(
//        title: "Exercise",
//        emoji: "💪",
//        tint: "#E5CCFFFF",
//        sunday: Bool.random(),
//        monday: Bool.random(),
//        tuesday: Bool.random(),
//        wednesday: Bool.random(),
//        thursday: Bool.random(),
//        friday: Bool.random(),
//        saturday: Bool.random()
//    ),
//    WeeklyTableViewModel(
//        title: "Keep a diary",
//        emoji: "✍️",
//        tint: "#FFCCE5FF",
//        sunday: Bool.random(),
//        monday: Bool.random(),
//        tuesday: Bool.random(),
//        wednesday: Bool.random(),
//        thursday: Bool.random(),
//        friday: Bool.random(),
//        saturday: Bool.random()
//    ),
//    WeeklyTableViewModel(
//        title: "Driving",
//        emoji: "🚗",
//        tint: "#CCFFFFFF",
//        sunday: Bool.random(),
//        monday: Bool.random(),
//        tuesday: Bool.random(),
//        wednesday: Bool.random(),
//        thursday: Bool.random(),
//        friday: Bool.random(),
//        saturday: Bool.random()
//    ),
//    WeeklyTableViewModel(
//        title: "Drink water",
//        emoji: "💧",
//        tint: "#FFCCCCFF",
//        sunday: Bool.random(),
//        monday: Bool.random(),
//        tuesday: Bool.random(),
//        wednesday: Bool.random(),
//        thursday: Bool.random(),
//        friday: Bool.random(),
//        saturday: Bool.random()
//    ),
//    WeeklyTableViewModel(
//        title: "Study hard",
//        emoji: "📖",
//        tint: "#C0C0C0FF",
//        sunday: Bool.random(),
//        monday: Bool.random(),
//        tuesday: Bool.random(),
//        wednesday: Bool.random(),
//        thursday: Bool.random(),
//        friday: Bool.random(),
//        saturday: Bool.random()
//    ),
//    WeeklyTableViewModel(
//        title: "Walk a dog",
//        emoji: "🦮",
//        tint: "#E09FFFFF",
//        sunday: Bool.random(),
//        monday: Bool.random(),
//        tuesday: Bool.random(),
//        wednesday: Bool.random(),
//        thursday: Bool.random(),
//        friday: Bool.random(),
//        saturday: Bool.random()
//    ),
//    WeeklyTableViewModel(
//        title: "Basketball",
//        emoji: "🏀",
//        tint: "#FFE5CCFF",
//        sunday: Bool.random(),
//        monday: Bool.random(),
//        tuesday: Bool.random(),
//        wednesday: Bool.random(),
//        thursday: Bool.random(),
//        friday: Bool.random(),
//        saturday: Bool.random()
//    ),
//    WeeklyTableViewModel(
//        title: "Beer",
//        emoji: "🍻",
//        tint: "#CCFFCCFF",
//        sunday: Bool.random(),
//        monday: Bool.random(),
//        tuesday: Bool.random(),
//        wednesday: Bool.random(),
//        thursday: Bool.random(),
//        friday: Bool.random(),
//        saturday: Bool.random()
//    ),
//]
