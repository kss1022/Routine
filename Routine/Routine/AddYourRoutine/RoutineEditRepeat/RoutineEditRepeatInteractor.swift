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
    var repeatDoItOnceControlValueSubject: CurrentValuePublisher<Date>{ get }
    var repeatWeeklyControlValueSubject: CurrentValuePublisher<Set<Weekly>>{ get }
    var repeatMonthlyControlValueSubject: CurrentValuePublisher<Set<Monthly>>{ get }
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
            dependency.repeatSegmentTypeSubject.send(.none)
            
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
        dependency.repeatDoItOnceControlValueSubject.send(selected)
    }
    
    func repeatWeeklyControlTap(weekly: Set<Weekly>) {        
        dependency.repeatWeeklyControlValueSubject.send(weekly)
    }
    
    func repeatMonthlyControlTap(monthly: Set<Monthly>) {
        dependency.repeatWeeklyControlValueSubject.send(.init())
    }
    
    
    private func hideSegmentTypeView(){
        switch dependency.repeatSegmentTypeSubject.value{
        case .none: break //nothing to do
        case .daliy: break // nothing to do
        case .weekliy: presenter.hideWeeklyControl()
        case .monthly: presenter.hideMonthlyConrol()
        }
    }
}
