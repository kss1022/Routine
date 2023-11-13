//
//  TImerCharViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import Foundation
import DGCharts




struct TimerBarChartViewModel{
    var yAxisCount: Int
    var xAxisValues: [String]
    var chartDataList : [BarChartDataEntry]
    
    init(
        yAxisCount: Int,
        xAxisValues: [String],
        datas: [Double]
    ){
        self.yAxisCount = yAxisCount
        self.xAxisValues = xAxisValues
        self.chartDataList = datas.enumerated().map{
            BarChartDataEntry(x: Double($0.offset), y: $0.element)
        }
    }
    
    
    
}
