//
//  TimerSectionEditRepeatViewController.swift
//  Routine
//
//  Created by 한현규 on 1/17/24.
//

import ModernRIBs
import UIKit

protocol TimerSectionEditRepeatPresentableListener: AnyObject {
    func countPickerDidValueChange(count: Int)
}

final class TimerSectionEditRepeatViewController: UIViewController, TimerSectionEditRepeatPresentable, TimerSectionEditRepeatViewControllable {

    weak var listener: TimerSectionEditRepeatPresentableListener?
    
    private lazy var countPickerView: TimerSectionCountPickerView = {
        var pickerView = TimerSectionCountPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.addTarget(self, action: #selector(countPickerViewValueChange(control:)), for: .valueChanged)
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
    
    func setLayout() {
        view.addSubview(countPickerView)
        
        NSLayoutConstraint.activate([
            countPickerView.topAnchor.constraint(equalTo: view.topAnchor),
            countPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setRepeat(repeat: Int) {
        countPickerView.setCount(count: `repeat`)
    }

    @objc
    private func countPickerViewValueChange(control: TimerSectionCountPickerView){
        listener?.countPickerDidValueChange(count: control.count)
    }
    

    
}
