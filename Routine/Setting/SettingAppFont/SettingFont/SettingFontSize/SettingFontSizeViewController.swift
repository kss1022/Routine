//
//  SettingFontSizeViewController.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import ModernRIBs
import UIKit

protocol SettingFontSizePresentableListener: AnyObject {
    func isOSFontToogleDidSetOnOff(isOn: Bool)
    func fontSizeSliderDidSetSize(appFontSize: AppFontSize)
}

final class SettingFontSizeViewController: UIViewController, SettingFontSizePresentable, SettingFontSizeViewControllable {

    weak var listener: SettingFontSizePresentableListener?
    
    
    private let osSettingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let osSettingTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .headline)
        label.textColor = .label
        label.text = "os_setting".localized(tableName: "Profile")
        return label
    }()
    
    private lazy var osSettingToogle: UISwitch = {
        let toogle = UISwitch()
        toogle.translatesAutoresizingMaskIntoConstraints = false
        toogle.tintColor = .systemGreen
        toogle.addTarget(self, action: #selector(toogleValueChanged(sender:)), for: .valueChanged)
        return toogle
    }()
    
    
    private let osSettingDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setBoldFont(style: .caption2)
        label.textColor = .secondaryLabel
        label.text = "os_setting_help".localized(tableName: "Profile")
        label.numberOfLines = 0
        return label
    }()
    
            
    private lazy var settingFontSlider: SettingFontSlider = {
        let slider = SettingFontSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        slider.valueChanged = { [weak self] fontSize in
            self?.fontSliderValueChanged(fontSize: fontSize)
        }

        return slider
    }()
    
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setLayout()
    }
    
    
    private func setLayout(){

        
        view.addSubview(osSettingStackView)
        view.addSubview(osSettingDescriptionLabel)
        view.addSubview(settingFontSlider)

        
        osSettingStackView.addArrangedSubview(osSettingTitleLabel)
        osSettingStackView.addArrangedSubview(osSettingToogle)
        
        
        let inset: CGFloat = 16.0
        
        NSLayoutConstraint.activate([
            osSettingStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: inset),
            osSettingStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            osSettingStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            
            osSettingDescriptionLabel.topAnchor.constraint(equalTo: osSettingStackView.bottomAnchor, constant: 16.0),
            osSettingDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            osSettingDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            
            settingFontSlider.topAnchor.constraint(equalTo: osSettingDescriptionLabel.bottomAnchor, constant: 32.0),
            settingFontSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: inset),
            settingFontSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -inset),
            settingFontSlider.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -inset)
        ])
    }
    
    
    
    func setOSFontToogle(isOn: Bool) {
        osSettingToogle.isOn = isOn
    }
    
    func setFontSizeSliderEnable(enable: Bool) {
        settingFontSlider.isEnabled = enable
    }
    
    func setFontSize(appfontSize: AppFontSize) {
        settingFontSlider.setFontSize(appfontSize)
    }
    
    @objc
    private func toogleValueChanged(sender: UISwitch){
        listener?.isOSFontToogleDidSetOnOff(isOn: sender.isOn)
    }
    
    private func fontSliderValueChanged(fontSize: AppFontSize){
        listener?.fontSizeSliderDidSetSize(appFontSize: fontSize)
    }
}
