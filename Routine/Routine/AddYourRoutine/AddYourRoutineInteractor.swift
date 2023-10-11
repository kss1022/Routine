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
    func attachRoutineRepeat()
}

protocol AddYourRoutinePresentable: Presentable {
    var listener: AddYourRoutinePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    func setTint(_ color: String)
}

protocol AddYourRoutineListener: AnyObject {
    func addYourRoutineDoneButtonDidTap()
}

protocol AddYourRoutineInteractorDependency{
    var routineApplicationService: RoutineApplicationService{ get }
    var routineRepository: RoutineRepository{ get }

    var title: ReadOnlyCurrentValuePublisher<String>{ get }
    var description: ReadOnlyCurrentValuePublisher<String>{ get }
    var repeatType: ReadOnlyCurrentValuePublisher<RepeatTypeViewModel>{ get }
    var repeatValue: ReadOnlyCurrentValuePublisher<RepeatValueViewModel>{ get }
    var tint: ReadOnlyCurrentValuePublisher<String>{ get }
    var emoji: ReadOnlyCurrentValuePublisher<String>{ get }
}

final class AddYourRoutineInteractor: PresentableInteractor<AddYourRoutinePresentable>, AddYourRoutineInteractable, AddYourRoutinePresentableListener {

    weak var router: AddYourRoutineRouting?
    weak var listener: AddYourRoutineListener?

    private var cancellables: Set<AnyCancellable>
    private let dependency: AddYourRoutineInteractorDependency
    
    // in constructor.
    init(
        presenter: AddYourRoutinePresentable,
        dependency: AddYourRoutineInteractorDependency
    ) {
        self.cancellables = .init()
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachRoutineTitle()
        router?.attachRoutineRepeat()
        router?.attachRoutineTint()
        router?.attachRoutineEmojiIcon()        
        
        dependency.tint
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
    
    func doneBarButtonDidTap() {
        
        Log.v("\(dependency.repeatType.value)")
        
        
        
        let createRoutine = CreateRoutine(
            name: dependency.title.value,
            description: dependency.description.value,
            repeatType: dependency.repeatType.value.rawValue,
            repeatValue: dependency.repeatValue.value.rawValue(),
            emoji: dependency.emoji.value,
            tint: dependency.tint.value,
            createCheckLists: []
        )
         
        Task{ [weak self] in
            guard let self = self else { return
            }
            do{
                try await self.dependency.routineApplicationService.when(createRoutine)
                try await self.dependency.routineRepository.fetchLists()
                await MainActor.run{ self.listener?.addYourRoutineDoneButtonDidTap() }
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
