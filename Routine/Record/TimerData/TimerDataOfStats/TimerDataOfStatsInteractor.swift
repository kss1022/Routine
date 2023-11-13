//
//  TimerDataOfStatsInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs

protocol TimerDataOfStatsRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol TimerDataOfStatsPresentable: Presentable {
    var listener: TimerDataOfStatsPresentableListener? { get set }
    
    func showLineChart()
    func hideLineChart()
    
    func showBarChart()
    func hideBarChart()
    
    func showDayChartData(_ viewModel: TimerLineChartViewModel)
    func showWeekChartData(_ viewModel: TimerBarChartViewModel)
    func showMonthChart(_ viewModel: TimerLineChartViewModel)
    func showYearChart(_ viewModel: TimerBarChartViewModel)
}

protocol TimerDataOfStatsListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class TimerDataOfStatsInteractor: PresentableInteractor<TimerDataOfStatsPresentable>, TimerDataOfStatsInteractable, TimerDataOfStatsPresentableListener {

    weak var router: TimerDataOfStatsRouting?
    weak var listener: TimerDataOfStatsListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: TimerDataOfStatsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        
        var array = [Double]()
        while array.count != 31{
            array.append(Double.random(in: 0...60))
        }
        
        let dayViewModel = TimerLineChartViewModel(
            yAxisCount: 3,
            xAxisValues: (1...31).map(String.init),
            datas: array
        )
        
        presenter.showLineChart()
        presenter.showDayChartData(dayViewModel)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    
    func statsSegmentControlValueChange(index: Int) {
        switch index{
        case 0:
            //day
            var array = [Double]()
            while array.count != 31{
                array.append(Double.random(in: 0...60))
            }
            
            let dayViewModel = TimerLineChartViewModel(
                yAxisCount: 3,
                xAxisValues: (1...31).map(String.init),
                datas: array
            )
            
            presenter.hideBarChart()
            presenter.showLineChart()
            presenter.showDayChartData(dayViewModel)
        case 1:
            //week
            
            var array = [Double]()
            while array.count != 7{
                array.append(Double.random(in: 0...(60 * 24)))
            }
            
            let weekViewModel = TimerBarChartViewModel(
                yAxisCount: 7,
                xAxisValues: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
                datas: array
            )
            
            presenter.hideLineChart()
            presenter.showBarChart()
            
            presenter.showWeekChartData(weekViewModel)
            
        case 2:
            //month
            
            var array = [Double]()
            while array.count != 31{
                array.append(Double.random(in: 0...(60 * 24 * 31)))
            }
            
            
            
            let dayViewModel = TimerLineChartViewModel(
                yAxisCount: 4,
                xAxisValues: (1...31).map(String.init),
                datas: array
            )
            
            presenter.hideBarChart()
            presenter.showLineChart()
            presenter.showMonthChart(dayViewModel)
        case 3:
            //year
            
            var array = [Double]()
            while array.count != 12{
                array.append(Double.random(in: 0...(60 * 24 * 31 * 12)))
            }
            
            
            let weekViewModel = TimerBarChartViewModel(
                yAxisCount: 7,
                xAxisValues: (1...12).map(String.init),
                datas: array
            )
            
            presenter.hideLineChart()
            presenter.showBarChart()
            
            presenter.showYearChart(weekViewModel)
        default: fatalError("Invalid SegmentIndex")
        }
    }
    
        
    
}
