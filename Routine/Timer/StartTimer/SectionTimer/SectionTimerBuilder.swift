//
//  SectionTimerBuilder.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs

protocol SectionTimerDependency: Dependency {
    var timerRepository: TimerRepository{ get }
}

final class SectionTimerComponent: Component<SectionTimerDependency>, TimerRemainDependency, SectionRoundTimerDependency, TimerNextSectionDependency, SectionTimerInteractorDependency {
    
    var timerRepository: TimerRepository{ dependency.timerRepository }
    
    let model: TimerSectionsModel
    let timer: AppTimer
    
        
    init(dependency: SectionTimerDependency, model: TimerSectionsModel) {
        self.model = model
        self.timer = AppTimerManager.share.baseTimer(model: AppTimerModel(model), id: model.timerId )
        super.init(dependency: dependency)
    }
}

// MARK: - Builder
protocol SectionTimerBuildable: Buildable {
    func build(withListener listener: SectionTimerListener, model: TimerSectionsModel) -> SectionTimerRouting
}

final class SectionTimerBuilder: Builder<SectionTimerDependency>, SectionTimerBuildable {

    override init(dependency: SectionTimerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SectionTimerListener, model: TimerSectionsModel) -> SectionTimerRouting {
        let component = SectionTimerComponent(dependency: dependency, model: model)
        let viewController = SectionTimerViewController()
        let interactor = SectionTimerInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        
        let timerRemainBuilder = TimerRemainBuilder(dependency: component)
        let sectionRoundTimerBuilder = SectionRoundTimerBuilder(dependency: component)
        let timerNextSectionBuilder = TimerNextSectionBuilder(dependency: component)
        
        return SectionTimerRouter(
            interactor: interactor,
            viewController: viewController, 
            timerRemainBuildable: timerRemainBuilder,
            sectionRoundTimerBuildable: sectionRoundTimerBuilder,
            timerNextSectionBuildable: timerNextSectionBuilder
        )
    }
}
