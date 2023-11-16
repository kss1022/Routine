//
//  ProfileCardInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import ModernRIBs

protocol ProfileCardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProfileCardPresentable: Presentable {
    var listener: ProfileCardPresentableListener? { get set }
    func setProfileCard(name: String, introduce: String , barcode: String)
}

protocol ProfileCardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class ProfileCardInteractor: PresentableInteractor<ProfileCardPresentable>, ProfileCardInteractable, ProfileCardPresentableListener {

    weak var router: ProfileCardRouting?
    weak var listener: ProfileCardListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: ProfileCardPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        presenter.setProfileCard(
            name: "HG",
            introduce: "Edit Your Introduction",
            barcode: "YOU CAN DO IT!"
        )
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
