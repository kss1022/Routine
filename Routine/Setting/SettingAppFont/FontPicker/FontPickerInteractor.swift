//
//  FontPickerInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/17/23.
//

import ModernRIBs

protocol FontPickerRouting: ViewableRouting {
}

protocol FontPickerPresentable: Presentable {
    var listener: FontPickerPresentableListener? { get set }
}

protocol FontPickerListener: AnyObject {
    func fontPikcerDidPickFont(familyName: String)
    func fontPickerDidTapCancel()
}

final class FontPickerInteractor: PresentableInteractor<FontPickerPresentable>, FontPickerInteractable, FontPickerPresentableListener {

    weak var router: FontPickerRouting?
    weak var listener: FontPickerListener?

    // in constructor.
    override init(presenter: FontPickerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func didPickFont(familyName: String) {
        listener?.fontPikcerDidPickFont(familyName: familyName)
    }
    
    func didTapCancel() {
        listener?.fontPickerDidTapCancel()
    }
}
