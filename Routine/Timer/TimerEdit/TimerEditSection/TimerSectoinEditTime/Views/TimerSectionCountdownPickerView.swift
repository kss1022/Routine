//
//  TimerSectionCountdownPickerView.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import UIKit


final class TimerSectionCountdownPickerView: UIControl{

    var min: Int
    var sec: Int
    
    private let countDownNumberArray: [Int]

    
    private lazy var countdownPickerView: UIPickerView = {
        var pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    
    init(){
        self.countDownNumberArray = Array(0...59)
        self.min = countDownNumberArray[0]
        self.sec = countDownNumberArray[0]
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        self.countDownNumberArray = Array(0...59)
        self.min = countDownNumberArray[0]
        self.sec = countDownNumberArray[0]
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
    
    func setCountDown(min: Int, sec: Int){
        self.min = min
        self.sec = sec
        countdownPickerView.selectRow(min, inComponent: 0, animated: false)
        countdownPickerView.selectRow(sec, inComponent: 1, animated: false)
    }
    
}


extension TimerSectionCountdownPickerView: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countDownNumberArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component{
        case 0: return "\(countDownNumberArray[row]) Min"
        case 1: return "\(countDownNumberArray[row]) Sec"
        default: fatalError("Invalid Component: \(component)")
        }
    }
}

extension TimerSectionCountdownPickerView: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component{
        case 0:
            min = countDownNumberArray[row]
        case 1:
            sec = countDownNumberArray[row]
        default:
            fatalError("Invalid Component: \(component)")
        }
        
        if min == 0 && sec == 0{
            pickerView.selectRow(1, inComponent: 1, animated: true)
            sec = countDownNumberArray[1]
        }
        
        sendActions(for: .valueChanged)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        var pickerLabel = view as? UILabel;
                
        if (pickerLabel == nil){
            pickerLabel = UILabel()
            pickerLabel?.font = .getFont(size: 21.5)
            pickerLabel?.textAlignment = .center
        }

        switch component{
            
        case 0: pickerLabel?.text = "editTimerCountdown_min".localizedWithFormat(tableName: "Timer", arguments: countDownNumberArray[row])  //"\(countDownNumberArray[row]) Min"
        case 1: pickerLabel?.text = "editTimerCountdown_sec".localizedWithFormat(tableName: "Timer", arguments: countDownNumberArray[row])  //"\(countDownNumberArray[row]) Sec"
        default: fatalError("Invalid Component: \(component)")
        }

        return pickerLabel!
    }
}
