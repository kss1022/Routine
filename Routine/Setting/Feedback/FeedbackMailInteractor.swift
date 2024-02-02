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

    // in constructor.
    override init(presenter: FeedbackMailPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        let appInfoMananger = AppInfoManager.shared
        let appName = appInfoMananger.appName()
        let version = appInfoMananger.version()
        let buildVersion = appInfoMananger.buildVersion()
        
        let deviceInfo = appInfoMananger.iOSVersion
        let iphoneModel = appInfoMananger.iPhoneModel
        
        let title = "feedback_title".localized(tableName: "Profile")
        let message = "feedback_message".localized(tableName: "Profile")
        
        presenter.setMailCompose(
            recipients: ["kss1022hhh@gmail.com"],
            subject: title,
            body:
"""
\(message)





---
\(appName) \(version)   (\(buildVersion))
\(iphoneModel)   (\(deviceInfo))
"""
        )
        
        
    }

    override func willResignActive() {
        super.willResignActive()
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
