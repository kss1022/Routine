//
//  AppFileManager.swift
//  Routine
//
//  Created by 한현규 on 11/23/23.
//

import Foundation
import UIKit.UIImage
import UniformTypeIdentifiers

//if Info Plist -> Supports Document Browser -> true : Check File in Apple "Files" App

class AppFileManager{
    
    public static let share = AppFileManager()
    
    
    
    private let fileManager: FileManager
    
    private let defaultPath: URL
    let imagePath: URL
    
    
    private init(){
        fileManager = FileManager.default
        defaultPath =  try! fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor:  Bundle.main.bundleURL,
            create: false
        )
        
        imagePath = defaultPath.appendingPathComponent("image")
        
        
        try! createDirectoryIfNotExists(path: imagePath)
    }
    
    
    func find(url: URL, fileName: String, type: UTType) -> String?{
        let url = self.url(url: url, fileName: fileName, type: type)
        let path = url.path
        
        if !fileManager.fileExists(atPath: path){
            return nil
        }
        
        return path
    }
    
    func save(data: Data, url: URL, fileName: String, type: UTType) throws{
        let newPath = self.url(url: url, fileName: fileName, type: type)
        
        if fileManager.fileExists(atPath: newPath.path){
            throw AppFileManagerExceptoin("FileManger file already exists: \(url.appendingPathComponent(fileName))")
        }
        
        try data.write(to: newPath)
        Log.v("FileManger save file: \(fileName)")
    }
        
    
    func delete(url: URL, fileName: String, type: UTType) throws{
        let url = self.url(url: url, fileName: fileName, type: type)
        let path = url.path
        
        if !fileManager.fileExists(atPath: path){
            throw AppFileManagerExceptoin("FileManger file is no exists: \(url.appendingPathComponent(fileName))")
        }
        
        try FileManager.default.removeItem(atPath: path)
        Log.v("FileManage delete file: \(path)")
    }
    
    func deleteIfExists(url: URL, fileName: String, type: UTType) throws{
        let url = self.url(url: url, fileName: fileName, type: type)
        let path = url.path
        
        if fileManager.fileExists(atPath: path){
            try FileManager.default.removeItem(atPath: path)
            Log.v("FileManage delete file: \(path)")
        }
    }
    
    
    
    private func url(url: URL, fileName: String, type: UTType) -> URL{
        URL(fileURLWithPath: url.absoluteString).appendingPathComponent(fileName, conformingTo: type)
    }
    
    
    private func createDirectoryIfNotExists(path : URL) throws{
        if !fileManager.fileExists(atPath: path.path) {
            try fileManager.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
            Log.v("FileManger create directory: \(path)")
        }
        
    }
    
    
}


extension UIImage{
    convenience init?(fileName: String){
        let manager = AppFileManager.share
        let url = manager.imagePath
        
        guard let path = manager.find(url: url, fileName: fileName, type: .png) else { return nil}
        self.init(contentsOfFile: path)
    }
}


class AppFileManagerExceptoin: SystemException{
    
}
