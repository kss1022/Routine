//
//  TImerMonthChartView.swift
//  Routine
//
//  Created by 한현규 on 1/31/24.
//


import UIKit
import DGCharts


final class TimerMonthChartView: UIView{

    weak var chartViewDelegate : ChartViewDelegate?

    private lazy var lineChartView : LineChartView = {
        let chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.backgroundColor = .clear


        chartView.rightAxis.enabled = false
        
        chartView.leftAxis.labelFont = .boldSystemFont(ofSize: 6.0)
        chartView.leftAxis.setLabelCount(7, force: false)
        chartView.leftAxis.labelTextColor = .label
        chartView.leftAxis.axisLineColor = .label
        chartView.leftAxis.labelFont = .getFont(size: 10.0)
        chartView.leftAxis.axisMinimum = 0.0

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
        self.addSubview(lineChartView)
        NSLayoutConstraint.activate([
            lineChartView.topAnchor.constraint(equalTo: topAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func bindView(_ viewModel: TimerLineChartViewModel){
        lineChartView.leftAxis.setLabelCount(viewModel.yAxisCount, force: false)
        
        lineChartView.xAxis.setLabelCount(viewModel.xAxisValues.count, force: false)
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: viewModel.xAxisValues)
        
        let set = LineChartDataSet(
            entries: viewModel.chartDataList,
            label: ""
        )
        
        set.mode = .cubicBezier
        
        //Set Line
        set.setColor(.primaryGreen)
        set.lineWidth = 1.0
                
        //Set Circle
        set.circleRadius = 1.0
        set.setCircleColor(.primaryGreen)
        set.drawCirclesEnabled = true
        
        
        //set.fill = ColorFill(color: .secondaryColor)
        let gradientColors = [UIColor.primaryGreen.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) // Gradient Object
        
        if let gradient = gradient{
            set.fill = LinearGradientFill(gradient: gradient , angle: 90.0)
        }else{
            set.fill = ColorFill(color: .secondaryColor)
        }
        
        set.drawFilledEnabled = true
        
        
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.highlightColor = .red
        set.highlightLineDashLengths = [3.0]
        
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        lineChartView.data = data
        //lineChartView.min
        
        //Set Marker
//        markerView.chartView = lineChartView
//        lineChartView.marker = markerView
//
//        lineChartView.highlightValue(nil)
        
        lineChartView.delegate = self.chartViewDelegate
    }

    //func updateMarker( price : String , date : String){
        //markerView.bindView(price: price, date: date)
    //}




}



//

