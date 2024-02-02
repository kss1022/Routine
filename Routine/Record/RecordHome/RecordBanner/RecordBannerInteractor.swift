//
//  RecordBannerInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/2/23.
//

import ModernRIBs

protocol RecordBannerRouting: ViewableRouting {
}

protocol RecordBannerPresentable: Presentable {
    var listener: RecordBannerPresentableListener? { get set }
}

protocol RecordBannerListener: AnyObject {
    func recordBannerDidTap(index: Int)
}

final class RecordBannerInteractor: PresentableInteractor<RecordBannerPresentable>, RecordBannerInteractable, RecordBannerPresentableListener {

    weak var router: RecordBannerRouting?
    weak var listener: RecordBannerListener?

    // in constructor.
    override init(presenter: RecordBannerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func bannerCellDidTap(index: Int) {
        listener?.recordBannerDidTap(index: index)
    }
}
