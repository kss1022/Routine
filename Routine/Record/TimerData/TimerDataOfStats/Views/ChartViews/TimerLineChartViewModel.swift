//
//  TImerWeekLineChartViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import Foundation
import DGCharts


struct TimerLineChartViewModel{
    var yAxisCount: Int
    var xAxisValues: [String]
    var chartDataList : [ChartDataEntry]
    let type: TimerLineCharViewType
    
    init(
        yAxisCount: Int,
        xAxisValues: [String],
        datas: [Double],
        type: TimerLineCharViewType
    ){
        self.yAxisCount = yAxisCount
        self.xAxisValues = xAxisValues
        self.chartDataList = datas.enumerated().map{
            ChartDataEntry(x: Double($0.offset), y: $0.element)
        }
        self.type = type
    }
}

enum TimerLineCharViewType{
    case day
    case month
}
