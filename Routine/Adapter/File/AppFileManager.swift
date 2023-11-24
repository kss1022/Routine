//
//  AppFileManager.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation
import UIKit.UIImage



final class AppFileManager{
    
    private static let share = AppFileManager()
    
    private init(){}
    
    private let fileManager = FileManager.default
    
    func saveImage(image: UIImage, fileName: String) throws{
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            throw AppFileManagerExceptoin("Return image as JPEG is Nil")
        }
        let directory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL
        try data.write(to: directory.appendingPathComponent(fileName)!)
    }
    
    func getSavedImage(named: String) throws -> UIImage? {
        if let dir = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
}



class AppFileManagerExceptoin: SystemException{
    
}
