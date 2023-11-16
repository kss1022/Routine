//
//  ProfileStatRouter.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileStatInteractable: Interactable, ProfileRecordListener, ProfileAcheiveListener {
    var router: ProfileStatRouting? { get set }
    var listener: ProfileStatListener? { get set }
}

protocol ProfileStatViewControllable: ViewControllable {
    func attachProfileRecord(_ view: ViewControllable)
    func detachProfileRecord(_ view: ViewControllable)
    
    func attachProfileAcheive(_ view: ViewControllable)
    func detachProfileAcheive(_ view: ViewControllable)
}

final class ProfileStatRouter: ViewableRouter<ProfileStatInteractable, ProfileStatViewControllable>, ProfileStatRouting {

    private let profileRecordBuildable: ProfileRecordBuildable
    private var profileRecordRouter: ProfileRecordRouting?
    
    private let profileAcheiveBuildable: ProfileAcheiveBuildable
    private var profileAcheiveRouter: ProfileAcheiveRouting?
    
    init(
        interactor: ProfileStatInteractable,
        viewController: ProfileStatViewControllable,
        profileRecordBuildable: ProfileRecordBuildable,
        profileAcheiveBuildable: ProfileAcheiveBuildable
    ) {
        self.profileRecordBuildable = profileRecordBuildable
        self.profileAcheiveBuildable = profileAcheiveBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachProfileRecord() {
        if profileRecordRouter != nil{
            return
        }
        
        let router = profileRecordBuildable.build(withListener: interactor)
        viewController.attachProfileRecord(router.viewControllable)
        
        profileRecordRouter = router
        attachChild(router)
    }
    
    func detachProfileRecord() {
        guard let router = profileRecordRouter else { return }
        viewController.detachProfileRecord(router.viewControllable)
        
        detachChild(router)
        profileRecordRouter = nil
    }
    
    func attachProfileAcheive() {
        if profileAcheiveRouter != nil{
            return
        }
        
        let router = profileAcheiveBuildable.build(withListener: interactor)
        viewController.attachProfileAcheive(router.viewControllable)
        
        profileAcheiveRouter = router
        attachChild(router)
    }
    
    func detachProfileAcheive() {
        guard let router = profileAcheiveRouter else { return }
        viewController.detachProfileAcheive(router.viewControllable)
        
        detachChild(router)
        profileAcheiveRouter = nil
    }
}
