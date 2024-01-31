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
    func leftButtonDidTap()
    func rightButtonDidTap()
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
    
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left.circle.fill"), for: .normal)
        button.tintColor = .primaryGreen
        button.addTarget(self, action: #selector(leftButtonTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.right.circle.fill"), for: .normal)
        button.tintColor = .primaryGreen
        button.addTarget(self, action: #selector(rightButtonTap), for: .touchUpInside)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "00.00 0000"
        return label
    }()
    
    
    
    private let chartContainerView: TimerChartViewContainer = {
        let view = TimerChartViewContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addShadowWithRoundedCorners()
        return view
    }()
    
    private let dayChartView: TimerDayChartView = {
        let charView = TimerDayChartView()
        charView.translatesAutoresizingMaskIntoConstraints = false
        return charView
    }()
    
    private let weekChartView: TimerBarChartView = {
        let charView = TimerBarChartView()
        charView.translatesAutoresizingMaskIntoConstraints = false
        return charView
    }()
    
    
    private let monthChartView: TimerMonthChartView = {
        let charView = TimerMonthChartView()
        charView.translatesAutoresizingMaskIntoConstraints = false
        return charView
    }()
 
    
    private let yearChartView: TimerBarChartView = {
        let charView = TimerBarChartView()
        charView.translatesAutoresizingMaskIntoConstraints = false
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
        stackView.addArrangedSubview(dateStackView)
        stackView.addArrangedSubview(chartContainerView)
        
        dateStackView.addArrangedSubview(leftButton)
        dateStackView.addArrangedSubview(dateLabel)
        dateStackView.addArrangedSubview(rightButton)
        
        [dayChartView, weekChartView, monthChartView, yearChartView].forEach {
            chartContainerView.setCharView($0)
        }
                
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            chartContainerView.heightAnchor.constraint(equalToConstant: UIDevice.frame().width * 0.5),
        ])
        

    }
    
    func showDayCharView() {
        dayChartView.isHidden = false
    }
    
    func hideDayCharView() {
        dayChartView.isHidden = true
    }
    
    func showWeekChartView() {
        weekChartView.isHidden = false
    }
    
    func hideWeekChartView() {
        weekChartView.isHidden = true
    }
    
    func showMonthChartView() {
        monthChartView.isHidden = false
    }
    
    func hideMonthChartView() {
        monthChartView.isHidden = true
    }
    
    func showYearCartView() {
        yearChartView.isHidden = false
    }
    
    func hideYearCharView() {
        yearChartView.isHidden = true
    }
    
    func setDates(date: String) {
        dateLabel.text = date
    }
    
    func showDayChartData(_ viewModel: TimerLineChartViewModel) {
        dayChartView.bindView(viewModel)
    }
    
    func showWeekChartData(_ viewModel: TimerBarChartViewModel) {
        weekChartView.bindView(viewModel)
    }
    
    func showMonthChart(_ viewModel: TimerLineChartViewModel) {
        monthChartView.bindView(viewModel)
    }
    
    func showYearChart(_ viewModel: TimerBarChartViewModel) {
        yearChartView.bindView(viewModel)
    }
    
    @objc
    private func statsSegmentControlValueChange(control: UISegmentedControl){
        listener?.statsSegmentControlValueChange(index: control.selectedSegmentIndex)
    }
    
    @objc
    private func leftButtonTap(){
        listener?.leftButtonDidTap()
    }
    
    @objc
    private func rightButtonTap(){
        listener?.rightButtonDidTap()
    }
}
