//
//  PaddingTextFeild.swift
//  Routine
//
//  Created by 한현규 on 10/19/23.
//

import UIKit


final class PaddingTextFeild : UITextField{
    
    var padding : UIEdgeInsets

    
    var paddingTop : CGFloat{
        didSet{ padding.top = paddingTop }
    }
    
    var paddingBottom : CGFloat{
        didSet{ padding.bottom = paddingBottom }
    }
    
    var paddingLeft : CGFloat{
        didSet{ padding.left = paddingLeft }
    }
    
    var paddingRight : CGFloat{
        didSet{ padding.right = paddingRight }
    }
    
    
    init(
        inset : UIEdgeInsets
    ){
        paddingTop = inset.top
        paddingLeft = inset.left
        paddingRight = inset.right
        paddingBottom = inset.bottom
        
        padding = UIEdgeInsets(
            top: paddingTop,
            left: paddingLeft,
            bottom: paddingBottom,
            right: paddingRight
        )
        
        super.init(frame: .zero)
    }
    
    
    init(
        paddingTop: CGFloat = 0.0,
        paddingBottom: CGFloat = 0.0,
        paddingLeft: CGFloat = 0.0,
        paddingRight: CGFloat = 0.0
    ) {
        self.paddingTop = paddingTop
        self.paddingBottom = paddingBottom
        self.paddingLeft = paddingLeft
        self.paddingRight = paddingRight
        
        padding = UIEdgeInsets(
            top: paddingTop,
            left: paddingLeft,
            bottom: paddingBottom,
            right: paddingRight
        )
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
            


    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: padding)
    }
    
}
