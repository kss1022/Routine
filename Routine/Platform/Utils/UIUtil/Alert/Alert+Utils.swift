//
//  Alert+Utils.swift
//  Routine
//
//  Created by 한현규 on 1/9/24.
//


import UIKit


extension UIViewController{
    
    func showAlert(title: String, message: String, actions: [AlertAction] = [], completeHandler: ((OutputAction) -> ())? = nil){
        let alert = Alert(title: title, message: message, actions: actions)
        let alertController = UIAlertController( title: alert.title, message: alert.message, preferredStyle: alert.style )
        presentAlertViewController(alertController, actions: alert.actions, completeHandler: completeHandler)
    }
    
    private func presentAlertViewController(_ alertController: UIAlertController, actions: [AlertAction], completeHandler: ((OutputAction) -> ())?){
        
        alertController.setStyle()
        
        actions.forEach { action in
            if let textField = action.textField {
                alertController.addTextField { text in
                    text.config(textField)
                }
            }else{
                
                let alertAction =  UIAlertAction(
                    title: action.title,
                    style: action.style,
                    handler: { alertAction in
                        let ouputAction = OutputAction(
                            index: action.type,
                            textFields: alertController.textFields,
                            alertAction: alertAction
                        )
                        
                        completeHandler?(ouputAction)
                    }
                )
                
                alertController.addAction(alertAction)
            }
        }
                        
        self.present(alertController, animated: true, completion: nil)
    }
    
}



private extension UIAlertController {
    
    // Set title font and title color
    func setTitle(font: UIFont?, color: UIColor?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)
        
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font: titleFont],
                                          range: NSRange(location: 0, length: title.count))
        }
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor: titleColor],
                                          range: NSRange(location: 0, length: title.count))
        }
        self.setValue(attributeString, forKey: "attributedTitle")
        
    }

    // Set message font and message color
    func setMessage(font: UIFont?, color: UIColor?) {
        guard let message = self.message else { return }
        
        let attributeString = NSMutableAttributedString(string: message)
        if let messageFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font: messageFont],
                                          range: NSRange(location: 0, length: message.count))
        }
        
        if let messageColorColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor: messageColorColor],
                                          range: NSRange(location: 0, length: message.count))
            
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }
        
        
    // Set tint color of UIAlertController
    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
    
    func setBackground(color : UIColor){
        self.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = color
    }
}


private extension UIAlertController{
    func setStyle(){
        setTitle(font: .preferredFont(forTextStyle: .callout), color: .label)
        setMessage(font: .preferredFont(forTextStyle: .caption2), color: .secondaryLabel)
    }
}

private extension UIAlertAction{
    func setTitleTextColor( color : UIColor){
        setValue(color, forKey: "titleTextColor")
    }
}


// MARK: - UITextField
private extension UITextField {
    func config(_ textField: UITextField) {
        text = textField.text
        placeholder = textField.placeholder
        tag = textField.tag
        isSecureTextEntry = textField.isSecureTextEntry
        tintColor = textField.tintColor
        textColor = textField.textColor
        textAlignment = textField.textAlignment
        borderStyle = textField.borderStyle
        leftView = textField.leftView
        leftViewMode = textField.leftViewMode
        rightView = textField.rightView
        rightViewMode = textField.rightViewMode
        background = textField.background
        disabledBackground = textField.disabledBackground
        clearButtonMode = textField.clearButtonMode
        inputView = textField.inputView
        inputAccessoryView = textField.inputAccessoryView
        clearsOnInsertion = textField.clearsOnInsertion
        keyboardType = textField.keyboardType
        returnKeyType = textField.returnKeyType
        spellCheckingType = textField.spellCheckingType
        autocapitalizationType = textField.autocapitalizationType
        autocorrectionType = textField.autocorrectionType
        keyboardAppearance = textField.keyboardAppearance
        enablesReturnKeyAutomatically = textField.enablesReturnKeyAutomatically
        delegate = textField.delegate
        clearsOnBeginEditing = textField.clearsOnBeginEditing
        adjustsFontSizeToFitWidth = textField.adjustsFontSizeToFitWidth
        minimumFontSize = textField.minimumFontSize

        if #available(iOS 11.0, *) {
            self.textContentType = textField.textContentType
        }

        if #available(iOS 11.0, *) {
            self.smartQuotesType = textField.smartQuotesType
            self.smartDashesType = textField.smartDashesType
            self.smartInsertDeleteType = textField.smartInsertDeleteType
        }

        if #available(iOS 12.0, *) {
            self.passwordRules = textField.passwordRules
        }
    }
}
