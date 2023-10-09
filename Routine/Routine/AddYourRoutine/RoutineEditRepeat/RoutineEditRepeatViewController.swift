//
//  RoutineEditRepeatViewController.swift
//  Routine
//
//  Created by 한현규 on 10/9/23.
//

import ModernRIBs
import UIKit

protocol RoutineEditRepeatPresentableListener: AnyObject {
    func repeatToogleTap(isOn: Bool)
    func repeatSegmentTap(segmentIndex: Int)
    func repeatDoItOnceControlTap(selected: Date)
    func repeatWeeklyControlTap(weekly: Set<Weekly>)
    func repeatMonthlyControlTap(monthly: Set<Monthly>)
}

final class RoutineEditRepeatViewController: UIViewController, RoutineEditRepeatPresentable, RoutineEditRepeatViewControllable {

    

    weak var listener: RoutineEditRepeatPresentableListener?
    
    
    
    private let repeatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "repeat.circle.fill")
        imageView.tintColor = .label
        return imageView
    }()
    
    private let repeatLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    
    private let repeatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "Repeat"
        return label
    }()
    
    private let repeatSubscribeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setFont(style: .caption1)
        label.textColor = .secondaryLabel
        label.text = "Set a Cycle for Your Plan"
        return label
    }()
    
    
    private lazy var repeatToogle: UISwitch = {
        let toogle = UISwitch()
        toogle.translatesAutoresizingMaskIntoConstraints = false
        toogle.tintColor = .systemGreen
        toogle.isOn = false
        toogle.addTarget(self, action: #selector(repeatToogleTap), for: .valueChanged)
        return toogle
    }()
    
    private let controlStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 16.0
        return stackView
    }()
    
    private lazy var repeatSegmentControl: RepeatSegmentControl = {
        let segmentControl =  RepeatSegmentControl(items: ["Daliy" , "Weekly", "Montly"])
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.backgroundColor = .secondarySystemBackground
        
        segmentControl.addTarget(self, action: #selector(repeatSegmentControlTap(control:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private lazy var repeatDoItOnceControl: RepeatDoItOnceControl = {
        let doitOnceControl = RepeatDoItOnceControl()
        doitOnceControl.translatesAutoresizingMaskIntoConstraints = false
        doitOnceControl.addTarget(self, action: #selector(repeatDoItOnceControlTap(control:)), for: .valueChanged)
        return doitOnceControl
    }()
    
    private lazy var repeatWeeklyControl: RepeatWeeklyControl = {
        let weeklyControl = RepeatWeeklyControl()
        weeklyControl.translatesAutoresizingMaskIntoConstraints = false
        weeklyControl.addTarget(self, action: #selector(repeatWeeklyControlTap(control:)), for: .valueChanged)
        return weeklyControl
    }()
    
    private lazy var repeatMonthlyControl: RepeatMontlyControl = {
        let monthlyControl = RepeatMontlyControl()
        monthlyControl.translatesAutoresizingMaskIntoConstraints = false
        monthlyControl.addTarget(self, action: #selector(repeatMonthlyControlControlTap(control:)), for: .valueChanged)
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
        
        view.addSubview(repeatImageView)
        view.addSubview(repeatLabelStackView)
        view.addSubview(repeatToogle)
        view.addSubview(controlStackView)
        
        repeatLabelStackView.addArrangedSubview(repeatLabel)
        repeatLabelStackView.addArrangedSubview(repeatSubscribeLabel)
        
        
        let inset: CGFloat = 8.0
        
        NSLayoutConstraint.activate([
            repeatImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            repeatImageView.topAnchor.constraint(equalTo: repeatLabelStackView.topAnchor),
            repeatImageView.bottomAnchor.constraint(equalTo: repeatLabelStackView.bottomAnchor),
            repeatImageView.widthAnchor.constraint(equalTo: repeatImageView.heightAnchor),
            
            repeatLabelStackView.leadingAnchor.constraint(equalTo: repeatImageView.trailingAnchor,constant: 8.0),
            repeatLabelStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            repeatLabelStackView.bottomAnchor.constraint(equalTo: controlStackView.topAnchor, constant: -inset),
            
            repeatToogle.centerYAnchor.constraint(equalTo: repeatLabelStackView.centerYAnchor),
            repeatToogle.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -inset),
            
            
            controlStackView.topAnchor.constraint(equalTo: repeatLabelStackView.bottomAnchor,constant: inset),
            controlStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            controlStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            controlStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -inset)
        ])
        
        showDoItOnceControl()
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
    
    
    func showRepeatSegmentControl() {
        controlStackView.addArrangedSubview(repeatSegmentControl)
        repeatSegmentControlTap(control: self.repeatSegmentControl)
    }
    
    func hideRepeatSegmentControl() {
        repeatSegmentControl.removeFromSuperview()
    }
    
    func showDoItOnceControl() {
        controlStackView.addArrangedSubview(repeatDoItOnceControl)
    }
    
    func hideDoItOnceControl() {
        repeatDoItOnceControl.removeFromSuperview()

    }
    
    
    func showWeeklyControl() {
        self.controlStackView.addArrangedSubview(self.repeatWeeklyControl)
    }
    
    func hideWeeklyControl() {
        repeatWeeklyControl.removeFromSuperview()
    }
    

    func showMonthlyControl() {
        self.controlStackView.addArrangedSubview(self.repeatMonthlyControl)
    }
    
    func hideMonthlyConrol() {
        repeatMonthlyControl.removeFromSuperview()
    }
    
    
    // MARK: Handle Toogle(Switch)
    @objc func repeatToogleTap(sender: UISwitch) {
        listener?.repeatToogleTap(isOn: sender.isOn)
    }
    
    
    // MARK: Handle SegmentControl
    @objc 
    private func repeatSegmentControlTap(control: UISegmentedControl) {
        listener?.repeatSegmentTap(segmentIndex: control.selectedSegmentIndex)
    }
    
    
    // MARK: Repeat Control ( Weekly, Monthly )    
    
    @objc
    private func repeatDoItOnceControlTap(control: RepeatDoItOnceControl) {
        let selectedDay = control.selectedDay
                
        let date = Formatter.asRecentTimeString(date: selectedDay)
        repeatSubscribeLabel.text = date
        listener?.repeatDoItOnceControlTap(selected: selectedDay)
        
    }
    
    @objc
    private func repeatWeeklyControlTap(control: RepeatWeeklyControl) {
        let selected =  control.weeklys.routineWeeklys.filter { $0.isSelected }
            .map { $0.weekly }
        
        let weekly = Set<Weekly>(selected)
        listener?.repeatWeeklyControlTap(weekly: weekly)
    }
    
    
    @objc
    private func repeatMonthlyControlControlTap(control: RepeatMontlyControl) {
        let selected =  control.days.map { Monthly($0.key) }
        
        let monthly = Set<Monthly>(selected)
        listener?.repeatMonthlyControlTap(monthly: monthly)
    }
    

}
