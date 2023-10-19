//
//  TimerListViewModel.swift
//  Routine
//
//  Created by 한현규 on 10/17/23.
//

import Foundation
import UIKit.UIColor



struct TimerListViewModel: Hashable{
    let timerId: UUID
    let name: String
    let description: String
    let emoji: String
    let tint: UIColor?
    let image: UIImage?
    
    init(_ model: TimerListModel) {
        self.timerId = model.timerId
        self.name = model.name
        self.description = model.description
        self.emoji = model.emoji
        self.tint = UIColor(hex: model.tint)
        
        switch model.status {
        case .initialized:
            self.image = UIImage(systemName: "arrowtriangle.right")
        case .start:
            self.image = UIImage(systemName: "pause")
        case .pause:
            self.image = UIImage(systemName: "arrowtriangle.right")
        case .end:
            self.image = UIImage(systemName: "xmark")
        }
        
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(timerId)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(emoji)
        hasher.combine(tint)
        hasher.combine(image)
    }
    
    static func ==(lsh: TimerListViewModel, rhs: TimerListViewModel){
        lsh.timerId == rhs.timerId && lsh.name == rhs.name &&
        lsh.description == rhs.description && lsh.emoji == rhs.emoji &&
        lsh.tint == rhs.tint && lsh.image == rhs.image
    }

}
