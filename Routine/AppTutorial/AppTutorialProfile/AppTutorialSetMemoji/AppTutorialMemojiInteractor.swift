//
//  AppTutorialMemojiInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/28/23.
//

import Foundation
import ModernRIBs
import Combine

protocol AppTutorialMemojiRouting: ViewableRouting {
}

protocol AppTutorialMemojiPresentable: Presentable {
    var listener: AppTutorialMemojiPresentableListener? { get set }

    func setType(type: MemojiType)
    func setStyle(style: MemojiStyle)
    
    func showMemojiLists()
    func hideMemojiLists()
    
    func showStyleLists()
    func hideStyleLists()
    
    func setMemojiSegment()
    func setStyleSegment()
}

protocol AppTutorialMemojiListener: AnyObject {
    func appTutorialMemojiCloseButtonDidTap()    
}

protocol AppTutorialMemojiInteractorDependency{
    var memojiTypeSubject: CurrentValuePublisher<MemojiType>{ get }
    var memojiStyleSubject: CurrentValuePublisher<MemojiStyle>{ get }
}

final class AppTutorialMemojiInteractor: PresentableInteractor<AppTutorialMemojiPresentable>, AppTutorialMemojiInteractable, AppTutorialMemojiPresentableListener {

      
    weak var router: AppTutorialMemojiRouting?
    weak var listener: AppTutorialMemojiListener?
    

    private let dependency: AppTutorialMemojiInteractorDependency
    
    
    // in constructor.
    init(
        presenter: AppTutorialMemojiPresentable,
        dependency: AppTutorialMemojiInteractorDependency
    ) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        let type = dependency.memojiTypeSubject.value
        let stype = dependency.memojiStyleSubject.value

        presenter.setType(type: type)
        presenter.setStyle(style: stype)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    
    
    func closeButtonDidTap() {
        listener?.appTutorialMemojiCloseButtonDidTap()
    }


    func didSetType(type: MemojiType) {
        presenter.setType(type: type)
        dependency.memojiTypeSubject.send(type)
    }
    
    func didSetStyle(style: MemojiStyle) {
        presenter.setStyle(style: style)
        dependency.memojiStyleSubject.send(style)
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
