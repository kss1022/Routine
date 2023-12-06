//
//  SettingRoutineReminderCell.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import UIKit



final class SettingRoutineReminderCell: UITableViewCell{
    
    var valueChanged: ((Bool) -> Void)?
    
    
    private lazy var toogle: UISwitch = {
        let toogle = UISwitch()
        toogle.addTarget(self, action: #selector(toogleValueChanged(_:)), for: .valueChanged)
        return toogle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setView(){
        self.accessoryView = self.toogle
        self.selectionStyle = .none
    }

    func bindView(_ viewModel: SettingRoutineReminderViewModel){
        var content = defaultContentConfiguration()
        content.textProperties.font = .getFont(style: .callout)
        content.secondaryTextProperties.font = .getFont(style: .caption2)
        content.secondaryTextProperties.color = .systemBlue        
        content.image = viewModel.emoji.toImage(size: 24.0)
        content.text = viewModel.routineName
        content.secondaryText = viewModel.reminderTime        
        contentConfiguration = content
                
        toogle.isOn = viewModel.isOn
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentConfiguration = nil
        
        valueChanged = nil
        toogle.isOn = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    @objc
    private func toogleValueChanged(_ sender: UISwitch){
        valueChanged?(sender.isOn)
    }
}



