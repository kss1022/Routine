//
//  DynamicCollectionView.swift
//  Routine
//
//  Created by 한현규 on 12/7/23.
//

import UIKit



class DynamicCollectionView : UICollectionView{
    
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
