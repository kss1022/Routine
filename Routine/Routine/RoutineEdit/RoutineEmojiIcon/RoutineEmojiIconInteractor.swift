//
//  RoutineEmojiIconInteractor.swift
//  Routine
//
//  Created by 한현규 on 9/30/23.
//

import ModernRIBs
import Combine

protocol RoutineEmojiIconRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RoutineEmojiIconPresentable: Presentable {
    var listener: RoutineEmojiIconPresentableListener? { get set }
    
    
    func setEmojis(_ emojis: [String])
    func setEmoji(pos: Int)
}

protocol RoutineEmojiIconListener: AnyObject {
    func routineEmojiSetEmoji(emoji: String)
}

protocol RoutineEmojiIconInteractorDependency{
    var routineRepository: RoutineRepository { get }
    var detail: RoutineDetailModel?{ get }
}

final class RoutineEmojiIconInteractor: PresentableInteractor<RoutineEmojiIconPresentable>, RoutineEmojiIconInteractable, RoutineEmojiIconPresentableListener {

    weak var router: RoutineEmojiIconRouting?
    weak var listener: RoutineEmojiIconListener?
    

    private var cancelables: Set<AnyCancellable>
    private let dependency: RoutineEmojiIconInteractorDependency
    
    // in constructor.
    init(
        presenter: RoutineEmojiIconPresentable,
        dependency: RoutineEmojiIconInteractorDependency
    ) {
        self.cancelables = .init()
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
                
        let emojis = dependency.routineRepository.emojis.map { $0.emoji }
        
        if emojis.count == 0{
            fatalError()
        }
                
        self.presenter.setEmojis(emojis)
        
        let currentEmoji = dependency.detail?.emojiIcon ?? "⭐️" 
        let pos = emojis.firstIndex(of: currentEmoji) ?? 0
        self.presenter.setEmoji(pos: pos)
        listener?.routineEmojiSetEmoji(emoji: currentEmoji)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func emojiButtonDidTap(emoji: String) {
        listener?.routineEmojiSetEmoji(emoji: emoji)
    }
}
