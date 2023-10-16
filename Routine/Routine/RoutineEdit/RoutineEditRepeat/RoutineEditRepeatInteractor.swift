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
    func routineEditRepeatSetType(type: RepeatTypeViewModel)
    func routineEditRepeatSetValue(value: RepeatValueViewModel)
}

protocol RoutineEditRepeatInteractorDependency{
    var detail: RoutineDetailModel?{ get }
}

final class RoutineEditRepeatInteractor: PresentableInteractor<RoutineEditRepeatPresentable>, RoutineEditRepeatInteractable, RoutineEditRepeatPresentableListener {
    
    
    weak var router: RoutineEditRepeatRouting?
    weak var listener: RoutineEditRepeatListener?
    
    private let dependency: RoutineEditRepeatInteractorDependency
    private let detail: RoutineDetailModel?
    
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
        self.detail = dependency.detail
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        let type = detail?.repeatType ?? .doItOnce
        let value = detail?.repeatValue ?? .empty
        Log.v("RoutineEditRepaet DidBecome Active🔁: \(type) & \(value)")
       setRepeatData()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
        
    func repeatToogleValueChange(isOn: Bool) {
        if isOn{
            sendTypeValue()
            sendRepeatValue()
            
            presenter.hideDoItOnceControl()
            presenter.showRepeatSegmentControl()
            showControlView()
        }else{
            listener?.routineEditRepeatSetType(type: .doItOnce)
            
            presenter.hideRepeatSegmentControl()
            hideControlView()
            presenter.showDoItOnceControl()
        }
    }
    
    func repeatSegmentValueChange(segmentIndex: Int) {
        hideControlView()
        
        switch segmentIndex{
        case 0:
            listener?.routineEditRepeatSetType(type: .daliy)
            listener?.routineEditRepeatSetValue(value: .daliy)
            
            presenter.showDaliy()
            self.segmentType = .daliy
        case 1:
            listener?.routineEditRepeatSetType(type: .weekliy)
            if let weekly = weekly{ listener?.routineEditRepeatSetValue(value: .weekly(weekly: weekly)) }
            
            presenter.showWeeklyControl()
            self.segmentType = .weekliy
        case 2:
            listener?.routineEditRepeatSetType(type: .monthly)
            if let monthly = monthly{ listener?.routineEditRepeatSetValue(value: .monhtly(monthly: monthly)) }
            presenter.showMonthlyControl()
            self.segmentType = .monthly
        default:
            fatalError("Invalid SegmentIndex")
        }
    }

    
    func repeatDoItOnceControlValueChange(date: Date) {
        self.doItOnceDate = date
        listener?.routineEditRepeatSetValue(value: .doitOnce(date: date))
    }
    
    func repeatWeeklyControlValueChange(weekly: Set<WeekliyViewModel>) {
        self.weekly = weekly
        listener?.routineEditRepeatSetValue(value: .weekly(weekly: weekly))
    }
    
    func repeatMonthlyControlValueChange(monthly: Set<RepeatMonthlyViewModel>) {
        self.monthly = monthly
        listener?.routineEditRepeatSetValue(value: .monhtly(monthly: monthly))
    }
    
    
    
    //set initial Data
    private func setRepeatData(){
                
        let type = RepeatTypeViewModel(rawValue: (detail?.repeatType ?? .daliy).rawValue)!
        let value = RepeatValueViewModel(
            type: detail?.repeatType ?? .daliy,
            value: detail?.repeatValue ?? .empty
        )!.value()
        
        
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
            listener?.routineEditRepeatSetType(type: .daliy)
        case .weekliy:
            listener?.routineEditRepeatSetType(type: .weekliy)
        case .monthly:
            listener?.routineEditRepeatSetType(type: .monthly)
        }
    }
    
    private func sendRepeatValue(){
        switch segmentType {
        case .daliy:
            listener?.routineEditRepeatSetValue(value: .daliy)
        case .weekliy:
            if let weekly = self.weekly{
                listener?.routineEditRepeatSetValue(value: .weekly(weekly: weekly))
            }
        case .monthly:
            if let monthly = self.monthly{
                listener?.routineEditRepeatSetValue(value: .monhtly(monthly: monthly))
            }
        }
    }
    
    enum SegmentType: String{
        case daliy
        case weekliy
        case monthly
    }
    
}
