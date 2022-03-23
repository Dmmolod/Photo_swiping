//
//  PhotoManager.swift
//  Photo_swiping
//
//  Created by Дмитрий Молодецкий on 21.03.2022.
//

import Foundation
import UIKit

class ContentManager {
    
    private struct ContentData: Codable {
        let photo: Data
        let comment: String?
        let like: Bool
    }
    
    static private let contentKey = "ContentManager"
    static private var fileNames: [String]? {
        return UserDefaults.standard.stringArray(forKey: contentKey)
    }
    static private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    
    static func makeAndSaveContent(_ content: Content) {
        let fileName = content.id != nil ? content.id! : UUID().uuidString
        
        guard let fileURL = documentsDirectory?.appendingPathComponent(fileName),
              let imageData = content.photo.jpegData(compressionQuality: 1) else { return }
        let contentToSave = ContentData(photo: imageData, comment: content.comment, like: content.like)
        guard let contentData = try? JSONEncoder().encode(contentToSave) else { return }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do { try FileManager.default.removeItem(atPath: fileURL.path) } catch {
                return
            }
        }
        let check: ()? = try? contentData.write(to: fileURL)
        if check != nil,
           content.id == nil {
            saveFileName(fileName)
        }
    }
    
    static func getContents() -> [Content]? {
        
        return fileNames?.compactMap({
            guard let fileURL = documentsDirectory?.appendingPathComponent($0),
                  let contentData = try? Data(contentsOf: fileURL),
                  let content = try? JSONDecoder().decode(ContentData.self, from: contentData),
                  let photo = UIImage(data: content.photo) else { return nil}
            
            return Content(id: $0,
                           photo: photo,
                           comment: content.comment,
                           like: content.like)
        })
    }
    
    static func removeContent(from id: String) {
        guard var newFileNames = fileNames,
              let removeIndex = newFileNames.firstIndex(of: id) else { return }
        let removeFileName = newFileNames.remove(at: removeIndex)
        guard let fileURL = documentsDirectory?.appendingPathComponent(removeFileName),
        ((try? FileManager.default.removeItem(at: fileURL)) != nil) else { return }
        
        UserDefaults.standard.set(newFileNames, forKey: contentKey)
    }
    
    static private func saveFileName(_ fileName: String) {
        var newFileNames = fileNames
        newFileNames?.insert(fileName, at: 0)
        let result = fileNames != nil ? fileNames : [fileName]
        UserDefaults.standard.set(result, forKey: contentKey)
    }
}

