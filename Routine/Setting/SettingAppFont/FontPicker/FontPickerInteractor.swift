//
//  FontPickerInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/17/23.
//

import ModernRIBs

protocol FontPickerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol FontPickerPresentable: Presentable {
    var listener: FontPickerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FontPickerListener: AnyObject {
    func fontPikcerDidPickFont(familyName: String)
    func fontPickerDidTapCancel()
}

final class FontPickerInteractor: PresentableInteractor<FontPickerPresentable>, FontPickerInteractable, FontPickerPresentableListener {

    weak var router: FontPickerRouting?
    weak var listener: FontPickerListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: FontPickerPresentable) {
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
    
    func didPickFont(familyName: String) {
        listener?.fontPikcerDidPickFont(familyName: familyName)
    }
    
    func didTapCancel() {
        listener?.fontPickerDidTapCancel()
    }
}
