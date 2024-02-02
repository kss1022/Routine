//
//  SettingFontSizeInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import Foundation
import ModernRIBs
import Combine

protocol SettingFontSizeRouting: ViewableRouting {
}

protocol SettingFontSizePresentable: Presentable {
    var listener: SettingFontSizePresentableListener? { get set }
    
    func setOSFontToogle(isOn: Bool)
        
    func setFontSizeSliderEnable(enable: Bool)
    func setFontSize(appfontSize: AppFontSize)
}

protocol SettingFontSizeListener: AnyObject {
    func settingFontSizeDidOnOSSize()
    func settingFontSizeDidOffOSSize()
    func settingFontSizeDidSetAppFontSize(appFontSize: AppFontSize)
}

protocol SettingFontSizeInteractorDependency{
    var isOsFontSize: ReadOnlyCurrentValuePublisher<Bool>{ get }
    var fontSize: ReadOnlyCurrentValuePublisher<AppFontSize>{ get }
}

final class SettingFontSizeInteractor: PresentableInteractor<SettingFontSizePresentable>, SettingFontSizeInteractable, SettingFontSizePresentableListener {

    weak var router: SettingFontSizeRouting?
    weak var listener: SettingFontSizeListener?
    
    private let dependency: SettingFontSizeInteractorDependency
    
    private let isOsFontSize: ReadOnlyCurrentValuePublisher<Bool>
    private let fontSize: ReadOnlyCurrentValuePublisher<AppFontSize>
    
    private var cancellables: Set<AnyCancellable>

    
    // in constructor.
    init(
        presenter: SettingFontSizePresentable,
        dependency: SettingFontSizeInteractorDependency
    ) {
        self.dependency = dependency
        self.isOsFontSize = dependency.isOsFontSize
        self.fontSize = dependency.fontSize
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
     
        
        isOsFontSize.receive(on: DispatchQueue.main)
            .sink { isOSFont in
                self.presenter.setOSFontToogle(isOn: isOSFont)
                self.presenter.setFontSizeSliderEnable(enable: !isOSFont)
            }
            .store(in: &cancellables)
        
        fontSize.receive(on: DispatchQueue.main)
            .sink { fontSize in
                self.presenter.setFontSize(appfontSize: fontSize)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    

    
    func isOSFontToogleDidSetOnOff(isOn: Bool) {
        if isOn{
            listener?.settingFontSizeDidOnOSSize()
            return
        }
        
        listener?.settingFontSizeDidOffOSSize()
    }
    
    func fontSizeSliderDidSetSize(appFontSize: AppFontSize) {
        listener?.settingFontSizeDidSetAppFontSize(appFontSize: appFontSize)
    }

}
