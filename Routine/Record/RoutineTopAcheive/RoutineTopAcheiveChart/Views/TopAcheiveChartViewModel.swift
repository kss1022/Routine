//
//  TopAcheiveChartViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import Foundation
import UIKit.UIColor
import DGCharts


struct TopAcheiveChartViewModel{
    let title: String
    let chartDataEntry: BarChartDataEntry
    let tint: UIColor?
        
    
    init(index: Int, _ model: TopAcheiveChartModel){
        self.title = model.title
        self.chartDataEntry = BarChartDataEntry(x: Double(index), y: Double(model.count))
        self.tint = UIColor(hex: model.tint)
    }
}
