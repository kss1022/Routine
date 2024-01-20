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

//    private var isCustomSize: Bool
//    private var customSize: Float
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SettingFontSizePresentable) {
//        self.isCustomSize = AppFontService.shared.isCustomSize
//        self.customSize = AppFontService.shared.customSize
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
     
        
        
//        presenter.setToogleEnable(isOn: !isCustomSize)
//        presenter.setSliderEnabel(enable: isCustomSize)
//        presenter.setSliderValue(value: customSize)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func toogleValueChanged(isOn: Bool) {
//        self.isCustomSize = !isOn
//        presenter.setSliderEnabel(enable: isCustomSize)
//        
//        if isOn{
//            listener?.settingFontSizeSetOsSize()
//        }else{
//            listener?.settingFontSizeSetCustomSize(value: customSize)
//        }
    }
    
    func sliderValueChanged(value: Float) {
//        self.customSize = value
//        listener?.settingFontSizeSetCustomSize(value: customSize)
    }
}
