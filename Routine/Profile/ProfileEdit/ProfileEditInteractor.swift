//
//  ProfileEditInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import ModernRIBs

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
    
        
    private var profileImageType: ProfilImageTypeModel
    private var profileImageValue: String
    private var style: ProfileStyleModel
    
    // in constructor.
    init(
        presenter: ProfileEditPresentable,
        dependency: ProfileEditInteractorDependency
    ) {
        self.dependency = dependency
        
        let profile  = dependency.profile!
        self.profileImageType = profile.profileImage.profileType
        self.profileImageValue = profile.profileImage.profileValue
        self.style = profile.profileStyle
        
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
        Task{
            do{
                let update = UpdateProfile(
                    profileId: dependency.profile!.profileId,
                    name: dependency.profileName.value,
                    description: dependency.profileDescription.value,
                    imageType: profileImageType.rawValue,
                    imageValue: profileImageValue,
                    topColor: style.topColor,
                    bottomColor: style.bottomColor
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
    

    
    func profileEditTitleSetEmoji(emoji: String) {
        self.profileImageType = .emoji
        self.profileImageValue = emoji
    }
    
    func profileEditTitleSetText(text: String) {
        self.profileImageType = .text
        self.profileImageValue = text
    }
    
    func profileEditTitleSetSyle(style: ProfileStyleModel) {
        self.style = style
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
