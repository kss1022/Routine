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
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineTopAcheiveTotalRecordPresentable: Presentable {
    var listener: RoutineTopAcheiveTotalRecordPresentableListener? { get set }
    func setTotalCount(totalCount: Int, sub: String)
}

protocol RoutineTopAcheiveTotalRecordListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
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
                    sub = "Great effort! You may not have enough records yet, but if you continue steadily, you'll achieve significant results. Keep it up!"
                case 100...200:
                    sub = "You've been consistently recording your routines. Shall we aim for higher goals together? Let's create a better version of yourself through new challenges!"
                case 200...300:
                    sub = "Well done on starting to record! What goals would you like to set for the next time? Exciting opportunities for growth are waiting for you through new challenges."
                case 300...:
                    sub = "I can see your effort in recording routines! Try creating even greater achievements with more records. I'm looking forward to what's ahead!"
                default: sub = ""
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
