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
    
    func setToogle(on: Bool)
    
    func showRepeatSegmentControl()
    func hideRepeatSegmentControl()
    
    func showDoItOnceControl()
    func hideDoItOnceControl()
    func setDoItOnceDate(date: Date)
    
    func showDaliy()
    
    func showWeeklyControl()
    func hideWeeklyControl()
    func setWeeklys(weeklys: Set<WeekliyViewModel>)
    
    func showMonthlyControl()
    func hideMonthlyConrol()
    func setMonthlyData(monthly: Set<RepeatMonthlyViewModel>)
    
}

protocol RoutineEditRepeatListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineEditRepeatInteractorDependency{
    var repeatTypeSubject: CurrentValuePublisher<RepeatTypeViewModel>{ get }
    var repeatValueSubject: CurrentValuePublisher<RepeatValueViewModel>{ get }

}

final class RoutineEditRepeatInteractor: PresentableInteractor<RoutineEditRepeatPresentable>, RoutineEditRepeatInteractable, RoutineEditRepeatPresentableListener {
    
    
    weak var router: RoutineEditRepeatRouting?
    weak var listener: RoutineEditRepeatListener?
    
    private let dependency: RoutineEditRepeatInteractorDependency
    
    
    private var segmentType: SegmentType = .daliy
    private var doItOnceDate: Date?
    private var weekly: Set<WeekliyViewModel>?
    private var monthly: Set<RepeatMonthlyViewModel>?
    
    
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
        
        Log.v("RoutineEditRepaet DidBecome Active🔁: \(dependency.repeatTypeSubject.value) & \(dependency.repeatValueSubject.value)")
       setRepeatData()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
        
    func repeatToogleTap(isOn: Bool) {
        if isOn{
            sendTypeValue()
            sendRepeatValue()
            
            presenter.hideDoItOnceControl()
            presenter.showRepeatSegmentControl()
            showControlView()
        }else{
            dependency.repeatTypeSubject.send(.doItOnce)
            
            presenter.hideRepeatSegmentControl()
            hideControlView()
            presenter.showDoItOnceControl()
        }
    }
    
    func repeatSegmentTap(segmentIndex: Int) {
        hideControlView()
        
        switch segmentIndex{
        case 0:
            dependency.repeatTypeSubject.send(.daliy)
            dependency.repeatValueSubject.send(.daliy)
            
            presenter.showDaliy()
            self.segmentType = .daliy
        case 1:
            dependency.repeatTypeSubject.send(.weekliy)
            if let weekly = weekly{ self.dependency.repeatValueSubject.send(.weekly(weekly: weekly)) }
            
            presenter.showWeeklyControl()
            self.segmentType = .weekliy
        case 2:
            dependency.repeatTypeSubject.send(.monthly)
            if let monthly = monthly{ self.dependency.repeatValueSubject.send(.monhtly(monthly: monthly)) }
            
            presenter.showMonthlyControl()
            self.segmentType = .monthly
        default:
            fatalError("Invalid SegmentIndex")
        }
    }

    
    func repeatDoItOnceControlTap(selected: Date) {
        self.doItOnceDate = selected        
        dependency.repeatValueSubject.send(.doitOnce(date: selected))
    }
    
    func repeatWeeklyControlTap(weekly: Set<WeekliyViewModel>) {
        self.weekly = weekly
        dependency.repeatValueSubject.send(.weekly(weekly: weekly))
    }
    
    func repeatMonthlyControlTap(monthly: Set<RepeatMonthlyViewModel>) {
        self.monthly = monthly
        dependency.repeatValueSubject.send(.monhtly(monthly: monthly))
    }
    
    
    
    //set initial Data
    private func setRepeatData(){
        let type = dependency.repeatTypeSubject.value
        
        
        
        let value = dependency.repeatValueSubject.value.value()
        
        switch type {
        case .doItOnce:
            presenter.showDoItOnceControl()
            if let date = value as? Date{
                self.doItOnceDate = date
                presenter.setDoItOnceDate(date: date)
            }
        case .daliy:
            presenter.setToogle(on: true)
            presenter.showRepeatSegmentControl()
            presenter.showDaliy()
            self.segmentType = .daliy
        case .weekliy:
            presenter.setToogle(on: true)
            presenter.showRepeatSegmentControl()
            presenter.showWeeklyControl()
            
            if let weekly = value as? Set<WeekliyViewModel>{
                self.weekly = weekly
                presenter.setWeeklys(weeklys: weekly)
            }
            
            self.segmentType = .weekliy
        case .monthly:
            presenter.setToogle(on: true)
            presenter.showRepeatSegmentControl()
            presenter.showMonthlyControl()

            if let monthly = value as? Set<RepeatMonthlyViewModel>{
                self.monthly = monthly
                presenter.setMonthlyData(monthly: monthly)
            }
            
            self.segmentType = .monthly
        }
    }
    
    //when toogle On
    private func showControlView(){
        switch self.segmentType {
        case .daliy: presenter.showDaliy()
        case .weekliy: presenter.showWeeklyControl()
        case .monthly: presenter.showMonthlyControl()
        }
    }
    
    private func hideControlView(){
        switch segmentType{
        case .daliy: break // nothing to do
        case .weekliy: presenter.hideWeeklyControl()
        case .monthly: presenter.hideMonthlyConrol()
        }
    }
    
    //when toogle On
    private func sendTypeValue(){
        switch segmentType {
        case .daliy:
            dependency.repeatTypeSubject.send(.daliy)
        case .weekliy:
            dependency.repeatTypeSubject.send(.weekliy)
        case .monthly:
            dependency.repeatTypeSubject.send(.monthly)
        }
    }
    
    private func sendRepeatValue(){
        switch segmentType {
        case .daliy:
            self.dependency.repeatValueSubject.send(.daliy)
        case .weekliy:
            if let weekly = self.weekly{
                self.dependency.repeatValueSubject.send(.weekly(weekly: weekly))
            }
        case .monthly:
            if let monthly = self.monthly{
                self.dependency.repeatValueSubject.send(.monhtly(monthly: monthly))
            }
        }
    }
    
    enum SegmentType: String{
        case daliy
        case weekliy
        case monthly
    }
    
}
