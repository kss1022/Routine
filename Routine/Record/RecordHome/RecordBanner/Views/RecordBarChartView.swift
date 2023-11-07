//
//  RecordBarChartView.swift
//  Routine
//
//  Created by 한현규 on 11/7/23.
//

//import UIKit
//import DGCharts
//
//
//
//final class RecordBarChartView: UIView{
//    
//    var chartDataList : [ChartDataEntry] = []
//    
//    weak var chartViewDelegate : ChartViewDelegate?
//    
//    private lazy var barChartView : BarChartView = {
//        let chartView = BarChartView()
//        chartView.translatesAutoresizingMaskIntoConstraints = false
//        chartView.backgroundColor = .clear
//        
//        chartView.leftAxis.enabled = false
//        chartView.rightAxis.enabled = false
//        chartView.xAxis.enabled = false
//        
//        
//        
//        chartView.rightAxis.labelFont = .boldSystemFont(ofSize: 6.0)
//        chartView.rightAxis.setLabelCount(7, force: false)
//        chartView.rightAxis.labelTextColor = .label
//        //chartView.rightAxis.axisLineColor = .systemGreen
//        
//        
//        chartView.xAxis.labelPosition = .bottom
//        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 6.0)
//        //chartView.xAxis.setLabelCount(11, force: false)
//        chartView.xAxis.labelTextColor = .label
//        //chartView.xAxis.axisLineColor = .systemGreen
//        
//        chartView.isUserInteractionEnabled = false
//        chartView.doubleTapToZoomEnabled = false
//        chartView.xAxis.drawGridLinesEnabled = false
//        chartView.rightAxis.drawGridLinesEnabled = false
//        //chartView.animate(xAxisDuration: 2.5)
//        
//        return chartView
//    }()
//    
//    //private let markerView = CustomMarkerView()
//    
//    
//    init(){
//        super.init(frame: .zero)
//                
//        setView()
//    }
//    
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        
//        setView()
//    }
//    
//    
//    
//    private func setView(){
//        self.addSubview(barChartView)
//        NSLayoutConstraint.activate([
//            barChartView.topAnchor.constraint(equalTo: topAnchor),
//            barChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            barChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            barChartView.bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
//    }
//    
//    func bindView(_ viewModel: BarChartViewModel){
//        self.chartDataList = viewModel.chartDataList
//        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(
//            values: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
//        )
//        
//        let set = BarChartDataSet(entries: viewModel.chartDataList, label: "Done")
//        
//        set.colors = ChartColorTemplates.liberty()
//                
//        let data = BarChartData(dataSet: set)
//        data.setDrawValues(false)
//        barChartView.data = data
//        
//        barChartView.delegate = self.chartViewDelegate
//    }
//    
//    func updateMarker( price : String , date : String){
//        //markerView.bindView(price: price, date: date)
//    }
//    
//    
//
//    
//}
//
//
//
//
