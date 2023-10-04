//
//  AddYourRoutineInteractor.swift
//  Routine
//
//  Created by 한현규 on 2023/09/26.
//

import Foundation
import ModernRIBs
import Combine

protocol AddYourRoutineRouting: ViewableRouting {
    func attachRoutineTitle()
    func attachRoutineTint()
    func attachRoutineEmojiIcon()
}

protocol AddYourRoutinePresentable: Presentable {
    var listener: AddYourRoutinePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func setTint(_ color: String)
}

protocol AddYourRoutineListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

protocol AddYourRoutineInteractorDependency{
    var routineApplicationService: RoutineApplicationService{ get }

    var title: ReadOnlyCurrentValuePublisher<String>{ get }
    var description: ReadOnlyCurrentValuePublisher<String>{ get }
    var tint: ReadOnlyCurrentValuePublisher<String>{ get }
    var emoji: ReadOnlyCurrentValuePublisher<String>{ get }
}

final class AddYourRoutineInteractor: PresentableInteractor<AddYourRoutinePresentable>, AddYourRoutineInteractable, AddYourRoutinePresentableListener {

    weak var router: AddYourRoutineRouting?
    weak var listener: AddYourRoutineListener?

    private var cancellables: Set<AnyCancellable>
    private let dependendency: AddYourRoutineInteractorDependency
    
    // in constructor.
    init(
        presenter: AddYourRoutinePresentable,
        dependency: AddYourRoutineInteractorDependency
    ) {
        self.cancellables = .init()
        self.dependendency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachRoutineTitle()
        router?.attachRoutineTint()
        router?.attachRoutineEmojiIcon()
        
        
        dependendency.tint
            .receive(on: DispatchQueue.main)
            .sink {  tint in
                self.presenter.setTint(tint)
            }
            .store(in: &cancellables)
    }

    override func willResignActive() {
        super.willResignActive()
        
        
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func nextBarButtonDidTap() {
        let createRoutine = CreateRoutine(
            name: dependendency.title.value,
            description: dependendency.description.value,
            icon: dependendency.emoji.value,
            tint: dependendency.tint.value,
            createCheckLists: []
        )
        
 
        Task{ [weak self] in
            guard let self = self else { return
            }
            do{
                try await self.dependendency.routineApplicationService.when(createRoutine)
            }catch{
                if let error = error as? ArgumentException{
                    Log.e(error.msg)
                }else{
                    Log.e("UnkownError\n\(error)" )
                }
            }
        }
    }
}
