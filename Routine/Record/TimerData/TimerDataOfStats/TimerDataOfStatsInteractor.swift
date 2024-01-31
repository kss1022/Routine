//
//  TimerDataOfStatsInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import Foundation
import ModernRIBs
import Combine

protocol TimerDataOfStatsRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerDataOfStatsPresentable: Presentable {
    var listener: TimerDataOfStatsPresentableListener? { get set }
    
    func showDayCharView()
    func hideDayCharView()
    
    func showWeekChartView()
    func hideWeekChartView()
    
    func showMonthChartView()
    func hideMonthChartView()
    
    func showYearCartView()
    func hideYearCharView()
    
    func setDates(date: String)
    
    func showDayChartData(_ viewModel: TimerLineChartViewModel)
    func showWeekChartData(_ viewModel: TimerBarChartViewModel)
    func showMonthChart(_ viewModel: TimerLineChartViewModel)
    func showYearChart(_ viewModel: TimerBarChartViewModel)
}

protocol TimerDataOfStatsListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol TimerDataOfStatsInteractorDependency{
    var timerRecords: ReadOnlyCurrentValuePublisher<[TimerRecordModel]>{ get }
    var timerMonthRecords: ReadOnlyCurrentValuePublisher<[TimerMonthRecordModel]>{ get }
    var timerWeekRecords: ReadOnlyCurrentValuePublisher<[TimerWeekRecordModel]>{ get }
}

final class TimerDataOfStatsInteractor: PresentableInteractor<TimerDataOfStatsPresentable>, TimerDataOfStatsInteractable, TimerDataOfStatsPresentableListener {
    
    weak var router: TimerDataOfStatsRouting?
    weak var listener: TimerDataOfStatsListener?
    
    private let dependency: TimerDataOfStatsInteractorDependency
    
    private let timerRecords: ReadOnlyCurrentValuePublisher<[TimerRecordModel]>
    private let timerMonthRecords: ReadOnlyCurrentValuePublisher<[TimerMonthRecordModel]>
    private let timerWeekRecords: ReadOnlyCurrentValuePublisher<[TimerWeekRecordModel]>
    
    private var cancellables: Set<AnyCancellable>
                
    private var dayDate: Date
    private var weekDate: Date
    private var monthDate: Date
    private var yearDate: Date
    
    private var segmentInex: Int
    
    
    // in constructor.
    init(
        presenter: TimerDataOfStatsPresentable,
        dependency: TimerDataOfStatsInteractorDependency
    ) {
        self.dependency = dependency
        
        self.timerRecords = dependency.timerRecords
        self.timerMonthRecords = dependency.timerMonthRecords
        self.timerWeekRecords = dependency.timerWeekRecords
        
        
        let today = Date()
        
        self.dayDate = today
        self.weekDate = today
        self.monthDate = today
        self.yearDate = today
            
        self.segmentInex = 0
        
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
                
        presenter.showDayCharView()
        presenter.hideWeekChartView()
        presenter.hideMonthChartView()
        presenter.hideYearCharView()


        presenter.setDates(date: dayTitle())
        
        presenter.showDayChartData(dayChartViewModel())
        presenter.showWeekChartData(weekChartViewModel())
        presenter.showMonthChart(monthChartViewModel())
        presenter.showYearChart(yearChartViewModel())
    }
    
    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    //day -> 1.03 2023
    //month -> 1.12 ~ 1.23 2023
    //year -> 2023
    func statsSegmentControlValueChange(index: Int) {
        switch segmentInex{
        case 0: presenter.hideDayCharView()
        case 1: presenter.hideWeekChartView()
        case 2: presenter.hideMonthChartView()
        case 3: presenter.hideYearCharView()
        default: fatalError("Invalid Segment Index")
        }
        
        switch index{
        case 0:
            presenter.showDayCharView()
            presenter.setDates(date: dayTitle())
        case 1:
            presenter.showWeekChartView()
            presenter.setDates(date: weekTitle())
        case 2:
            presenter.showMonthChartView()
            presenter.setDates(date: monthTitle())
        case 3:
            presenter.showYearCartView()
            presenter.setDates(date: yearTitle())
        default: fatalError("Invalid Segment Index")
        }
        
        segmentInex = index
    }

    func leftButtonDidTap() {
        switch segmentInex{
        case 0:
            if let oneDayAgo = Calendar.current.date(byAdding: .day, value: -1, to: dayDate){
                dayDate = oneDayAgo
                presenter.showDayChartData(dayChartViewModel())
                presenter.setDates(date: dayTitle())
            }
        case 1: 
            if let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: monthDate){
                weekDate = oneWeekAgo
                presenter.showWeekChartData(weekChartViewModel())
                presenter.setDates(date: weekTitle())
            }
        case 2:
            if let oneMonthAgo = Calendar.current.date(byAdding: .month, value: -1, to: monthDate){
                monthDate = oneMonthAgo
                presenter.showMonthChart(monthChartViewModel())
                presenter.setDates(date: monthTitle())
            }
        case 3:
            if let oneYearAgo = Calendar.current.date(byAdding: .month, value: -1, to: yearDate){
                yearDate = oneYearAgo
                presenter.showYearChart(yearChartViewModel())
                presenter.setDates(date: yearTitle())
            }
        default :fatalError("Invalid Segment Index")
        }
    }
    
    func rightButtonDidTap() {
        switch segmentInex{
        case 0:
            if let oneDayLater = Calendar.current.date(byAdding: .day, value: 1, to: dayDate){
                dayDate = oneDayLater
                presenter.showDayChartData(dayChartViewModel())
                presenter.setDates(date: dayTitle())
            }
        case 1: 
            if let oneWeekLater = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: monthDate){
                weekDate = oneWeekLater
                presenter.showWeekChartData(weekChartViewModel())
                presenter.setDates(date: weekTitle())
            }
        case 2:
            if let oneMonthLater = Calendar.current.date(byAdding: .month, value: 1, to: monthDate){
                monthDate = oneMonthLater
                presenter.showMonthChart(monthChartViewModel())
                presenter.setDates(date: monthTitle())
            }
        case 3:
            if let oneYearLater = Calendar.current.date(byAdding: .month, value: 1, to: yearDate){
                yearDate = oneYearLater
                presenter.showYearChart(yearChartViewModel())
                presenter.setDates(date: yearTitle())
            }
        default :fatalError("Invalid Segment Index")
        }
    }
}



extension TimerDataOfStatsInteractor{
    private func dayChartViewModel() -> TimerLineChartViewModel{
        let day = Formatter.recordDateFormatter().string(from: dayDate)
        var minutesPerHour = Array<Double>(repeating: 0.0, count: 24)
        
        if let find = timerRecords.value.first(where: { $0.recordDate == day }){
            calculateMinutesPerHour(startTime: find.startAt, endTime: find.endAt, minutesPerHour: &minutesPerHour)
        }
                
        let dayViewModel = TimerLineChartViewModel(
            yAxisCount: 1,
            xAxisValues: (0...23).map(String.init),
            datas: minutesPerHour,
            type: .day
        )
        return dayViewModel
    }
    
    private func weekChartViewModel() -> TimerBarChartViewModel{
        let weeks = timerWeekRecords.value
        
        let startOfWeek = Formatter.weekRangeFormatter(date: weekDate).0
        
        let times = weeks.first { $0.startOfWeek == startOfWeek }
            .map { record in
                var times = [Double]()
                times.append(record.sundayTime / 60)
                times.append(record.mondayTime / 60)
                times.append(record.tuesdayTime / 60)
                times.append(record.wednesdayTime / 60)
                times.append(record.thursdayTime / 60)
                times.append(record.fridayTime / 60)
                times.append(record.fridayTime / 60)
                times.append(record.saturdayTime / 60)
                return times
            } ?? Array<Double>.init(repeating: 0.0, count: 7)

        
        let weekViewModel = TimerBarChartViewModel(
            yAxisCount: 7,
            xAxisValues: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
            datas: times
        )
        
        return weekViewModel
    }
    
    private func monthChartViewModel() -> TimerLineChartViewModel{
        let array =  calculateMinutesPerDay(
            timerRecords: timerRecords.value
        )
        
        var days = array.enumerated().map { $0.offset + 1}
            .map(String.init)
        
        for i in stride(from: 0, to: days.count, by: 2){
            days[i] = ""
        }
        
        let dayViewModel = TimerLineChartViewModel(
            yAxisCount: 4,
            xAxisValues: days,
            datas: array,
            type: .day
        )
        
        return dayViewModel
    }
    
    private func yearChartViewModel() -> TimerBarChartViewModel{
        var yearMonths = [String]()
        
        let year = Calendar.current.component(.year, from: yearDate)
                
        for i in 1...12{
            yearMonths.append("\(year)-\(i)")
        }
        
        
        let months = timerMonthRecords.value
        var times = Array<Double>.init(repeating: 0.0, count: 12)
        
        for i in 0..<12 {
            let yearMonth = yearMonths[i]
            
            let find = months.first { $0.month == yearMonth }
            times[i] = (find?.time ?? 0) / 60
        }
        
        let weekViewModel = TimerBarChartViewModel(
            yAxisCount: 7,
            xAxisValues: (1...12).map(String.init),
            datas: times
        )
        
        return weekViewModel
    }
     
}


extension TimerDataOfStatsInteractor{
    private func dayTitle() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d yyyy"
        return formatter.string(from: dayDate)
    }
    
    private func weekTitle() -> String{
        let calendar = Calendar.current
        
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: weekDate)),
              let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else { return "" }

        
        let formatter = DateFormatter()
        formatter.dateFormat = "M.d"
        
        return "\(formatter.string(from: startOfWeek)) ~ \(formatter.string(from: endOfWeek))"
    }
    
    private func monthTitle() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "M yyyy"
        return formatter.string(from: monthDate)
    }
    
    private func yearTitle() -> String{
        let year = Calendar.current.component(.year, from: yearDate)
        return "\(year)"
    }
}

extension TimerDataOfStatsInteractor{
    private func calculateMinutesPerHour(startTime: Date, endTime: Date, minutesPerHour: inout [Double]){
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: startTime, to: endTime)
        let totalMinutes = components.hour! * 60 + components.minute!
        
        if totalMinutes > 0 {
            var currentHour = calendar.component(.hour, from: startTime)
            var remainingMinutes = totalMinutes

            while remainingMinutes > 0 {
                let minutesInCurrentHour = min(60, remainingMinutes)
                minutesPerHour[currentHour] += Double(minutesInCurrentHour)

                remainingMinutes -= minutesInCurrentHour
                currentHour = (currentHour + 1) % 24
            }
        }
    }
    
    
    private func calculateMinutesPerDay(timerRecords: [TimerRecordModel]) -> [Double] {
        let calendar = Calendar.current

        guard let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: monthDate))),
              let lastDay = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDay) else {
            return []
        }


        var minutesPerDay = Array<Double>(repeating: 0, count: calendar.component(.day, from: lastDay))
        let formatter = Formatter.recordDateFormatter()

        for record in timerRecords {
            if let date = formatter.date(from: record.recordDate), date >= firstDay && date <= lastDay {
                let day = calendar.component(.day, from: date) - 1
                minutesPerDay[day] += record.duration / (60 * 60)
            }
        }

        return minutesPerDay
    }

}
