//
//  TopAcheiveChartView.swift
//  Routine
//
//  Created by 한현규 on 11/13/23.
//

import UIKit
import DGCharts



final class TopAcheiveChartView: UIView{

    weak var chartViewDelegate : ChartViewDelegate?

    private lazy var barChartView : BarChartView = {
        let chartView = BarChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.backgroundColor = .clear
        

        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 14.0)
        chartView.xAxis.labelTextColor = .label
        chartView.xAxis.axisLineColor = .clear
        chartView.xAxis.yOffset = 16.0
        
        chartView.isUserInteractionEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.drawGridBackgroundEnabled = false        
        chartView.legend.enabled = false

        return chartView
    }()


    init(){
        super.init(frame: .zero)

        setView()
    }


    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setView()
    }



    private func setView(){
        self.addSubview(barChartView)
        NSLayoutConstraint.activate([
            barChartView.topAnchor.constraint(equalTo: topAnchor),
            barChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            barChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            barChartView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func bindView(_ viewModels: [TopAcheiveChartViewModel]){
        barChartView.xAxis.setLabelCount(viewModels.count, force: false)                
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: viewModels.map{ $0.title} )

        let set = BarChartDataSet(entries: viewModels.map{ $0.chartDataEntry}, label: "")
        set.colors = viewModels.map{ $0.tint ?? .primaryColor}

        let data = BarChartData(dataSet: set)
        data.setDrawValues(false)
        data.barWidth = 0.5
        barChartView.data = data
        


        barChartView.delegate = self.chartViewDelegate
    }


}
