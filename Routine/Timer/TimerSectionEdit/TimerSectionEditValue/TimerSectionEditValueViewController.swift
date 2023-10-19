//
//  TimerSectionEditValueViewController.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import ModernRIBs
import UIKit

protocol TimerSectionEditValuePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class TimerSectionEditValueViewController: UIViewController, TimerSectionEditValuePresentable, TimerSectionEditValueViewControllable {

    weak var listener: TimerSectionEditValuePresentableListener?
        
    private lazy var countdownPickerView: UIControl = {
        var pickerView = CountdownPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.addTarget(self, action: #selector(countdownPickerViewValueChange(control:)), for: .valueChanged)
        return pickerView
    }()
    
    private lazy var countPickerView: UIControl = {
        var pickerView = CountPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.addTarget(self, action: #selector(countPickerViewValueChange(control:)), for: .valueChanged)
        return pickerView
    }()
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func showCountDownPicker() {
        view.addSubview(countdownPickerView)
        
        NSLayoutConstraint.activate([
            countdownPickerView.topAnchor.constraint(equalTo: view.topAnchor),
            countdownPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countdownPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countdownPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showCountPicker() {
        view.addSubview(countPickerView)
        
        NSLayoutConstraint.activate([
            countPickerView.topAnchor.constraint(equalTo: view.topAnchor),
            countPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            countPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            countPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
    
    @objc
    private func countdownPickerViewValueChange(control: CountdownPickerView){
        Log.v("\(control.min) min \(control.min) sec")
        
    }
    
    @objc
    private func countPickerViewValueChange(control: CountPickerView){
        Log.v("\(control.value)")
        
    }
    
}

