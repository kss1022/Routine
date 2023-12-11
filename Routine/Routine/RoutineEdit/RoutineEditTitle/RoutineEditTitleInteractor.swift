//
//  RoutineEditTitleInteractor.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//


import ModernRIBs


protocol RoutineEditTitleRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineEditTitlePresentable: Presentable {
    var listener: RoutineEditTitlePresentableListener? { get set }

    func setTitle(emoji: String, routineName: String?, routineDescription: String?)
    func setEmoji(_ emoji: String)

}

protocol RoutineEditTitleListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func routineEditTitleSetName(name: String)
    func routineEditTitleSetDescription(description: String)
    func routineEditTitleDidSetEmoji(emoji: String)
}

protocol RoutineEditTitleInteractorDependency{
    var detail: RoutineDetailModel?{ get }
}

final class RoutineEditTitleInteractor: PresentableInteractor<RoutineEditTitlePresentable>, RoutineEditTitleInteractable, RoutineEditTitlePresentableListener {

    weak var router: RoutineEditTitleRouting?
    weak var listener: RoutineEditTitleListener?
    
    private let dependency : RoutineEditTitleInteractorDependency
    private let detail: RoutineDetailModel?
    
    // in constructor.
    init(
        presenter: RoutineEditTitlePresentable,
        dependency: RoutineEditTitleInteractorDependency
    ) {
        self.dependency = dependency
        self.detail = dependency.detail
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()        
        presenter.setTitle(
            emoji: detail?.emojiIcon ?? "🍎",
            routineName: detail?.routineName,
            routineDescription: detail?.routineDescription
        )
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didSetRoutineName(name: String) {
        listener?.routineEditTitleSetName(name: name)
    }
    
    func didSetRoutineDescription(description: String) {
        listener?.routineEditTitleSetDescription(description: description)
    }
    
    func didSetEmoji(emoji: String) {
        presenter.setEmoji(emoji)
        listener?.routineEditTitleDidSetEmoji(emoji: emoji)
    }
}
