//
//  AppTutorialRoutineInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import ModernRIBs

protocol AppTutorialRoutineRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AppTutorialRoutinePresentable: Presentable {
    var listener: AppTutorialRoutinePresentableListener? { get set }
    func setList(_ viewModels: [TutorialRoutineListViewModel])
    
    func showContinueButton()
    func hideContinueButton()
}

protocol AppTutorialRoutineListener: AnyObject {
    func appTutorailRoutineDidFinish()
}

protocol AppTutorialRoutineInteractorDependency{
    var routineApplicationService: RoutineApplicationService{ get }
}

final class AppTutorialRoutineInteractor: PresentableInteractor<AppTutorialRoutinePresentable>, AppTutorialRoutineInteractable, AppTutorialRoutinePresentableListener {

    weak var router: AppTutorialRoutineRouting?
    weak var listener: AppTutorialRoutineListener?

    private let dependency: AppTutorialRoutineInteractorDependency
    
    private var models: [CreateRoutineModel]!
    private var rows: Set<Int>
    
    // in constructor.
    init(
        presenter: AppTutorialRoutinePresentable,
        dependency: AppTutorialRoutineInteractorDependency
    ) {
        self.dependency = dependency
        self.rows = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        let models = [
            CreateRoutineModel(
                name: "Drink water",
                description: "Drink water",
                repeatModel: .daliy,
                reminderTime: nil,
                emoji: "💧",
                tint: "#82B1FFFF"
            ),
            CreateRoutineModel(
                name: "Reading",
                description: "Reading",
                repeatModel: .daliy,
                reminderTime: nil,
                emoji: "📖",
                tint: "#D5CCF7FF"
            ),
            
            CreateRoutineModel(
                name: "Exercise",
                description: "Drink water",
                repeatModel: .daliy,
                reminderTime: nil,
                emoji: "💪",
                tint: "#F5DAAFFF"
            ),
            CreateRoutineModel(
                name: "Write",
                description: "Write",
                repeatModel: .daliy,
                reminderTime: nil,
                emoji: "✍️",
                tint: "#A8ADBAFF"
            ),
        ]
        
        self.models = models
        
        presenter.setList(models.map(TutorialRoutineListViewModel.init))
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func continueButtonDidTap() {
        Task{ [weak self] in
            guard let self = self else { return }
            
            let commands = self.rows.compactMap{ self.models[safe: $0] }
                .map {
                   CreateRoutine(
                       name: $0.name,
                       description: $0.description,
                       repeatType: $0.repeatModel.rawValue(),
                       repeatValue: $0.repeatModel.value(),
                       reminderTime: $0.reminderTime,
                       emoji: $0.emoji,
                       tint: $0.tint
                   )
               }
            
            for create in commands {
                try await self.dependency.routineApplicationService.when(create)
            }
            
            await MainActor.run { [weak self] in self?.listener?.appTutorailRoutineDidFinish() }
        }
    }
    
    func tableViewDidSelectRowAt(row: Int) {
        rows.insert(row)
        
        presenter.showContinueButton()
    }
    
    func tableViewDidDeselectRowAt(row: Int) {
        rows.remove(row)
        
        if rows.isEmpty{
            presenter.hideContinueButton()
        }
    }
}
