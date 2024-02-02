//
//  SettingTypefaceInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/20/23.
//

import ModernRIBs
import Foundation
import Combine


protocol SettingTypefaceRouting: ViewableRouting {
}

protocol SettingTypefacePresentable: Presentable {
    var listener: SettingTypefacePresentableListener? { get set }
    
    func setOSFontName(_ fontName: String)
    
    func selectOSTypeface()
    func deSelectOSTypeface()
    
    func selectBaseTypeface()
    func deSelectBaseTypeface()
}

protocol SettingTypefaceListener: AnyObject {
    func settingTypefaceDidTapOS()
    func settingTypefaceDidTapBaseType()    
}

protocol SettingTypefaceInteractorDependency{
    var isOSTypeface: ReadOnlyCurrentValuePublisher<Bool>{ get }
    var oSFontName: ReadOnlyCurrentValuePublisher<String>{ get }
}

final class SettingTypefaceInteractor: PresentableInteractor<SettingTypefacePresentable>, SettingTypefaceInteractable, SettingTypefacePresentableListener {

    weak var router: SettingTypefaceRouting?
    weak var listener: SettingTypefaceListener?

    private let dependency: SettingTypefaceInteractorDependency
    
    private let isOSTypeface: ReadOnlyCurrentValuePublisher<Bool>
    private let oSfontName: ReadOnlyCurrentValuePublisher<String>
    
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: SettingTypefacePresentable,
        dependency: SettingTypefaceInteractorDependency
    ) {
        self.dependency = dependency
        self.isOSTypeface = dependency.isOSTypeface
        self.oSfontName = dependency.oSFontName
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        isOSTypeface
            .receive(on: DispatchQueue.main)
            .sink { isOs in
                if isOs{
                    self.presenter.selectOSTypeface()
                    self.presenter.deSelectBaseTypeface()
                    return
                }
                
                self.presenter.deSelectOSTypeface()
                self.presenter.selectBaseTypeface()
            }
            .store(in: &cancellables)
        
        oSfontName
            .receive(on: DispatchQueue.main)
            .sink { fontName in
                self.presenter.setOSFontName(fontName)
            }
            .store(in: &cancellables)      
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func oSTypefaceDidTap() {
        listener?.settingTypefaceDidTapOS()
    }
    
    func baseTypefaceDidTap() {
        listener?.settingTypefaceDidTapBaseType()
    }
}
