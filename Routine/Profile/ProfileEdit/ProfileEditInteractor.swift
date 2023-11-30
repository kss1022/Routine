//
//  ProfileEditInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation
import ModernRIBs
import UIKit

protocol ProfileEditRouting: ViewableRouting {
    func attachProfileEditName()
    func detachProfileEditName()
    func popProfileEditName()
    
    func attachProfileEditDescription()
    func detachProfileEditDescription()
    func popProfileEditDescription()
    
    func attchProfileEditMemoji()
}

protocol ProfileEditPresentable: Presentable {
    var listener: ProfileEditPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol ProfileEditListener: AnyObject {
    func profileEditCloseButtonDidTap()
}

protocol ProfileEditInteractorDependency{
    var profileApplicationService: ProfileApplicationService{ get }
    var profileRepository: ProfileRepository{ get }
    
    var profile: ProfileModel?{ get }
    var profileName: ReadOnlyCurrentValuePublisher<String>{ get }
    var profileDescription: ReadOnlyCurrentValuePublisher<String>{ get }
}

final class ProfileEditInteractor: PresentableInteractor<ProfileEditPresentable>, ProfileEditInteractable, ProfileEditPresentableListener {
    
    weak var router: ProfileEditRouting?
    weak var listener: ProfileEditListener?
    
    
    private let dependency: ProfileEditInteractorDependency
    
        
    private var memojiType: MemojiType
    private var memojiStyle: MemojiStyle
    
    // in constructor.
    init(
        presenter: ProfileEditPresentable,
        dependency: ProfileEditInteractorDependency
    ) {
        self.dependency = dependency
        
        let profile  = dependency.profile!
        
        switch profile.profileImage {
        case .memoji(let memoji): memojiType = .memoji(image: UIImage(fileName: memoji))
        case .emoji(let emoji): memojiType = .emoji(emoji)
        case .text(let text): memojiType = .text(text)
        }
                         
        self.memojiStyle = MemojiStyle(
            topColor: profile.topColor,
            bottomColor: profile.bottomColor
        )
        
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attchProfileEditMemoji()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func closeButtonDidTap() {
        listener?.profileEditCloseButtonDidTap()
    }
    
    func doneButtonDidTap() {
        Task{ [weak self] in
            do{
                guard let self = self else { return }
                //TODO: Handler color nil
                guard let topColor = memojiStyle.topColor?.toHex(),
                      let bottomColor = memojiStyle.bottomColor?.toHex() else { return }
                
                if case let .memoji(image) = memojiType,
                        let data = image?.pngData(){
                    let manager = AppFileManager.share
                    let fileName = memojiType.value()
                    let imagePath = manager.imagePath
                    try manager.deleteIfExists(url: imagePath, fileName: fileName, type: .png)
                    try manager.save(data: data, url: imagePath, fileName: fileName, type: .png)
                }
                

                
                let update = UpdateProfile(
                    profileId: dependency.profile!.profileId,
                    name: dependency.profileName.value,
                    description: dependency.profileDescription.value,
                    imageType: memojiType.type(),
                    imageValue: memojiType.value(),
                    topColor: topColor,
                    bottomColor: bottomColor
                )
                
                try await dependency.profileApplicationService.when(update)
                try await dependency.profileRepository.fetchProfile()
                await MainActor.run { [weak self] in self?.listener?.profileEditCloseButtonDidTap() }
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.message)
                }else{
                    Log.e("UnkownError\n\(error.localizedDescription)" )
                }
            }
        }
    }
    
    //MARK: ProfileEditMemoji
    func profileEditMemojiNameButtonDidTap() {
        router?.attachProfileEditName()
    }
    
    func profileEditMemojiDescriptionButtonDidTap() {
        router?.attachProfileEditDescription()
    }
    
    
    func profileEditMemojiDidSetType(type: MemojiType) {
        self.memojiType = type
    }
    
    func profileEditMemojiDidSetStyle(style: MemojiStyle) {
        self.memojiStyle = style
    }
    
    
    //MARK: ProfileEditName
    func profileEditNameDidMove() {
        router?.detachProfileEditName()
    }
    
    func prorilfEditNameSetName() {
        router?.popProfileEditName()
    }
    
    //MARK: PRofileEditDescription
    func profileEditDescriptionDidMove() {
        router?.detachProfileEditDescription()
    }
    
    func profileEditDescriptionSetDescription() {
        router?.popProfileEditDescription()
    }
    
}
