//
//  RoundBackgroundTimer.swift
//  Routine
//
//  Created by 한현규 on 1/18/24.
//

import Foundation



enum RoundTimerState{
    case ready
    case rest
    case exercise
    case cooldown
}

final class RoundBackgroundTimer: BaseTimerImp{
    
    public var totalTime: ReadOnlyCurrentValuePublisher<TimeInterval>{ totalTimeSubject }
    private let totalTimeSubject: CurrentValuePublisher<TimeInterval>
    
    public var section: ReadOnlyCurrentValuePublisher<TimeSectionModel>{ sectionSubject }
    private let sectionSubject: CurrentValuePublisher<TimeSectionModel>
    
    public var nextSection: ReadOnlyCurrentValuePublisher<TimeSectionModel?>{ nextSectionSubject }
    private let nextSectionSubject: CurrentValuePublisher<TimeSectionModel?>
    
    public var progress: ReadOnlyCurrentValuePublisher<RoundProgressModel>{ progressSubject }
    private let progressSubject: CurrentValuePublisher<RoundProgressModel>
    
    private var enterBackgroundAt: Date?
    
    private let ready: TimeSectionModel
    private let exercise: TimeSectionModel
    private let rest: TimeSectionModel
    private let round: RepeatSectionModel
    private let cooldown: TimeSectionModel
    
    private var state: RoundTimerState
    private var roundRepeat: Int
    
    init(_ model: RoundTimerModel){
        self.ready = model.ready
        self.exercise = model.exercise
        self.rest = model.rest
        self.round = model.round
        self.cooldown = model.cooldown
        
        var sum = TimeInterval()
        sum += ready.timeInterval()
        
        let roundSum = exercise.timeInterval() + rest.timeInterval()
        sum += roundSum * Double(round.repeat - 1)
        
        sum += exercise.timeInterval() + cooldown.timeInterval()
        
        
        self.state = .ready
        self.roundRepeat = model.round.repeat        
        
        self.totalTimeSubject = CurrentValuePublisher(sum)
        self.sectionSubject = CurrentValuePublisher(ready)
        self.nextSectionSubject = CurrentValuePublisher(exercise)
        
        let progressModel = RoundProgressModel(roundRepeat: roundRepeat)
        self.progressSubject = CurrentValuePublisher(progressModel)
        
        super.init(model.ready.timeInterval())
        setNotifications()
    }
    
    
    //MARK: Override
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
        
        reset(time: nextTime)
        start()
        sendSection()
    }
    
    override func updateTime(){
        super.updateTime()
        if remainTime.value > 0{
            //-= 0.01
            totalTimeSubject.send(totalTime.value - minusTime)
        }
    }
    
    
    
}


// MARK: Tabata
extension RoundBackgroundTimer{
    
    private func next() -> TimeInterval?{
        switch state {
        case .ready:
            state = .exercise
            return exercise.timeInterval()
        case .exercise:
            
            if roundRepeat == 1{
                roundRepeat -= 1
                sendProgress()
                
                state = .cooldown
                return cooldown.timeInterval()
            }
            
            state = .rest
            return rest.timeInterval()
        case .rest:
            roundRepeat -= 1
            sendProgress()
            state = .exercise
            return exercise.timeInterval()
        case .cooldown: return nil
        }
    }
    
    
    private func sendSection(){
        switch state{
        case .ready: break
        case .exercise:
            sectionSubject.send(exercise)
            
            if roundRepeat == 1{
                nextSectionSubject.send(cooldown)
                return
            }
            
            nextSectionSubject.send(rest)
        case .rest:
            sectionSubject.send(rest)
            nextSectionSubject.send(exercise)
        case .cooldown:
            sectionSubject.send(cooldown)
            nextSectionSubject.send(nil)
        }
    }

    private func sendProgress(){
        let progressModel = RoundProgressModel(
            roundRepeat: roundRepeat
        )
        progressSubject.send(progressModel)
    }
    
}

// MARK: Background
extension RoundBackgroundTimer{
    @objc
    private func tiemrEnterBackground(){
        if timerState != .resumed{
            return
        }
        
        enterBackgroundAt = Date()
        suspend()
    }
    
    @objc
    private func timerEnterForeground(){
        guard let enterBackgroundAt = enterBackgroundAt else { return }
        
        let current = Date()
        let backgroundDuration = current.timeIntervalSince(enterBackgroundAt)

        updateBackgroundTime(backgroundDuration)
        updateBackgroundTotalTime(backgroundDuration)
        
        resume()
        sendSection()
        self.enterBackgroundAt = nil
    }
    
    

    
    private func updateBackgroundTime(_ duration: TimeInterval){
        var backgroundDuration = duration
        while backgroundDuration != 0{
            if remainTime.value >= backgroundDuration{
                reset(time: remainTime.value - backgroundDuration)
                return
            }
                        
            backgroundDuration -= remainTime.value
            guard let nextTime = next() else {
                //current is cooldown & remainTime <= 0
                reset(time: 0)
                return
            }
            
            self.reset(time: nextTime)
        }
    }
    
    private func updateBackgroundTotalTime(_ duration: TimeInterval){
        if totalTime.value > duration{
            totalTimeSubject.send(totalTime.value - duration)
            return
        }
        
        totalTimeSubject.send(0)
    }
    
    private func setNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(timerEnterForeground), name: NSNotification.Name("ENTER_FOREGROUND"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tiemrEnterBackground), name: NSNotification.Name("ENTER_BACKGROUND"), object: nil)
    }
}
