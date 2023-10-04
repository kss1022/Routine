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
}

protocol RoutineEmojiIconListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol RoutineEmojiIconInteractorDependency{
    var emojiSubject: CurrentValuePublisher<String>{ get }
    var routineRepository: RoutineRepository { get }
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
                
        self.dependency.emojiSubject.send(emojis[0])
        self.presenter.setEmojis(emojis)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func emojiButtonDidTap(emoji: String) {
        dependency.emojiSubject.send(emoji)
    }
}
