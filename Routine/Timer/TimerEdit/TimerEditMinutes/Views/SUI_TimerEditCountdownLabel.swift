//
//  SUI_TimerEditCountdownLabel.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import SwiftUI

struct SUI_TimerEditCountdownLabel: View {
    
    @EnvironmentObject var time : SUI_TimerEditCountdownLabelViewModel
    
    private let backgroundColor: Color = .black//Color(UIColor.label)
    private let textColor: Color = .white//Color(UIColor.systemBackground)
    
    var body: some View {
        ZStack{
//            backgroundColor
//                .edgesIgnoringSafeArea(.all)
            
            
            SUI_TimerEditCountdownView()
                .blur(radius: 15.0)
            
            SUI_TimerEditCountdownView()
        }
    }
    
}

#Preview {
    SUI_TimerEditCountdownLabel()
        .environmentObject(SUI_TimerEditCountdownLabelViewModel())
}



