//
//  SettingAppNotificationDatePickerCell.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import UIKit


final class SettingAppNotificationDatePickerCell: UITableViewCell{
    
    var valueChanged : ( (Date) -> Void)?
    
    private lazy var timePikcer: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(timePickerValueChanged(_:)), for: .valueChanged)
        return datePicker
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setView(){
        contentView.addSubview(timePikcer)
        
        NSLayoutConstraint.activate([
            timePikcer.topAnchor.constraint(equalTo: contentView.topAnchor),
            timePikcer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timePikcer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            timePikcer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func bindView(_ viewModel: SettingDaliyReminderViewModel){        
        timePikcer.setDate(viewModel.date, animated: false)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timePikcer.date = Date()
        valueChanged = nil
    }
    
    @objc
    private func timePickerValueChanged(_ sender: UIDatePicker){
        valueChanged?(sender.date)
    }
    
}
