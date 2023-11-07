//
//  RecordHomeBuilder.swift
//  Routine
//
//  Created by 한현규 on 2023/09/14.
//

import ModernRIBs

protocol RecordHomeDependency: Dependency {
    var recordApplicationService: RecordApplicationService{ get }
    
    var recordRepository: RecordRepository{ get }
    var routineRepository: RoutineRepository{ get }
}

final class RecordHomeComponent: Component<RecordHomeDependency>,RecordRoutineListDetailDependency, RoutineDataDependency ,RecordBannerDependency, RecordRoutineListDependency {
    var recordApplicationService: RecordApplicationService{ dependency.recordApplicationService }
    
    var recordRepository: RecordRepository{ dependency.recordRepository }
    var routineRepository: RoutineRepository{ dependency.routineRepository }
}

// MARK: - Builder

protocol RecordHomeBuildable: Buildable {
    func build(withListener listener: RecordHomeListener) -> RecordHomeRouting
}

final class RecordHomeBuilder: Builder<RecordHomeDependency>, RecordHomeBuildable {

    override init(dependency: RecordHomeDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: RecordHomeListener) -> RecordHomeRouting {
        let component = RecordHomeComponent(dependency: dependency)
        let viewController = RecordHomeViewController()
        let interactor = RecordHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        let recordRoutineListDetailBuilder = RecordRoutineListDetailBuilder(dependency: component)
        let routineDataBuilder = RoutineDataBuilder(dependency: component)
        let recordBannerBuilder = RecordBannerBuilder(dependency: component)
        let recordRoutineListBuilder = RecordRoutineListBuilder(dependency: component)
        
        return RecordHomeRouter(
            interactor: interactor,
            viewController: viewController, 
            recordRoutineListDetailBuildable: recordRoutineListDetailBuilder,
            routineDataBuildable: routineDataBuilder,
            recordBannerBuildable: recordBannerBuilder,
            recordRoutineListBuildable: recordRoutineListBuilder
        )
    }
}
