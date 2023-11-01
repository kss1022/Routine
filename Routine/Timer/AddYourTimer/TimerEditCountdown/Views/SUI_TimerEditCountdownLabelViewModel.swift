//
//  SUI_TimerEditCountdownLabelViewModel.swift
//  Routine
//
//  Created by 한현규 on 11/1/23.
//

import Foundation



final class SUI_TimerEditCountdownLabelViewModel: ObservableObject {
    @Published var hour: Int
    @Published var minute: Int
    
    init() {
        self.hour = 0
        self.minute = 0
    }
}
