//
//  DynamicTableView.swift
//  Routine
//
//  Created by 한현규 on 2/2/24.
//

import UIKit



class DynamicTablewView : UITableView{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
