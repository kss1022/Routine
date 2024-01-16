//
//  AppTimer.swift
//  Routine
//
//  Created by 한현규 on 10/24/23.
//

import Foundation





struct AppTimerModel{
    let ready: TimeInterval
    let exercise: TimeInterval
    let rest: TimeInterval
    let round: Int
    let cycle: Int?
    let cycleRest: TimeInterval?
    let cooldown: TimeInterval
    
    init(_ model: SectionTimerModel) {
        self.ready = model.ready.time
        self.exercise = model.exercise.time
        self.rest = model.rest.time
        self.round = model.round.count
        self.cycle = model.cycle?.count
        self.cycleRest = model.cycleRest?.time
        self.cooldown = model.cooldown.time
    }
}



class AppTimer: BaseTimerImp{

    private let sectionTimers: AppTimerModel
    //public weak var delegate: AppTimerDelegate?

    //var sectionState: AppTimerSectionState
    
    var sectionState: ReadOnlyCurrentValuePublisher<AppTimerSectionState>{ sectionStateSubject }
    private let sectionStateSubject = CurrentValuePublisher<AppTimerSectionState>(.ready)
        
    private var _sectionState: AppTimerSectionState
        
    var remainTotalTime: TimeInterval
    
    var remainRound: Int
    var remainCycle: Int?
    
    
    
    init(model: AppTimerModel) {
        self.sectionTimers = model
        self.remainRound = model.round
        self.remainCycle = model.cycle
        self._sectionState = .ready
        
        
        var remainTotalTime : Double = 0.0
        
        remainTotalTime += model.ready
        
        let roundTime = (model.exercise + model.rest) * Double(model.round)
        
        
        if model.cycle != nil && model.cycleRest != nil{
            let cycle = Double( model.cycle!)
            remainTotalTime +=  roundTime * cycle
            remainTotalTime += model.cycleRest! * cycle
        }else{
            remainTotalTime += roundTime
        }
        
        remainTotalTime += model.cooldown
        self.remainTotalTime = remainTotalTime
        
        super.init(time: model.rest)
    }
    
    
    //MARK: override
    override func cancel() {
        super.cancel()
        
        if remainTime.value > 0{
            super.complete()
        }        
    }

    override func complete() {
        guard let nextTime = next() else{
            super.complete()
            return
        }
                
        self.reset(time: nextTime)
        self.start()        
        self.sectionStateSubject.send(_sectionState)
    }
    
    override func updateTime(){
        super.updateTime()
        if remainTime.value > 0{
            remainTotalTime -= 0.01
        }
        
    }
    
    //MARK: Private
    
    private func next() -> TimeInterval?{
        switch sectionState.value {
        case .ready: return getExercise()
        case .exercise: return getRest()
        case .rest: return getNextRound() //handle Round & cycle
        case .cycleRest: return getExerciseAfterCycle()
        case .cooldown: return nil
        }
    }
    
    
    
    private func getExercise() -> TimeInterval{
        self._sectionState = .exercise        
        return sectionTimers.exercise
    }
    
    private func getExerciseAfterCycle() -> TimeInterval{
        remainCycle! -= 1
        remainRound = sectionTimers.round
        self._sectionState = .exercise
        return sectionTimers.exercise
    }
    
    private func getRest() -> TimeInterval{
        self._sectionState = .rest
        return sectionTimers.rest
    }
    
    private func getNextRound() -> TimeInterval?{
        if remainRound == 1{
            if let cycle = getNextCycle(){
                return cycle
            }
            
            remainRound -= 1
            return getCooldown()
        }
        
        //Repeat Round
        remainRound -= 1
        self._sectionState = .exercise
        return sectionTimers.exercise
    }
    
    private func getNextCycle() -> TimeInterval?{
        if sectionTimers.cycle == nil{
            return nil
        }
        
        if remainCycle == 1{
            remainCycle! -= 1
            return getCooldown()
        }
                                        
        self._sectionState = .cycleRest
        return sectionTimers.cycleRest
    }
    
    private func getCooldown() -> TimeInterval{
        self._sectionState = .cooldown
        return sectionTimers.cooldown
    }
    

}
