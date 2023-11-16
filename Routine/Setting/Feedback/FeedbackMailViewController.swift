//
//  FeedbackMailViewController.swift
//  Routine
//
//  Created by 한현규 on 11/15/23.
//

import ModernRIBs
import UIKit
import MessageUI


protocol FeedbackMailPresentableListener: AnyObject {
    func didFinishWithCancel()
    func didFinishWithSaved()
    func didFinishWithSent()
    func didFinishWithFail()
}

final class FeedbackMailViewController: MFMailComposeViewController, FeedbackMailPresentable, FeedbackMailViewControllable {

    weak var listener: FeedbackMailPresentableListener?
    
    init(){
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setLayout()
    }
    
    
    private func setLayout(){
        self.mailComposeDelegate = self
    }
    
    
    func setMailCompose(recipients: [String], subject: String, body: String) {
        setToRecipients(recipients)
        setSubject(subject)
        setMessageBody(body, isHTML: false)
    }
}


extension FeedbackMailViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            listener?.didFinishWithCancel()
        case .saved:
            listener?.didFinishWithSaved()
        case .sent:
            listener?.didFinishWithSent()
        case .failed:
            listener?.didFinishWithFail()
        @unknown default: Log.e("UnkownDefulat Error")
        }
    }

    
    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        Log.v("Cancel")
    }

}
