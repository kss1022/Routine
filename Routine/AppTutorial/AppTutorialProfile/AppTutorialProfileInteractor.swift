//
//  AppTutorialProfileInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import Foundation
import ModernRIBs
import Combine

protocol AppTutorialProfileRouting: ViewableRouting {
    func attachAppTutorialSetMemoji()
    func detachAppTutorialSetMemoji()
    func popAppTutorialSetMemoji()
}

protocol AppTutorialProfilePresentable: Presentable {
    var listener: AppTutorialProfilePresentableListener? { get set }
        
    func setType(type: MemojiType)
    func setStyle(style: MemojiStyle)
}

protocol AppTutorialProfileListener: AnyObject {
    func appTutorailProfileDidFinish()
}

protocol AppTutorialProfileInteractorDependency{
    var profileApplicationService: ProfileApplicationService{ get }
    
    var memojiType: ReadOnlyCurrentValuePublisher<MemojiType>{ get }
    var memojiStyle: ReadOnlyCurrentValuePublisher<MemojiStyle>{ get }
}

final class AppTutorialProfileInteractor: PresentableInteractor<AppTutorialProfilePresentable>, AppTutorialProfileInteractable, AppTutorialProfilePresentableListener, AdaptivePresentationControllerDelegate {
        
    weak var router: AppTutorialProfileRouting?
    weak var listener: AppTutorialProfileListener?

    var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
    
    private let dependency: AppTutorialProfileInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    // in constructor.
    init(
        presenter: AppTutorialProfilePresentable,
        dependency: AppTutorialProfileInteractorDependency
    ) {
        self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
        
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presentationDelegateProxy.delegate = self
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        dependency.memojiStyle
            .receive(on: DispatchQueue.main)
            .sink {
                self.presenter.setStyle(style: $0)
            }
            .store(in: &cancellables)
        
        dependency.memojiType
            .receive(on: DispatchQueue.main)
            .sink {
                self.presenter.setType(type: $0)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }

    

    func presentationControllerDidDismiss() {
        router?.detachAppTutorialSetMemoji()
    }
    
        
    func continueButtonDidTap() {
        Task{ [weak self] in
            do{
                guard let self = self else { return }

                let memojiType = self.dependency.memojiType.value
                let memojiStyle = self.dependency.memojiStyle.value
                
                //TODO: Handler color nil
                guard let topColor = memojiStyle.topColor?.toHex(),
                      let bottomColor = memojiStyle.bottomColor?.toHex() else { return }
                
                if case let .memoji(image) = memojiType,
                        let data = image?.pngData(){
                    let manager = AppFileManager.shared
                    let fileName = memojiType.value()
                    let imagePath = manager.imagePath
                    try manager.deleteIfExists(url: imagePath, fileName: fileName, type: .png)
                    try manager.save(data: data, url: imagePath, fileName: fileName, type: .png)
                }
                                
                let createProfile = CreateProfile(
                    name: "",
                    description: "",
                    imageType: memojiType.type(),
                    imageValue: memojiType.value(),
                    topColor: topColor,
                    bottomColor: bottomColor
                )
                
                try await dependency.profileApplicationService.when(createProfile)
                await MainActor.run { [weak self] in self?.listener?.appTutorailProfileDidFinish() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
            }
        }
    }
    
    //MARK: Memoji
    func memojiButtonDidTap() {
        router?.attachAppTutorialSetMemoji()
    }
    
    func appTutorialMemojiCloseButtonDidTap() {
        router?.popAppTutorialSetMemoji()
    }


}


extension MemojiType{
    func type() -> String{
        switch self {
        case .memoji: "memoji"
        case .emoji: "emoji"
        case .text: "text"
        }
    }
    
    func value() -> String{
        switch self {
        case .memoji: "profileImage"
        case .emoji(let string): string
        case .text(let string): string
        }
    }
}
