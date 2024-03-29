//
//  SUI_TimerEditCountdownView.swift
//  Routine
//
//  Created by 한현규 on 10/31/23.
//

import SwiftUI

 struct SUI_TimerEditCountdownView: View {
    
    @EnvironmentObject var time : SUI_TimerEditCountdownLabelViewModel
            
    var body: some View {
        ZStack{            
            HStack(alignment: .center, spacing: 8.0){
                Text(String(format: "%02d", time.hour))
                    .frame(width: 80.0)
                    .font(.custom(UIFont.appBoldFontName, size: 50.0))  //.font(.system(size: 50.0))
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(":")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.custom(UIFont.appBoldFontName, size: 50.0))  //.font(.system(size: 50.0))
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(String(format: "%02d", time.minute))
                    .frame(width: 80.0)
                    .font(.custom(UIFont.appBoldFontName, size: 50.0))
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
            }
        }
        
    }
}

#Preview {
    SUI_TimerEditCountdownView()
        .environmentObject(SUI_TimerEditCountdownLabelViewModel())
}
