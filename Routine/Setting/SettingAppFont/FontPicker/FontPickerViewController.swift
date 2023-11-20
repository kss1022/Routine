//
//  FontPickerViewController.swift
//  Routine
//
//  Created by 한현규 on 11/17/23.
//

import ModernRIBs
import UIKit

protocol FontPickerPresentableListener: AnyObject {
    func didPickFont(familyName: String)
    func didTapCancel()
}

final class FontPickerViewController: UIFontPickerViewController, FontPickerPresentable, FontPickerViewControllable {

    weak var listener: FontPickerPresentableListener?
    
    
    init(){
        let config = UIFontPickerViewController.Configuration()

        config.displayUsingSystemFont = false
        config.includeFaces = false
        //fontPickerConfig.filteredLanguagesPredicate = UIFontPickerViewController.Configuration.filterPredicate(forFilteredLanguages: ["ja"])
        super.init(configuration: config)
                
        setLayout()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        title = "Choose Your Font"
        self.delegate = self
    }
        
    
}


extension FontPickerViewController: UIFontPickerViewControllerDelegate {
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        guard let descriptor = viewController.selectedFontDescriptor else { return }
        
        if let familyName = descriptor.fontAttributes[.family] as? String{
            listener?.didPickFont(familyName: familyName)
        }
    }
    
    func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
        listener?.didTapCancel()
    }
    
    
}

