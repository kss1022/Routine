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
    func setWeeklys(weeklys: Set<WeeklyViewModel>)
    
    func showMonthlyControl()
    func hideMonthlyConrol()
    func setMonthlyData(monthly: Set<RepeatMonthlyViewModel>)
    
}

protocol RoutineEditRepeatListener: AnyObject {
    func routineEditRepeatDidSetRepeat(repeat: RepeatModel)
}

protocol RoutineEditRepeatInteractorDependency{
    var detail: RoutineDetailModel?{ get }
}

final class RoutineEditRepeatInteractor: PresentableInteractor<RoutineEditRepeatPresentable>, RoutineEditRepeatInteractable, RoutineEditRepeatPresentableListener {
    
    
    weak var router: RoutineEditRepeatRouting?
    weak var listener: RoutineEditRepeatListener?
    
    private let dependency: RoutineEditRepeatInteractorDependency
    
    private var segmentType: SegmentType
    
    private var doItOnceDate: Date
    private var weekly: Set<Int>
    private var monthly: Set<Int>
    
    
    // in constructor.
    init(
        presenter: RoutineEditRepeatPresentable,
        dependency: RoutineEditRepeatInteractorDependency
    ) {
        self.dependency = dependency
        
        let repeatModel = dependency.detail?.repeatModel
        
        self.segmentType = repeatModel.flatMap(SegmentType.init) ?? .daliy
                
        
        if case .doitOnce(let date ) = repeatModel {
            self.doItOnceDate = date
        }else{
            self.doItOnceDate = Date()
        }
        
         if case .weekly(let weekly) = repeatModel {
            self.weekly = weekly
         } else{
             self.weekly = .init()
         }
        
        if case .monthly(let monthly) = repeatModel {
            self.monthly = monthly
        }else {
            self.monthly = .init()
        }
        
        
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
               
        let repeatModel = dependency.detail?.repeatModel

        switch repeatModel {
        case .doitOnce:
            presenter.showDoItOnceControl()
            presenter.setDoItOnceDate(date: self.doItOnceDate)
        case .daliy:
            presenter.setToogle(on: true)
            presenter.showRepeatSegmentControl()
            presenter.showDaliy()
        case .weekly:
            presenter.setToogle(on: true)
            presenter.showRepeatSegmentControl()
            presenter.showWeeklyControl()
            
            let weeklyViewModels = weekly.compactMap(WeeklyViewModel.init)
            presenter.setWeeklys(weeklys: Set(weeklyViewModels))
        case .monthly(let monthly):
            presenter.setToogle(on: true)
            presenter.showRepeatSegmentControl()
            presenter.showMonthlyControl()
            
            let monthlyViewModels = monthly.compactMap(RepeatMonthlyViewModel.init)
            presenter.setMonthlyData(monthly: Set(monthlyViewModels))
        case .none:
            presenter.setToogle(on: true)
            presenter.showRepeatSegmentControl()
            presenter.showDaliy()
        }
    }
    
    
    override func willResignActive() {
        super.willResignActive()
    }
    
        
    func repeatToogleValueChange(isOn: Bool) {
        if isOn{
            didRepeatValueChange()
            presenter.hideDoItOnceControl()
            presenter.showRepeatSegmentControl()
            showControlView()
        }else{
            let doItOnceDate = self.doItOnceDate
            listener?.routineEditRepeatDidSetRepeat(repeat: .doitOnce(date: doItOnceDate))
            
            presenter.hideRepeatSegmentControl()
            hideControlView()
            presenter.showDoItOnceControl()
        }
    }
    
    func repeatSegmentValueChange(segmentIndex: Int) {
        hideControlView()
        
        switch segmentIndex{
        case 0:
            segmentType = .daliy
            presenter.showDaliy()
        case 1:
            segmentType = .weekly
            presenter.showWeeklyControl()
        case 2:
            segmentType = .monthly
            presenter.showMonthlyControl()
        default: fatalError("Invalid SegmentIndex")
        }
        
        didRepeatValueChange()
    }

    
    func repeatDoItOnceControlValueChange(date: Date) {
        self.doItOnceDate = date
        listener?.routineEditRepeatDidSetRepeat(repeat: .doitOnce(date: date))
    }
    
    func repeatWeeklyControlValueChange(weekly: Set<WeeklyViewModel>) {
        self.weekly = Set(weekly.map{ $0.rawValue })
        listener?.routineEditRepeatDidSetRepeat(repeat: .weekly(weekly: self.weekly ))
    }
    
    func repeatMonthlyControlValueChange(monthly: Set<RepeatMonthlyViewModel>) {
        self.monthly = Set(monthly.map{ $0.day })
        listener?.routineEditRepeatDidSetRepeat(repeat: .monthly(monthly: self.monthly) )
    }
    
    //MARK: Private
    

    //when toogle On
    private func showControlView(){
        switch self.segmentType {
        case .daliy: presenter.showDaliy()
        case .weekly: presenter.showWeeklyControl()
        case .monthly: presenter.showMonthlyControl()
        }
    }
    
    private func hideControlView(){
        switch segmentType{
        case .daliy: break // nothing to do
        case .weekly: presenter.hideWeeklyControl()
        case .monthly: presenter.hideMonthlyConrol()
        }
    }
    
    //when toogle On
    private func didRepeatValueChange(){
        switch segmentType {
        case .daliy: listener?.routineEditRepeatDidSetRepeat(repeat: .daliy)
        case .weekly: listener?.routineEditRepeatDidSetRepeat(repeat: .weekly(weekly: weekly ) )
        case .monthly: listener?.routineEditRepeatDidSetRepeat(repeat: .monthly(monthly: monthly ))
        }
    }
    
    enum SegmentType: String{
        case daliy
        case weekly
        case monthly
        
        init(_ model: RepeatModel){
            switch model {
            case .doitOnce: self = .daliy
            case .daliy: self = .daliy
            case .weekly: self = .weekly
            case .monthly: self = .monthly
            }
        }
    }
    
}
