//
//  RoutineEditRepeatViewController.swift
//  Routine
//
//  Created by 한현규 on 10/9/23.
//

import ModernRIBs
import UIKit

protocol RoutineEditRepeatPresentableListener: AnyObject {
    func repeatToogleValueChange(isOn: Bool)
    func repeatSegmentValueChange(segmentIndex: Int)
    func repeatDoItOnceControlValueChange(date: Date)
    func repeatWeeklyControlValueChange(weekly: Set<WeeklyViewModel>)
    func repeatMonthlyControlValueChange(monthly: Set<RepeatMonthlyViewModel>)
}

final class RoutineEditRepeatViewController: UIViewController, RoutineEditRepeatPresentable, RoutineEditRepeatViewControllable {

    

    weak var listener: RoutineEditRepeatPresentableListener?
        
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        return stackView
    }()
    
    private lazy var repeatEditToogleView: RoutineEditToogleView = {
        let toogleView = RoutineEditToogleView(
            image: UIImage(systemName: "repeat.circle.fill"),
            title: "repeat".localized(tableName: "Routine"),
            subTitle: "set_a_cycle_for_your_plan".localized(tableName: "Routine")
        )
        
        toogleView.toogle.addTarget(self, action: #selector(repeatToogleValueChange(sender:)), for: .valueChanged)
        return toogleView
    }()
    
    private lazy var repeatSegmentControl: RepeatSegmentControl = {
        let segmentControl =  RepeatSegmentControl(items: ["daliy".localized(tableName: "Routine") , "weekly".localized(tableName: "Routine"), "monthly".localized(tableName: "Routine")])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.backgroundColor = .secondarySystemBackground
        
        segmentControl.addTarget(self, action: #selector(repeatSegmentControlValueChange(control:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private lazy var repeatDoItOnceControl: RepeatDoItOnceControl = {
        let doitOnceControl = RepeatDoItOnceControl()
        doitOnceControl.translatesAutoresizingMaskIntoConstraints = false
        doitOnceControl.addTarget(self, action: #selector(repeatDoItOnceControlValueChange(control:)), for: .valueChanged)
        return doitOnceControl
    }()
    
    private lazy var repeatWeeklyControl: RepeatWeeklyControl = {
        let weeklyControl = RepeatWeeklyControl()
        weeklyControl.translatesAutoresizingMaskIntoConstraints = false
        weeklyControl.addTarget(self, action: #selector(repeatWeeklyControlValueChange(control:)), for: .valueChanged)
        return weeklyControl
    }()
    
    private lazy var repeatMonthlyControl: RepeatMontlyControl = {
        let monthlyControl = RepeatMontlyControl()
        monthlyControl.translatesAutoresizingMaskIntoConstraints = false
        monthlyControl.addTarget(self, action: #selector(repeatMonthlyControlControlValueChange(control:)), for: .valueChanged)
        return monthlyControl
    }()
    
    private var dividerViews = Set<UIView>()
        
    private func dividerView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        view.backgroundColor = .opaqueSeparator
        return view
    }
    
    init(){
        super.init(nibName: nil, bundle: nil)
                
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    private func setLayout(){
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(repeatEditToogleView)
                
        
        let inset: CGFloat = 8.0
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
        ])
    }
    
    // MARK: Presentable
    
    
    // TODO: UIView.animate    
//        UIView.animate(
//            withDuration: 0.3,
//            delay: .zero,
//            options: [.curveEaseOut]
//        ) {
//            self.controlStackView.layoutIfNeeded()
//        }
    
    
    func setToogle(on: Bool) {
        self.repeatEditToogleView.setToogle(on)
    }
    
    func showRepeatSegmentControl() {
        stackView.addArrangedSubview(repeatSegmentControl)
        //repeatSegmentControlTap(control: self.repeatSegmentControl)
    }
    
    func hideRepeatSegmentControl() {
        repeatSegmentControl.removeFromSuperview()
    }
    
    func showDoItOnceControl() {
        stackView.addArrangedSubview(repeatDoItOnceControl)
        setDoItOnceSubtitle()
    }
    
    func hideDoItOnceControl() {
        repeatDoItOnceControl.removeFromSuperview()
    }
    
    func setDoItOnceDate(date: Date) {
        repeatDoItOnceControl.setDate(date: date)
        setDoItOnceSubtitle()
    }
    
    
    func showDaliy() {
        setDaliySubTitle()
    }
    
    func showWeeklyControl() {
        self.stackView.addArrangedSubview(self.repeatWeeklyControl)
        setWeeklySubTitle()
    }
    
    func hideWeeklyControl() {
        repeatWeeklyControl.removeFromSuperview()
    }
    
    func setWeeklys(weeklys: Set<WeeklyViewModel>) {
        repeatSegmentControl.selectedSegmentIndex = 1
        repeatWeeklyControl.setWeeklys(weeklys: weeklys)
    }

    func showMonthlyControl() {
        self.stackView.addArrangedSubview(self.repeatMonthlyControl)
        setMonthlySubTitle()
    }
    
    func hideMonthlyConrol() {
        repeatMonthlyControl.removeFromSuperview()
    }
    
    func setMonthlyData(monthly: Set<RepeatMonthlyViewModel>) {
        repeatSegmentControl.selectedSegmentIndex = 2
        repeatMonthlyControl.setMonthly(monthly: monthly)
    }
    
    
    // MARK: Handle Toogle(Switch)
    @objc func repeatToogleValueChange(sender: UISwitch) {
        listener?.repeatToogleValueChange(isOn: sender.isOn)
    }
    
    
    // MARK: Handle SegmentControl
    @objc 
    private func repeatSegmentControlValueChange(control: UISegmentedControl) {
        listener?.repeatSegmentValueChange(segmentIndex: control.selectedSegmentIndex)
    }
    
    
    // MARK: Repeat Control ( Weekly, Monthly )    
    
    @objc
    private func repeatDoItOnceControlValueChange(control: RepeatDoItOnceControl) {
        let selectedDay = control.selectedDay
        listener?.repeatDoItOnceControlValueChange(date: selectedDay)
        
        setDoItOnceSubtitle()
    }
    
    
    @objc
    private func repeatWeeklyControlValueChange(control: RepeatWeeklyControl) {
        let selected =  control.weeklys.routineWeeklys.filter { $0.isSelected }
            .map { $0.weekly }
        let weekly = Set<WeeklyViewModel>(selected)
        listener?.repeatWeeklyControlValueChange(weekly: weekly)
        
        setWeeklySubTitle()
    }
    
    
    @objc
    private func repeatMonthlyControlControlValueChange(control: RepeatMontlyControl) {
        let selected =  control.days.map { RepeatMonthlyViewModel($0.key) }
        let monthly = Set<RepeatMonthlyViewModel>(selected)
        listener?.repeatMonthlyControlValueChange(monthly: monthly)
        
        setMonthlySubTitle()
    }


    // MARK: set Subscribe test
    private func setDoItOnceSubtitle(){
        let selectedDay = repeatDoItOnceControl.selectedDay
                
        let date = Formatter.asRecentTimeString(date: selectedDay)
        repeatEditToogleView.setSubTitle(date)
        listener?.repeatDoItOnceControlValueChange(date: selectedDay)
    }
    
    private func setDaliySubTitle(){
        repeatEditToogleView.setSubTitle("daliy".localized(tableName: "Routine"))
    }
    
    private func setWeeklySubTitle(){
            
        let selected = repeatWeeklyControl.weeklys.routineWeeklys.filter { $0.isSelected }
            .map { $0.weekly.veryShortWeekydaySymbols() }
                    
        var subTitle = selected.joined(separator: ", ")
        if subTitle.isEmpty{
            subTitle = "weekly".localized(tableName: "Routine")
        }
        repeatEditToogleView.setSubTitle(subTitle)
    }
    
    private func setMonthlySubTitle(){
        let selected =  repeatMonthlyControl.days.compactMap { $0.key }
            .sorted{
                $0 < $1
            }
        
        var subTitle = selected.map(String.init)
            .joined(separator: ", ")
        if subTitle.isEmpty{
            subTitle = "monthly".localized(tableName: "Routine")
        }
        
        repeatEditToogleView.setSubTitle(subTitle)
    }
}
