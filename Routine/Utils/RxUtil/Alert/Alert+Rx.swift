//
//  Alert+Rx.swift
//  WelcomeKorea
//
//  Created by 한현규 on 2023/04/17.
//

//import Foundation
//import RxCocoa
//import RxSwift
//import UIKit.UIViewController
//
//
//
//public extension Reactive where Base: UIViewController {
//    func alert(title: String?,
//               message: String?,
//               actions: [AlertAction],
//               preferredStyle: UIAlertController.Style = .alert,
//               tintColor: UIColor? = nil,
//               animated: Bool = true,
//               completion: (() -> Void)? = nil
//    ) -> Observable<OutputAction>
//    {
//        Observable.create { observer in
//            let alertController = UIAlertController(title: title,
//                                                    message: message,
//                                                    preferredStyle: preferredStyle)
//            alertController.view.tintColor = tintColor
//            alertController.setStyle()  // Set My Custom Style
//            actions.forEach { [weak alertController] action in
//                if let textField = action.textField {
//                    alertController?.addTextField { text in
//                        text.config(textField)
//                    }
//                } else {
//                    let action = UIAlertAction(title: action.title, style: action.style, handler: {[weak alertController] alertAction in
//                        observer.on(.next(
//                            OutputAction(
//                                index: action.type,
//                                textFields: alertController?.textFields,
//                                alertAction: alertAction))
//                        )
//                        observer.on(.completed)
//                    })
//                    alertController?.addAction(action)
//                }
//            }
//            base.present(alertController, animated: animated, completion: completion)
//            return Disposables.create()
//        }
//    }
//}
//
//
//extension PublishRelay<Alert>{
//    func asAlert(viewController : UIViewController) -> Observable<OutputAction>{
//        self.withUnretained(viewController)
//            .flatMapLatest { (owner , alert) in
//                owner.asAlert(alert: alert)
//            }
//    }
//
//    
//    
//    func asAlertSignal(viewController : UIViewController) -> Signal<OutputAction>{
//        self.asAlert(viewController: viewController)
//            .asSignal(onErrorSignalWith: .empty())
//    }
//}
//
//extension UIViewController{
//    func asAlert( alert : Alert) -> Observable<OutputAction> {
//        let alertController = UIAlertController( title: alert.title, message: alert.message, preferredStyle: alert.style )
//        return presentAlertController(alertController, actions: alert.actions)
//    }
//    
//    
//    
//    fileprivate func presentAlertController(_ alertController: UIAlertController, actions: [AlertAction]) -> Observable<OutputAction> {
//        if actions.isEmpty { return .empty() }
//        return Observable
//            .create { [unowned self] observer in
//                alertController.setStyle()  // Set My Custom Style
//
//                actions.forEach { action  in
//                    let alertAction =  UIAlertAction(
//                        title: action.title,
//                        style: action.style,
//                        handler: { alertAction in
//                            observer.onNext(
//                                OutputAction(
//                                    index: action.type,
//                                    textFields: nil,
//                                    alertAction: alertAction)
//                            )
//                            observer.onCompleted()
//                        }
//                    )
//                    alertController.addAction(alertAction)
//                }
//                
//                
//                self.present(alertController, animated: true, completion: nil)
//                return Disposables.create {
//                    alertController.dismiss(animated: true, completion: nil)
//                }
//            }
//    }
//
//}
//
//
//
//private extension UIAlertController{
//    func setStyle(){
//        
//        setTitle(font: UIFont.getBoldFont(style: .callout), color: .label)
//        setMessage(font: UIFont.getFont(style: .caption2), color: .secondaryLabel)
//        //setBackground(color: .alertColor)
//    }
//}
//
//private extension UIAlertAction{
//    func setTitleTextColor( color : UIColor){
//        setValue(color, forKey: "titleTextColor")
//    }
//}
//
//
//// MARK: - UITextField
//private extension UITextField {
//    func config(_ textField: UITextField) {
//        text = textField.text
//        placeholder = textField.placeholder
//        tag = textField.tag
//        isSecureTextEntry = textField.isSecureTextEntry
//        tintColor = textField.tintColor
//        textColor = textField.textColor
//        textAlignment = textField.textAlignment
//        borderStyle = textField.borderStyle
//        leftView = textField.leftView
//        leftViewMode = textField.leftViewMode
//        rightView = textField.rightView
//        rightViewMode = textField.rightViewMode
//        background = textField.background
//        disabledBackground = textField.disabledBackground
//        clearButtonMode = textField.clearButtonMode
//        inputView = textField.inputView
//        inputAccessoryView = textField.inputAccessoryView
//        clearsOnInsertion = textField.clearsOnInsertion
//        keyboardType = textField.keyboardType
//        returnKeyType = textField.returnKeyType
//        spellCheckingType = textField.spellCheckingType
//        autocapitalizationType = textField.autocapitalizationType
//        autocorrectionType = textField.autocorrectionType
//        keyboardAppearance = textField.keyboardAppearance
//        enablesReturnKeyAutomatically = textField.enablesReturnKeyAutomatically
//        delegate = textField.delegate
//        clearsOnBeginEditing = textField.clearsOnBeginEditing
//        adjustsFontSizeToFitWidth = textField.adjustsFontSizeToFitWidth
//        minimumFontSize = textField.minimumFontSize
//
//        if #available(iOS 11.0, *) {
//            self.textContentType = textField.textContentType
//        }
//
//        if #available(iOS 11.0, *) {
//            self.smartQuotesType = textField.smartQuotesType
//            self.smartDashesType = textField.smartDashesType
//            self.smartInsertDeleteType = textField.smartInsertDeleteType
//        }
//
//        if #available(iOS 12.0, *) {
//            self.passwordRules = textField.passwordRules
//        }
//    }
//}
