//
//  ProfileCardInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/14/23.
//

import Foundation
import ModernRIBs
import Combine

protocol ProfileCardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProfileCardPresentable: Presentable {
    var listener: ProfileCardPresentableListener? { get set }
    func setProfileCard(_ viewModel: ProfileCardViewModel)        
}

protocol ProfileCardListener: AnyObject {
    func profileCardProfileMemojiViewDidTap()
}

protocol ProfileCardInteractorDependency{
    var profile: ReadOnlyCurrentValuePublisher<ProfileModel?>{ get }
}

final class ProfileCardInteractor: PresentableInteractor<ProfileCardPresentable>, ProfileCardInteractable, ProfileCardPresentableListener {

    weak var router: ProfileCardRouting?
    weak var listener: ProfileCardListener?

    private let dependencty: ProfileCardInteractorDependency
    private var cancellables: Set<AnyCancellable>
    
    
    // in constructor.
    init(
        presenter: ProfileCardPresentable,
        dependency: ProfileCardInteractorDependency
    ) {
        self.dependencty = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
                        
        dependencty.profile
            .compactMap{ $0 }
            .receive(on: DispatchQueue.main)
            .sink { model in
                let viewModel = ProfileCardViewModel(model)
                self.presenter.setProfileCard(viewModel)                
            }
            .store(in: &cancellables)                
    }

    override func willResignActive() {
        super.willResignActive()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    func memojiButtonDidTap() {
        self.listener?.profileCardProfileMemojiViewDidTap()
    }
}
