//
//  RecordCalendarInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/12/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RecordCalendarRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RecordCalendarPresentable: Presentable {
    var listener: RecordCalendarPresentableListener? { get set }
    func setCompletes(_ dates: Set<Date>)
}

protocol RecordCalendarListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RecordCalendarInteractorDependency{
    var routineDetailRecord: ReadOnlyCurrentValuePublisher<RoutineDetailRecordModel?>{ get }
}

final class RecordCalendarInteractor: PresentableInteractor<RecordCalendarPresentable>, RecordCalendarInteractable, RecordCalendarPresentableListener {

    weak var router: RecordCalendarRouting?
    weak var listener: RecordCalendarListener?

    private var cancellables: Set<AnyCancellable>
    private let dependency: RecordCalendarInteractorDependency
    
    
    // in constructor.
    init(
        presenter: RecordCalendarPresentable,
        dependency: RecordCalendarInteractorDependency
    ) {
        self.cancellables = .init()
        self.dependency = dependency
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.routineDetailRecord
            .receive(on: DispatchQueue.main)
            .sink {
                let formaater = Formatter.recordDateFormatter()
                
                var set = Set<Date>()
                
                $0?.recordModels.map{ $0.recordDate }
                    .forEach{
                        if let date = formaater.date(from: $0){
                            set.insert(date)
                        }
                    }                
                
                self.presenter.setCompletes(set)
            }
            .store(in: &cancellables)
            
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
