//
//  RecordBannerInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/2/23.
//

import ModernRIBs

protocol RecordBannerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RecordBannerPresentable: Presentable {
    var listener: RecordBannerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RecordBannerListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RecordBannerInteractor: PresentableInteractor<RecordBannerPresentable>, RecordBannerInteractable, RecordBannerPresentableListener {

    weak var router: RecordBannerRouting?
    weak var listener: RecordBannerListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RecordBannerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
