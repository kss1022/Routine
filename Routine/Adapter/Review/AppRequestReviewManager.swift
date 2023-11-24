//
//  AppRequestReviewManager.swift
//  Routine
//
//  Created by 한현규 on 11/22/23.
//

import Foundation
import UIKit
import StoreKit

final class AppRequestReviewManager{
    
    
    private let requestProcessCount: Int = 10
    
    func requestReview(){
        
        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let dictionary = Bundle.main.infoDictionary,
              let currentBuildVersion = dictionary["CFBundleVersion"] as? String else { return }
        
        let lastVersionPromptedForReview = PreferenceStorage.shared.lastVersionPromptedForReview
        
        var count = PreferenceStorage.shared.processCompletedCountForReview
        count += 1
        PreferenceStorage.shared.processCompletedCountForReview = count
        
        
        if currentBuildVersion != lastVersionPromptedForReview && count < requestProcessCount{
            Task { @MainActor in
                // Delay for two seconds to avoid interrupting the person using the app.
                // Use the equation n * 10^9 to convert seconds to nanoseconds.
                try? await Task.sleep(nanoseconds: UInt64(2e9))
                SKStoreReviewController.requestReview(in: scene)
                
                PreferenceStorage.shared.processCompletedCountForReview = 0
                PreferenceStorage.shared.lastVersionPromptedForReview = currentBuildVersion
            }
        }
    }
    
    
    func openAppStoreReview(appStoreAppID : String) {    
        guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id\(appStoreAppID)?action=write-review") //
        else { fatalError("Expected a valid URL") }
        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
    }
    
}



fileprivate extension PreferenceKeys{
    var lastVersionPromptedForReview: PrefKey<String>{ .init(name: "kLastVersionPromptedForReview", defaultValue: "1")}
    var processCompletedCountForReview: PrefKey<Int>{ .init(name: "kProcessCompletedCountForReview", defaultValue: 0) }
}
