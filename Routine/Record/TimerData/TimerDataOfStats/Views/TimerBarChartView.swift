//
//  TImerBarGraphView.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import UIKit
import DGCharts



final class TimerBarChartView: UIView{

    weak var chartViewDelegate : ChartViewDelegate?

    private lazy var barChartView : BarChartView = {
        let chartView = BarChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.backgroundColor = .clear

//        chartView.leftAxis.enabled = false

//        chartView.rightAxis.labelFont = .boldSystemFont(ofSize: 6.0)
//        chartView.rightAxis.setLabelCount(7, force: false)
//        chartView.rightAxis.labelTextColor = .label
//        chartView.rightAxis.axisLineColor = .label
        chartView.rightAxis.enabled = false
        
        chartView.leftAxis.labelFont = .boldSystemFont(ofSize: 6.0)
        chartView.leftAxis.setLabelCount(7, force: false)
        chartView.leftAxis.labelTextColor = .label
        chartView.leftAxis.axisLineColor = .label
        chartView.leftAxis.labelFont = .getFont(size: 10.0)

        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 6.0)
        chartView.xAxis.labelTextColor = .label
        chartView.xAxis.axisLineColor = .label
        chartView.xAxis.labelFont = .getFont(size: 10.0)

        chartView.isUserInteractionEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        //chartView.animate(xAxisDuration: 2.5)
        chartView.legend.enabled = false


        return chartView
    }()

    //private let markerView = CustomMarkerView()


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

    func bindView(_ viewModel: TimerBarChartViewModel){                
        barChartView.leftAxis.setLabelCount(viewModel.yAxisCount, force: false)
        barChartView.xAxis.setLabelCount(viewModel.chartDataList.count, force: false)
        
        
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: viewModel.xAxisValues)

        let set = BarChartDataSet(entries: viewModel.chartDataList, label: "")
        
        set.colors = [.primaryColor]//ChartColorTemplates.liberty()

        let data = BarChartData(dataSet: set)
        data.setDrawValues(false)
        barChartView.data = data

        barChartView.delegate = self.chartViewDelegate
    }

    func updateMarker( price : String , date : String){
        //markerView.bindView(price: price, date: date)
    }




}



//

