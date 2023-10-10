//
//  RoutineEditRepeatInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/9/23.
//

import Foundation
import ModernRIBs

protocol RoutineEditRepeatRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineEditRepeatPresentable: Presentable {
    var listener: RoutineEditRepeatPresentableListener? { get set }
    
    func showRepeatSegmentControl()
    func hideRepeatSegmentControl()
    
    func showDoItOnceControl()
    func hideDoItOnceControl()
    
    func showWeeklyControl()
    func hideWeeklyControl()
    
    func showMonthlyControl()
    func hideMonthlyConrol()
}

protocol RoutineEditRepeatListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineEditRepeatInteractorDependency{
    var repeatSegmentTypeSubject: CurrentValuePublisher<RepeatSegmentType>{ get }
    var repeatDataSubject: CurrentValuePublisher<RepeatData>{ get }

}

final class RoutineEditRepeatInteractor: PresentableInteractor<RoutineEditRepeatPresentable>, RoutineEditRepeatInteractable, RoutineEditRepeatPresentableListener {
    
    
    weak var router: RoutineEditRepeatRouting?
    weak var listener: RoutineEditRepeatListener?
    
    private let dependency: RoutineEditRepeatInteractorDependency
    
    
    // in constructor.
    init(
        presenter: RoutineEditRepeatPresentable,
        dependency: RoutineEditRepeatInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
        
    func repeatToogleTap(isOn: Bool) {
        if isOn{
            dependency.repeatSegmentTypeSubject.send(.doItOnce)
            
            presenter.hideDoItOnceControl()
            presenter.showRepeatSegmentControl()
        }else{
            presenter.hideRepeatSegmentControl()
            hideSegmentTypeView()
            
            presenter.showDoItOnceControl()
        }
    }
    
    func repeatSegmentTap(segmentIndex: Int) {
        hideSegmentTypeView()
        
        switch segmentIndex{
        case 0:
            dependency.repeatSegmentTypeSubject.send(.daliy)
        case 1:
            dependency.repeatSegmentTypeSubject.send(.weekliy)
            presenter.showWeeklyControl()
        case 2:
            dependency.repeatSegmentTypeSubject.send(.monthly)
            presenter.showMonthlyControl()
        default:
            fatalError("Invalid SegmentIndex")
        }
    }

    
    func repeatDoItOnceControlTap(selected: Date) {       
        
        dependency.repeatDataSubject.send(.doitOnce(date: selected))
    }
    
    func repeatWeeklyControlTap(weekly: Set<Weekly>) {        
        dependency.repeatDataSubject.send(.weekly(weekly: weekly))
    }
    
    func repeatMonthlyControlTap(monthly: Set<Monthly>) {
        dependency.repeatDataSubject.send(.monhtly(monthly: monthly))
    }
    
    
    private func hideSegmentTypeView(){
        switch dependency.repeatSegmentTypeSubject.value{
        case .doItOnce: break //nothing to do
        case .daliy: break // nothing to do
        case .weekliy: presenter.hideWeeklyControl()
        case .monthly: presenter.hideMonthlyConrol()
        }
    }
}
