//
//  TimerEditCountdownPickerView.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import UIKit



final class TimerEditCountdownPickerView: UIControl{

    private(set) var hour: Int
    private(set) var min: Int
            
    private let countdownHourArray: [Int]
    private let countdownMinArray: [Int]
    
    private lazy var countdownPickerView: UIPickerView = {
        var pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    
    init(){
        self.countdownHourArray = Array(0...23)
        self.countdownMinArray = Array(0...59)
        
        self.hour = countdownHourArray[0]
        self.min = countdownHourArray[0]
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        self.countdownHourArray = Array(0...23)
        self.countdownMinArray = Array(0...59)
        
        self.hour = countdownHourArray[0]
        self.min = countdownHourArray[0]
        super.init(coder: coder)
        
        setLayout()
    }
    
    
    private func setLayout(){
        
        self.addSubview(countdownPickerView)
        
        NSLayoutConstraint.activate([
            countdownPickerView.topAnchor.constraint(equalTo: self.topAnchor),
            countdownPickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countdownPickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countdownPickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setCountdown(hour: Int, min: Int){
        self.hour = hour
        self.min = min
        countdownPickerView.selectRow(hour, inComponent: 0, animated: false)
        countdownPickerView.selectRow(min, inComponent: 1, animated: false)
    }
    
}


extension TimerEditCountdownPickerView: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        component == 0 ? countdownHourArray.count : countdownMinArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component{
        case 0: return "\(countdownHourArray[row]) Hour"
        case 1: return "\(countdownMinArray[row]) Min"
        default: fatalError("Invalid Component: \(component)")
        }
    }
}

extension TimerEditCountdownPickerView: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component{
        case 0:
            self.hour = countdownHourArray[row]
            sendActions(for: .valueChanged)
        case 1:
            self.min = countdownMinArray[row]
            sendActions(for: .valueChanged)
        default:
            fatalError("Invalid Component: \(component)")
        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var pickerLabel = view as? UILabel;
                
        if (pickerLabel == nil){
            pickerLabel = UILabel()
            pickerLabel?.font = .getFont(size: 21.5)
            pickerLabel?.textAlignment = .center
        }

        switch component{
        case 0: pickerLabel?.text = "editTimerCountdown_hour".localizedWithFormat(tableName: "Timer" ,arguments: countdownHourArray[row]) //"\(countdownHourArray[row]) Hour"
        case 1: pickerLabel?.text =  "editTimerCountdown_min".localizedWithFormat(tableName: "Timer" ,arguments: countdownMinArray[row]) //"\(countdownMinArray[row]) Min"
        default: fatalError("Invalid Component: \(component)")
        }

        return pickerLabel!
    }
}


