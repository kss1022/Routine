//
//  FontPreviewInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/16/23.
//

import ModernRIBs

protocol FontPreviewRouting: ViewableRouting {
}

protocol FontPreviewPresentable: Presentable {
    var listener: FontPreviewPresentableListener? { get set }
}

protocol FontPreviewListener: AnyObject {
}

final class FontPreviewInteractor: PresentableInteractor<FontPreviewPresentable>, FontPreviewInteractable, FontPreviewPresentableListener {

    weak var router: FontPreviewRouting?
    weak var listener: FontPreviewListener?

    // in constructor.
    override init(presenter: FontPreviewPresentable) {
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
