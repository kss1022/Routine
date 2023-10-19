//
//  CountdownPickerView.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import UIKit


final class CountdownPickerView: UIControl{

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
    
}


extension CountdownPickerView: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countDownNumberArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component{
        case 0:
            return "\(countDownNumberArray[row]) Min"
        case 1:
            return "\(countDownNumberArray[row]) Sec"
        default:
            fatalError("Invalid Component: \(component)")
        }
    }
}

extension CountdownPickerView: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component{
        case 0:
            Log.v("SelectedHour \(row)")
        case 1:
            Log.v("SelectedHour \(row)")
        default:
            fatalError("Invalid Component: \(component)")
        }
    }
}
