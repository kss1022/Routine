//
//  AlertAction.swift
//  Routine
//
//  Created by 한현규 on 1/9/24.
//

import UIKit


public struct AlertAction {
    public let title: String
    public let type: Int
    public let textField: UITextField?
    public let style: UIAlertAction.Style

    public init(title: String = "",
                type: Int = 0,
                textField: UITextField? = nil,
                placeholder: String? = nil,
                style: UIAlertAction.Style = .default)
    {
        self.title = title
        self.type = type
        self.textField = textField
        if self.textField != nil,
           placeholder != nil
        {
            self.textField?.placeholder = placeholder
        }
        self.style = style
    }
}
