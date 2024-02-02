//
//  RoutineTopAcheiveTotalRecordInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation
import ModernRIBs
import Combine

protocol RoutineTopAcheiveTotalRecordRouting: ViewableRouting {
}

protocol RoutineTopAcheiveTotalRecordPresentable: Presentable {
    var listener: RoutineTopAcheiveTotalRecordPresentableListener? { get set }
    func setTotalCount(totalCount: Int, sub: String)
}

protocol RoutineTopAcheiveTotalRecordListener: AnyObject {
}

protocol RoutineTopAcheiveTotalRecordInteractorDependency{
    var topAcheives: ReadOnlyCurrentValuePublisher<[RoutineTopAcheiveModel]>{ get }
}


final class RoutineTopAcheiveTotalRecordInteractor: PresentableInteractor<RoutineTopAcheiveTotalRecordPresentable>, RoutineTopAcheiveTotalRecordInteractable, RoutineTopAcheiveTotalRecordPresentableListener {
    
    weak var router: RoutineTopAcheiveTotalRecordRouting?
    weak var listener: RoutineTopAcheiveTotalRecordListener?
    
    private let dependency: RoutineTopAcheiveTotalRecordInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: RoutineTopAcheiveTotalRecordPresentable,
        dependency: RoutineTopAcheiveTotalRecordInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        dependency.topAcheives
            .map {
                $0.map { $0.totalDone }
            }
            .receive(on: DispatchQueue.main)
            .sink { counts in
                let totalCount =  counts.reduce(into: 0) { (results, count) in
                    results += count
                }
                
                let sub: String
                switch totalCount{
                case 0...100:
                    sub = "total_number_of_achievements_0".localized(tableName: "Record")
                case 100...200:
                    sub = "total_number_of_achievements_1".localized(tableName: "Record")
                case 200...300:
                    sub = "total_number_of_achievements_2".localized(tableName: "Record")
                case 300...:
                    sub = "total_number_of_achievements_3".localized(tableName: "Record")
                default: fatalError("Invalid ToTalCount")
                }
                
                self.presenter.setTotalCount(totalCount: totalCount, sub: sub)
            }
            .store(in: &cancellables)
        
        
        
    }
    
    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}
