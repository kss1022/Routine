//
//  TimerSectionEditTimeViewController.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs
import UIKit

protocol TimerSectionEditTimePresentableListener: AnyObject {
    func timePickerDidValueChange(min: Int , sec: Int)
}

final class TimerSectionEditTimeViewController: UIViewController, TimerSectionEditTimePresentable, TimerSectionEditTimeViewControllable {

    weak var listener: TimerSectionEditTimePresentableListener?
    
    private lazy var timePickerView: TimerSectionCountdownPickerView = {
        var pickerView = TimerSectionCountdownPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.addTarget(self, action: #selector(countdownPickerViewValueChange(control:)), for: .valueChanged)
        return pickerView
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
        view.addSubview(timePickerView)
        
        NSLayoutConstraint.activate([
            timePickerView.topAnchor.constraint(equalTo: view.topAnchor),
            timePickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            timePickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            timePickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }
    
    func setTimePicker(min: Int, sec: Int) {
        timePickerView.setCountDown(min: min, sec: sec)
    }
    
    @objc
    private func countdownPickerViewValueChange(control: TimerSectionCountdownPickerView){
        listener?.timePickerDidValueChange(min: control.min, sec: control.sec)
    }
}
