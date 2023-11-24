//
//  ProfileEditMemojiInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/24/23.
//

import Foundation
import ModernRIBs
import Combine

protocol ProfileEditMemojiRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ProfileEditMemojiPresentable: Presentable {
    var listener: ProfileEditMemojiPresentableListener? { get set }
    
    func setName(name: String)
    func setDescription(description: String)
    func setStyle(gardient: ProfileStyleViewModel)
    func setMemoji(memoji: String)
    func setEmoji(emoji: String)
    func setText(title: String)
    
    func setStyleLists(_ viewModels: [ProfileStyleViewModel])
    
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
    
    func profileEditTitleSetEmoji(emoji: String)
    func profileEditTitleSetText(text: String)
    func profileEditTitleSetSyle(style: ProfileStyleModel)
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
    
    private var styleModels: [ProfileStyleModel]
    
    // in constructor.
    init(
        presenter: ProfileEditMemojiPresentable,
        dependency: ProfileEditMemojiInteractorDependency
    ) {
        self.dependency = dependency
        self.cancellables = .init()
        self.styleModels = []
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
        
        let gradientModels = [
           ProfileStyleModel(topColor: "#A8ADBAFF", bottomColor: "#878C96FF"),  //1
           ProfileStyleModel(topColor: "#D5CCF7FF", bottomColor: "#B5A4F2FF"),  //2
           ProfileStyleModel(topColor: "#B3D5F0FF", bottomColor: "#76B3E2FF"),  //3
           ProfileStyleModel(topColor: "#F5B7CCFF", bottomColor: "#EE7EA2FF"),  //4
           ProfileStyleModel(topColor: "#F5DAAFFF", bottomColor: "#EDB96EFF"),  //5
           ProfileStyleModel(topColor: "#CAF2BDFF", bottomColor: "#A0E787FF"),  //6
           ProfileStyleModel(topColor: "#E2C6C3FF", bottomColor: "#C89792FF"),  //7
           ProfileStyleModel(topColor: "#F0C1A5FF", bottomColor: "#E49165FF"),  //8
           ProfileStyleModel(topColor: "#D6CDDEFF", bottomColor: "#B4A5C2FF"),  //9
           ProfileStyleModel(topColor: "#C7D7E7FF", bottomColor: "#9DB8D5FF"),  //10
           ProfileStyleModel(topColor: "#D0E8EAFF", bottomColor: "#A9D5D8FF"),  //11
           ProfileStyleModel(topColor: "#EEB3EDFF", bottomColor: "#E27DDDFF"),  //12
           ProfileStyleModel(topColor: "#AAF0F2FF", bottomColor: "#67E4E8FF"),  //13
           ProfileStyleModel(topColor: "#B0F4C3FF", bottomColor: "#70EB91FF"),  //14
           ProfileStyleModel(topColor: "#D9D4D0FF", bottomColor: "#B9B0A7FF"),  //15
           ProfileStyleModel(topColor: "#E6D6BFFF", bottomColor: "#D1B48AFF"),  //16
           ProfileStyleModel(topColor: "#D5DDD0FF", bottomColor: "#B0C2AAFF"),  //17
           ProfileStyleModel(topColor: "#8E8E8EFF", bottomColor: "#333333FF")   //18
        ]
        self.styleModels = gradientModels
        
        presenter.setStyleLists(gradientModels.map(ProfileStyleViewModel.init))
        
        if let profile = dependency.profile{
            presenter.setStyle(gardient: ProfileStyleViewModel(profile.profileStyle))
            switch profile.profileImage.profileType{
            case .memoji: presenter.setMemoji(memoji: profile.profileImage.profileValue)
            case .emoji: presenter.setEmoji(emoji: profile.profileImage.profileValue)
            case .text: presenter.setText(title: profile.profileImage.profileValue)
            }
        }
            
        
    }

    override func willResignActive() {
        super.willResignActive()
        
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
    
    
    func didSelectItemAt(row: Int) {
        if let gradients = self.styleModels[safe: row]{
            presenter.setStyle(gardient: ProfileStyleViewModel(gradients))
            listener?.profileEditTitleSetSyle(style: gradients)
        }
    }
    
    
    func setEmoji(emoji: String) {
        listener?.profileEditTitleSetEmoji(emoji: emoji)
    }
    
    func setText(text: String) {
        listener?.profileEditTitleSetText(text: text)
    }
    

    
    //MARK: Listener
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
