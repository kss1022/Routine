//
//  ProfileEditDescriptionInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import ModernRIBs

protocol ProfileEditDescriptionRouting: ViewableRouting {
}

protocol ProfileEditDescriptionPresentable: Presentable {
    var listener: ProfileEditDescriptionPresentableListener? { get set }
    func setDescription(description: String)
}

protocol ProfileEditDescriptionListener: AnyObject {
    func profileEditDescriptionDidMove()
    func profileEditDescriptionSetDescription()
}

protocol ProfileEditDescriptionInteractorDependency{
    var profileDescriptionSubject: CurrentValuePublisher<String>{ get}
}

final class ProfileEditDescriptionInteractor: PresentableInteractor<ProfileEditDescriptionPresentable>, ProfileEditDescriptionInteractable, ProfileEditDescriptionPresentableListener {

    weak var router: ProfileEditDescriptionRouting?
    weak var listener: ProfileEditDescriptionListener?

    private let dependency: ProfileEditDescriptionInteractorDependency
    
    // in constructor.
    init(
        presenter: ProfileEditDescriptionPresentable,
        dependency: ProfileEditDescriptionInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        let descrption = dependency.profileDescriptionSubject.value
        presenter.setDescription(description: descrption)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didMove() {
        listener?.profileEditDescriptionDidMove()
    }
    
    func doneButtonDidTap(description: String?) {
        if description == nil || description!.isEmpty{
            //TODO: Show EmptyLabel
        }
        dependency.profileDescriptionSubject.send(description!)
        listener?.profileEditDescriptionSetDescription()
    }
}
