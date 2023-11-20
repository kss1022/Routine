//
//  SettingFontSizeInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import ModernRIBs

protocol SettingFontSizeRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SettingFontSizePresentable: Presentable {
    var listener: SettingFontSizePresentableListener? { get set }
    
    func setToogleEnable(isOn: Bool)
    
    func setSliderEnabel(enable: Bool)
    func setSliderValue(value: Float)
}

protocol SettingFontSizeListener: AnyObject {
    func settingFontSizeSetOsSize()
    func settingFontSizeSetCustomSize(value: Float)
}

final class SettingFontSizeInteractor: PresentableInteractor<SettingFontSizePresentable>, SettingFontSizeInteractable, SettingFontSizePresentableListener {

    weak var router: SettingFontSizeRouting?
    weak var listener: SettingFontSizeListener?

    private var isOsSize: Bool = true
    private var customValue: Float = 30.0
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SettingFontSizePresentable) {
                
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
     
        
        
        presenter.setToogleEnable(isOn: isOsSize)
        presenter.setSliderEnabel(enable: !isOsSize)
        presenter.setSliderValue(value: customValue)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func toogleValueChanged(isOn: Bool) {
        self.isOsSize = isOn
        presenter.setSliderEnabel(enable: isOn)
        
        if isOn{
            listener?.settingFontSizeSetOsSize()
        }else{
            listener?.settingFontSizeSetCustomSize(value: customValue)
        }
    }
    
    func sliderValueChanged(value: Float) {
        self.customValue = value
        listener?.settingFontSizeSetCustomSize(value: customValue)
    }
}
