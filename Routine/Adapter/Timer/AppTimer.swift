//
//  AppTimer.swift
//  Routine
//
//  Created by 한현규 on 10/24/23.
//

import Foundation




protocol AppTimerDelegate: AnyObject{
    //func timer()
    func timer(sectionChanged: AppTimerSectionState)
    
}

extension AppTimerDelegate{
    func timer(sectionChanged: AppTimerSectionState){}
}


struct AppTimerModel{
    let ready: TimeInterval
    let exercise: TimeInterval
    let rest: TimeInterval
    let round: Int
    let cycle: Int?
    let cycleRest: TimeInterval?
    let cooldown: TimeInterval
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





//struct Round{
//    let ready: TimeInterval
//    let exercise: TimeInterval
//    let rest: TimeInterval
//    let round: Int
//    let cooldown: TimeInterval
//}
//
//
//enum RoundState{
//    case ready
//    case rest
//    case exercise
//    case cooldown
//}
//
//
//class RoundTimer: BackgroundTimer{
//
//    private let round: Round
//
//    var roundState: RoundState
//    var remainRound: Int
//    public weak var delegate: AppRepeatTimerDelegate?
//
//    
//    func next() -> TimeInterval?{
//        switch roundState {
//        case .ready:
//            self.roundState = .exercise
//            return round.exercise
//        case .exercise:
//            self.roundState = .rest
//            return round.rest
//        case .rest:
//            if remainRound == 0{
//                self.roundState = .cooldown
//                return round.cooldown
//            }
//            //Repeat Round
//            remainRound -= 1
//            self.roundState = .exercise
//            return round.exercise
//        case .cooldown:
//            return nil
//        }
//    }
//    
//    init(round: Round) {
//        self.round = round
//        self.remainRound = round.round
//        self.roundState = .ready
//        super.init(durationSeconds: round.rest)
//    }
//
//    
//    
//    override func updateTime() {
//        if remainDuration.value > 0{
//            remainDurationSubject.send(remainDuration.value - 0.1)
//        }else{
//    
//            cancel()
//            guard let nextDuration = next() else{
//                completeSubject.send(Void())
//                return
//            }
//            self.totalDuration = nextDuration
//            self.remainDurationSubject.send(nextDuration)
//            
//            self.start()
//            
//            
//            DispatchQueue.main.sync { [weak self] in
//                guard let self = self else { return }
//              
////                self.delegate?.timer(repeatingIndex: self.repeatIndex, baseIndex: nextIndex)
//            }
//        }
//    }
//}
//
//
