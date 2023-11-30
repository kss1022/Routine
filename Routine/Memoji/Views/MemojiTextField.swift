//
//  MemojiTextField.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation
import UIKit




 protocol MemojiTextFieldDelegate: AnyObject {
     func didUpdateEmoji(emoji: UIImage?, type: MemojiType)
     func didBeginEditing()
}

class MemojiTextField: UITextView {
    private let memojiPasteboard = UIPasteboard(name: UIPasteboard.Name(rawValue: "memojiPasteboard"), create: true)
    
    internal weak var emojiDelegate: MemojiTextFieldDelegate?

    //TODO: Opening the emoji keyboard causes some warning.
    
    
    /// Opens the keyboard with the emoji field
    override var textInputMode: UITextInputMode? {
       UITextInputMode.activeInputModes.first(where: { $0.primaryLanguage == "emoji" })
    }
    /// required for iOS 13. Return a non-nil to show the Emoji keyboard
    override var textInputContextIdentifier: String? { "" }
    /// The maximum number of letter allowed for text
    public var maxLetters: Int = 2
    
    
    init(){
        super.init(frame: .zero, textContainer: nil)
        
        setView()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setView()
    }
    
    //MARK: Functions
    private func setView() {
        self.backgroundColor = .clear
        self.tintColor = .clear
        self.textColor = .clear
        self.textAlignment = .center
        
        self.autocorrectionType = .no
        self.returnKeyType = .done
        //self.autocapitalizationType = .allCharacters
        /// Enabled Memojis for the keyboard
        self.allowsEditingTextAttributes = true
        
        
        self.delegate = self
    }
       
    /// Will be called once an memoji has been selected. Which results in paste
    override func paste(_ sender: Any?) {
        super.paste(sender)
        if let image = UIPasteboard.general.image {
            memojiPasteboard?.image = image
            self.text = ""
        }
    }
    
    /// Disables context menu options like: Copy, paste and search
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }
}

//MARK: - UITextFieldDelegate
extension MemojiTextField: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
      if text == "" {
            emojiDelegate?.didUpdateEmoji(emoji: UIImage(), type: .text(""))
        }
     
        if text.isSingleEmoji {
            guard textView.text == text else {
                textView.text = ""
                return true
            }
            return false
        }
        
        if textView.text.isSingleEmoji {
            textView.text = ""
        }
        
        return textView.text.utf16.count + text.utf16.count <= maxLetters
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = String()
        emojiDelegate?.didBeginEditing()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = String()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard var text = textView.text, !text.isEmpty else {return}
        if let image = memojiPasteboard?.image {
            emojiDelegate?.didUpdateEmoji(emoji: image, type: .memoji(image: image))
            memojiPasteboard?.image = nil
            textView.text = ""
            return
        }

        
        if text.count == 1 && !text.isSingleEmoji {
            text = "\(text) " //add padding for single letter otherwise it does not fit properly and looks weird
        }
        textView.textColor = .clear
        
        let image = text.toImage()
        emojiDelegate?.didUpdateEmoji(emoji: image, type: text.isSingleEmoji ? .emoji(text) : .text(text))
    }
}
