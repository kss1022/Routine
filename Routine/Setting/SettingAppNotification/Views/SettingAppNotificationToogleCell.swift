//
//  SettingAppNotificationSwitchCell.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import UIKit



final class SettingAppNotificationToogleCell: UITableViewCell{
    
    public var valueChanged: ((Bool) -> Void)?
    
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
    
    func bindView(_ viewModel: SettingAlarmViewModel){        
        var content = defaultContentConfiguration()
        content.textProperties.font = .getFont(style: .callout)
        content.image = viewModel.image
        content.text = viewModel.title
        contentConfiguration = content
        toogle.isOn = viewModel.isOn
        
        selectionStyle = .none
    }
    
    func bindView(_ viewModel: SettingDaliyReminderViewModel){
        var content = defaultContentConfiguration()
        content.textProperties.font = .getFont(style: .callout)
        content.secondaryTextProperties.font = .getFont(style: .caption2)
        content.secondaryTextProperties.color = .systemBlue
        content.image = viewModel.image
        content.text = viewModel.title

        if viewModel.isOn{
            toogle.isOn = true
            content.secondaryText = viewModel.subTitle
            selectionStyle = .gray
        }else{
            toogle.isOn = false
            content.secondaryText = nil
            selectionStyle = .none
        }
        
        contentConfiguration = content
    }
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentConfiguration = nil
        selectionStyle = .none
        
        valueChanged = nil
        toogle.isOn = false
    }

    
    @objc
    private func toogleValueChanged(_ sender: UISwitch){
        valueChanged?(sender.isOn)
    }
    

}
