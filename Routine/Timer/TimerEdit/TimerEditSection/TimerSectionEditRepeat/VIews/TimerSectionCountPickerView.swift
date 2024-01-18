//
//  CountPickerView.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import UIKit



final class TimerSectionCountPickerView: UIControl{

    
    var count: Int
    
    private let countNumberArray: [Int]
    
    private lazy var countPickerView: UIPickerView = {
        var pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    
    init(){
        self.countNumberArray = Array(1...59)
        self.count = countNumberArray[0]
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        self.countNumberArray = Array(1...59)
        self.count = countNumberArray[0]
        super.init(coder: coder)
        
        setLayout()
    }
    
    
    private func setLayout(){
        
        self.addSubview(countPickerView)
        
        NSLayoutConstraint.activate([
            countPickerView.topAnchor.constraint(equalTo: self.topAnchor),
            countPickerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            countPickerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            countPickerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setCount(count: Int){
        self.count = count
        countPickerView.selectRow(count-1, inComponent: 0, animated: false)
    }
    
}


extension TimerSectionCountPickerView: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countNumberArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        "editTimerCountdown_rep".localizedWithFormat(tableName: "Timer", arguments: countNumberArray[row]) ////"\(countNumberArray[row]) Reps"
    }
}

extension TimerSectionCountPickerView: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component{
        case 0:
            self.count = countNumberArray[row]
            self.sendActions(for: .valueChanged)
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
        
        pickerLabel?.text =  "\(countNumberArray[row]) Reps"

        return pickerLabel!
    }
}
