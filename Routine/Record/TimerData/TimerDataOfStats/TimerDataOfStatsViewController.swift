//
//  TimerDataOfStatsViewController.swift
//  Routine
//
//  Created by 한현규 on 11/10/23.
//

import ModernRIBs
import UIKit

protocol TimerDataOfStatsPresentableListener: AnyObject {
    func statsSegmentControlValueChange(index: Int)
}

final class TimerDataOfStatsViewController: UIViewController, TimerDataOfStatsPresentable, TimerDataOfStatsViewControllable {

    
    
    weak var listener: TimerDataOfStatsPresentableListener?
    

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
    
    private lazy var statsSegmentControl: TimeStatsSegmentControl = {
        let segmentControl =  TimeStatsSegmentControl(items: ["Day" , "Week", "Month", "Year"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.backgroundColor = .secondarySystemBackground
        
        segmentControl.addTarget(self, action: #selector(statsSegmentControlValueChange(control:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    
    private let timrStasDateView: TimerStasDateView = {
        let dateView = TimerStasDateView()
        return dateView
    }()
    
    
    private let chartCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadowWithRoundedCorners()
        return view
    }()
    
    private let lineChartView: TimerLineChartView = {
        let charView = TimerLineChartView()
        charView.translatesAutoresizingMaskIntoConstraints = false
        charView.isHidden = true
        return charView
    }()
 
    
    private let barChartView: TimerBarChartView = {
        let charView = TimerBarChartView()
        charView.translatesAutoresizingMaskIntoConstraints = false
        charView.isHidden = true
        return charView
    }()
    

    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    private func setLayout(){
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(statsSegmentControl)
        stackView.addArrangedSubview(timrStasDateView)
        stackView.addArrangedSubview(chartCardView)
        
        
        chartCardView.addSubview(barChartView)
        chartCardView.addSubview(lineChartView)
        
        
                
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            barChartView.topAnchor.constraint(equalTo: chartCardView.topAnchor, constant: 16.0),
            barChartView.leadingAnchor.constraint(equalTo: chartCardView.leadingAnchor, constant: 16.0),
            barChartView.trailingAnchor.constraint(equalTo: chartCardView.trailingAnchor, constant: -16.0),
            barChartView.bottomAnchor.constraint(equalTo: chartCardView.bottomAnchor, constant: -16.0),
            barChartView.heightAnchor.constraint(equalToConstant: UIDevice.frame().width * 0.5),
            
            lineChartView.topAnchor.constraint(equalTo: chartCardView.topAnchor, constant: 16.0),
            lineChartView.leadingAnchor.constraint(equalTo: chartCardView.leadingAnchor, constant: 16.0),
            lineChartView.trailingAnchor.constraint(equalTo: chartCardView.trailingAnchor, constant: -16.0),
            lineChartView.bottomAnchor.constraint(equalTo: chartCardView.bottomAnchor, constant: -16.0),
            lineChartView.heightAnchor.constraint(equalToConstant: UIDevice.frame().width * 0.5)
        ])
    }
    
    
    func showLineChart() {
        lineChartView.isHidden = false
    }
    
    func hideLineChart() {
        lineChartView.isHidden = true
    }
    
    func showBarChart() {
        barChartView.isHidden = false
    }
    
    func hideBarChart() {
        barChartView.isHidden = true
    }
    
    func showDayChartData(_ viewModel: TimerLineChartViewModel) {
        lineChartView.bindView(viewModel)
    }
    
    func showWeekChartData(_ viewModel: TimerBarChartViewModel) {
        barChartView.bindView(viewModel)
    }
    
    func showMonthChart(_ viewModel: TimerLineChartViewModel) {
        lineChartView.bindView(viewModel)
    }
    
    func showYearChart(_ viewModel: TimerBarChartViewModel) {
        barChartView.bindView(viewModel)
    }
    
    @objc
    private func statsSegmentControlValueChange(control: UISegmentedControl){
        listener?.statsSegmentControlValueChange(index: control.selectedSegmentIndex)
    }
}
