//
//  ProfileEditNameInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import ModernRIBs

protocol ProfileEditNameRouting: ViewableRouting {
}

protocol ProfileEditNamePresentable: Presentable {
    var listener: ProfileEditNamePresentableListener? { get set }
    func setName(name: String)
}

protocol ProfileEditNameListener: AnyObject {
    func profileEditNameDidMove()
    func prorilfEditNameSetName()
}

protocol ProfileEditNameInteractorDependency{
    var profileNameSubject: CurrentValuePublisher<String>{ get }
}

final class ProfileEditNameInteractor: PresentableInteractor<ProfileEditNamePresentable>, ProfileEditNameInteractable, ProfileEditNamePresentableListener {

    weak var router: ProfileEditNameRouting?
    weak var listener: ProfileEditNameListener?

    private let dependency: ProfileEditNameInteractorDependency
    
    // in constructor.
    init(
        presenter: ProfileEditNamePresentable,
        dependency: ProfileEditNameInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        let name = dependency.profileNameSubject.value
        presenter.setName(name: name)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didMove() {
        listener?.profileEditNameDidMove()
    }
    
    
    func doneButtonDidTap(name: String?) {                
        if name == nil || name!.isEmpty{
            //TODO: Show EmptyLabel
        }
        
        dependency.profileNameSubject.send(name!)
        listener?.prorilfEditNameSetName()
    }
}
