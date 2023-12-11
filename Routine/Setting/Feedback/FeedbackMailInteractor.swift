//
//  FeedbackMailInteractor.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import Foundation
import ModernRIBs
import UIKit

protocol FeedbackMailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol FeedbackMailPresentable: Presentable {
    var listener: FeedbackMailPresentableListener? { get set }
    func setMailCompose(recipients: [String], subject: String, body: String)
}

protocol FeedbackMailListener: AnyObject {
    func feedbackMailDidFinishWithCancel()
    func feedbackMailDidFinishWithSaved()
    func feedbackMailDidFinishWithSent()
    func feedbackMailDidFinishWithFail()
}

final class FeedbackMailInteractor: PresentableInteractor<FeedbackMailPresentable>, FeedbackMailInteractable, FeedbackMailPresentableListener {

    weak var router: FeedbackMailRouting?
    weak var listener: FeedbackMailListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: FeedbackMailPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        let appInfoMananger = AppInfoManager.shared
        let appName = appInfoMananger.appName()
        let version = appInfoMananger.version()
        let buildVersion = appInfoMananger.buildVersion()
        
        let deviceInfo = appInfoMananger.iOSVersion
        let iphoneModel = appInfoMananger.iPhoneModel
        
        presenter.setMailCompose(
            recipients: ["kss1022hhh@gmail.com"],
            subject: "Hello Routine",
            body:
"""
Any feedback or bug reports are welcome :)





---
\(appName) \(version)   (\(buildVersion))
\(iphoneModel)   (\(deviceInfo))
"""
        )
        
        
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didFinishWithCancel() {
        listener?.feedbackMailDidFinishWithCancel()
    }
    
    func didFinishWithSaved() {
        listener?.feedbackMailDidFinishWithSaved()
    }
    
    func didFinishWithSent() {
        listener?.feedbackMailDidFinishWithSent()
    }
    
    func didFinishWithFail() {
        listener?.feedbackMailDidFinishWithCancel()
    }
    

    
    
}
