//
//  CountPickerView.swift
//  Routine
//
//  Created by 한현규 on 10/18/23.
//

import UIKit



final class CountPickerView: UIControl{

    
    var value: Int
    
    private let countNumberArray: [Int]
    
    private lazy var countPickerView: UIPickerView = {
        var pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    
    init(){
        self.countNumberArray = Array(0...59)
        self.value = countNumberArray[0]        
        super.init(frame: .zero)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        self.countNumberArray = Array(0...59)
        self.value = countNumberArray[0]
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
    
}


extension CountPickerView: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countNumberArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component{
        case 0:
            return "\(countNumberArray[row]) Reps"
        default:
            fatalError("Invalid Component: \(component)")
        }
    }
}

extension CountPickerView: UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component{
        case 0:
            self.value = countNumberArray[row]
            self.sendActions(for: .valueChanged)
        default:
            fatalError("Invalid Component: \(component)")
        }
    }
}
