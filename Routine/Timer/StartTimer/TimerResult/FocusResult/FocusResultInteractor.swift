//
//  FocusResultInteractor.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import ModernRIBs

protocol FocusResultRouting: ViewableRouting {
}

protocol FocusResultPresentable: Presentable {
    var listener: FocusResultPresentableListener? { get set }
}

protocol FocusResultListener: AnyObject {
}

final class FocusResultInteractor: PresentableInteractor<FocusResultPresentable>, FocusResultInteractable, FocusResultPresentableListener {

    weak var router: FocusResultRouting?
    weak var listener: FocusResultListener?

    // in constructor.
    override init(presenter: FocusResultPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
