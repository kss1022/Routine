//
//  SettingAppThemeCell.swift
//  Routine
//
//  Created by 한현규 on 12/1/23.
//

import UIKit


final class SettingAppThemeCell: UITableViewCell{
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selected ? (self.accessoryType = .checkmark) : (self.accessoryType = .none)
    }
    
    
    func bindView(title: String , imageName: String){
        var content = defaultContentConfiguration()
        content.textProperties.font = .getFont(style: .callout)
        content.text = title
        content.image = UIImage(systemName: imageName)
        self.contentConfiguration = content
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
        self.contentConfiguration = nil
    }
}
