//
//  CircularTimerInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import Foundation
import ModernRIBs
import Combine

protocol CircularTimerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CircularTimerPresentable: Presentable {
    var listener: CircularTimerPresentableListener? { get set }
    
    func setTimer(_ viewModel: CircularTimerViewModel)
    
    func showStartButton()
    func showPauseButton()
    func showResumeButton()
    
    func updateRemainTime(time: String)
    
    func startProgress(totalDuration: TimeInterval)
    func updateProgress(from: CGFloat,  remainDuration: TimeInterval)    //for restart
    func resumeProgress()
    func suspendProgress()
}

protocol CircularTimerListener: AnyObject {
    func circularTimerDidTapCancle()
    func circularTimerDidFinish()
}

protocol CircularTimerInteractorDependency{
    var sections: ReadOnlyCurrentValuePublisher<[TimerSectionListModel]>{ get }
    var sectionIndex: ReadOnlyCurrentValuePublisher<Int>{ get }
}

final class CircularTimerInteractor: PresentableInteractor<CircularTimerPresentable>, CircularTimerInteractable, CircularTimerPresentableListener {

    weak var router: CircularTimerRouting?
    weak var listener: CircularTimerListener?

    private let dependency : CircularTimerInteractorDependency
    private var cancellables: Set<AnyCancellable>

    private var timer: AppTimer!
    private var totalDuration: TimeInterval!
    
    
    // in constructor.
    init(
        presenter: CircularTimerPresentable,
        dependency: CircularTimerInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        Publishers.CombineLatest(dependency.sections,dependency.sectionIndex)
            .receive(on: DispatchQueue.main)
            .sink { (lists, index) in
                if let viewModel = lists[safe: index].flatMap(CircularTimerViewModel.init){
                    self.presenter.setTimer(viewModel)
                    self.timer = AppTimerManager.share.timer(id: viewModel.id.uuidString)
                    self.totalDuration = viewModel.duration
                    
                    self.registerHandler()
                    self.checkExistTimer()
                }

            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        //timer.registerHandler(eventHandler: nil, completion: nil)
    }
    

    
    func activeButtonDidTap() {
        switch timer.state {
        case .initialized:
            do{
                try timer.start(durationSeconds: totalDuration)
            }catch{
                Log.e("\(error)")
            }
            
            presenter.showPauseButton()
            presenter.startProgress(totalDuration: totalDuration)
        case .resumed:
            timer.suspend()
            presenter.showResumeButton()
            presenter.suspendProgress()
        case .suspended:
            timer.resume()
            presenter.showPauseButton()
            presenter.resumeProgress()
        default: break //cancel
        }
    }
    
    func cancelButtonDidTap() {
        if timer.state != .initialized{
            timer.cancel()
            presenter.suspendProgress()
        }
        
                
        listener?.circularTimerDidTapCancle()
    }
    
    
    private func registerHandler(){
        self.timer.remainDuration
            .receive(on: DispatchQueue.main)
            .sink { _ in
                let remainTime = self.timer.remainDuration.value
                
                if remainTime != 0{
                    self.presenter.updateRemainTime(time: remainTime.time)
                }                
            }
            .store(in: &cancellables)
        
        self.timer.complete
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.listener?.circularTimerDidFinish()
            }
            .store(in: &cancellables)
    }
    
    
    private func checkExistTimer(){
        switch timer.state {
        case .resumed:
            updateProgress()
            presenter.showPauseButton()
            presenter.resumeProgress()
        case .suspended:
            updateProgress()
            presenter.showResumeButton()
            presenter.suspendProgress()
        default: presenter.showStartButton()
        }
    }
        
    private func updateProgress(){
        let remainDuration = timer.remainDuration.value
        let progress = remainDuration / totalDuration
        presenter.updateProgress(from: progress, remainDuration: remainDuration)
    }
    

}



private extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60), Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
