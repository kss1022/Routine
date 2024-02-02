//
//  ProfileEditMemojiInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import Foundation
import ModernRIBs
import Combine
import UIKit.UIImage

protocol ProfileEditMemojiRouting: ViewableRouting {
}

protocol ProfileEditMemojiPresentable: Presentable {
    var listener: ProfileEditMemojiPresentableListener? { get set }
    
    func setName(name: String)
    func setDescription(description: String)
    
    func setType(type: MemojiType)
    func setStyle(style: MemojiStyle)
    
    
    func showMemojiLists()
    func hideMemojiLists()
    
    func showStyleLists()
    func hideStyleLists()
    
    func setMemojiSegment()
    func setStyleSegment()
}

protocol ProfileEditMemojiListener: AnyObject {
    func profileEditMemojiNameButtonDidTap()
    func profileEditMemojiDescriptionButtonDidTap()

    func profileEditMemojiDidSetType(type: MemojiType)
    func profileEditMemojiDidSetStyle(style: MemojiStyle)
}

protocol ProfileEditMemojiInteractorDependency{
    var profile: ProfileModel?{ get }
    var profileName: ReadOnlyCurrentValuePublisher<String>{ get }
    var profileDescription: ReadOnlyCurrentValuePublisher<String>{ get }
}


final class ProfileEditMemojiInteractor: PresentableInteractor<ProfileEditMemojiPresentable>, ProfileEditMemojiInteractable, ProfileEditMemojiPresentableListener {

    weak var router: ProfileEditMemojiRouting?
    weak var listener: ProfileEditMemojiListener?

    private let dependency: ProfileEditMemojiInteractorDependency
    private var cancellables: Set<AnyCancellable>
        
    // in constructor.
    init(
        presenter: ProfileEditMemojiPresentable,
        dependency: ProfileEditMemojiInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
                
        
        dependency.profileName
            .receive(on: DispatchQueue.main)
            .sink {
                self.presenter.setName(name: $0)
            }
            .store(in: &cancellables)
        
        dependency.profileDescription
            .receive(on: DispatchQueue.main)
            .sink {
                self.presenter.setDescription(description: $0)
            }
            .store(in: &cancellables)
        
        
        if let profile = dependency.profile{
                        
            presenter.setType(type: MemojiType(profile.profileImage))
            presenter.setStyle(style: MemojiStyle(topColor: profile.topColor, bottomColor: profile.bottomColor))
        }
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    //MARK: Listener

    func didSetType(type: MemojiType) {
        presenter.setType(type: type)
        listener?.profileEditMemojiDidSetType(type: type)
    }
    
    func didSetStyle(style: MemojiStyle) {
        presenter.setStyle(style: style)
        listener?.profileEditMemojiDidSetStyle(style: style)
    }
        

    func nameButtonDidTap() {
        listener?.profileEditMemojiNameButtonDidTap()
    }
    
    func descriptoinButtonDidTap() {
        listener?.profileEditMemojiDescriptionButtonDidTap()
    }
    
    func segementControlValueChanged(index: Int) {
        switch index{
        case 0:            
            presenter.hideStyleLists()
            presenter.showMemojiLists()
        case 1:
            presenter.hideMemojiLists()
            presenter.showStyleLists()
        default: fatalError("Invalid Segment Index")
        }
    }
    
    
    func memojiViewDidFocused() {
        presenter.hideStyleLists()
        presenter.setMemojiSegment()
    }
}


private extension MemojiType{
    init(_ model: ProfileImageModel) {
        switch model {
        case .memoji(let memoji): self = .memoji(image: UIImage(fileName: memoji))
        case .emoji(let emoji): self = .emoji(emoji)
        case .text(let text): self = .text(text)
        }
    }
}
