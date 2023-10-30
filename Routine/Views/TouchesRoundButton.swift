//
//  TouchesRoundButton.swift
//  Routine
//
//  Created by 한현규 on 10/25/23.
//

import UIKit




final class TouchesRoundButton : TouchesButton{
    
    
    init(){
        super.init(frame: .zero)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    private func setView(){
        self.setTitleColor(.white, for: .normal)
        
        self.contentEdgeInsets = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners(self.frame.height / 2)
    }
}

