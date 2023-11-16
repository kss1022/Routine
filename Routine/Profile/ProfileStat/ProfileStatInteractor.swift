//
//  ProfileStatInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs

protocol ProfileStatRouting: ViewableRouting {
    func attachProfileRecord()
    func detachProfileRecord()
    
//    func attachProfileChart()
//    func detachProfileChart()
    
    func attachProfileAcheive()
    func detachProfileAcheive()
}

protocol ProfileStatPresentable: Presentable {
    var listener: ProfileStatPresentableListener? { get set }
}

protocol ProfileStatListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProfileStatInteractor: PresentableInteractor<ProfileStatPresentable>, ProfileStatInteractable, ProfileStatPresentableListener {

    weak var router: ProfileStatRouting?
    weak var listener: ProfileStatListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ProfileStatPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        router?.attachProfileRecord()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func segmentControlDidTap(index: Int) {
        switch index{
        case 0 :
            router?.detachProfileAcheive()
            router?.attachProfileRecord()
        case 1 :
            router?.detachProfileRecord()
            router?.detachProfileAcheive()
        case 2 :
            router?.detachProfileRecord()
            router?.attachProfileAcheive()
        default: fatalError("Invalid Segment Index")
        }
    }
}
