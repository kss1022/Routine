//
//  RoutineEditStyleInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/30/23.
//

import ModernRIBs

protocol RoutineEditStyleRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineEditStylePresentable: Presentable {
    var listener: RoutineEditStylePresentableListener? { get set }
    func setStyle(style: EmojiStyle)
}

protocol RoutineEditStyleListener: AnyObject {
    func routineEditStyleDidSetStyle(style: EmojiStyle)
}

protocol RoutineEditStyleInteractorDependency{
    var detail: RoutineDetailModel?{ get }
}

final class RoutineEditStyleInteractor: PresentableInteractor<RoutineEditStylePresentable>, RoutineEditStyleInteractable, RoutineEditStylePresentableListener {

    weak var router: RoutineEditStyleRouting?
    weak var listener: RoutineEditStyleListener?

    private let dependency: RoutineEditStyleInteractorDependency
    
    // in constructor.
    init(
        presenter: RoutineEditStylePresentable,
        dependency: RoutineEditStyleInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        if let tint = dependency.detail?.tint,
           let style = EmojiStyle(hex: tint){
            self.presenter.setStyle(style: style)
        }else if let style = EmojiStyle(hex: "#A8ADBAFF"){
            self.presenter.setStyle(style: style)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didSetStyle(style: EmojiStyle) {
        listener?.routineEditStyleDidSetStyle(style: style)
    }
}
