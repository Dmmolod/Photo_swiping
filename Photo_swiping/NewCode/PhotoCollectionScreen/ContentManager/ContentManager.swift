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
    static private let ignoreDefaultContentListKey = "ignoreDefaultContentList"
    static private let contentKey = "ContentManager"
    static private var fileNames: [String] {
        let names = UserDefaults.standard.stringArray(forKey: contentKey)
        return names != nil ? names! : []
    }
    static private let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    
    static func saveContent(_ content: Content) -> String? {
        
        let fileName = content.id != nil ? content.id! : UUID().uuidString // Создание или использование имеющегося имя файла
        
        guard let fileURL = documentsDirectory?.appendingPathComponent(fileName), // Проверка возможности получение URL по указаному адресу
              let photoData = content.photo.jpegData(compressionQuality: 1) else { return nil } // Проверка возможности перевести фото в дату
        
        let contentToSave = ContentData(photo: photoData, comment: content.comment, like: content.like) // создание контента к сохранению, который конформит к codable
        
        guard let contentData = try? JSONEncoder().encode(contentToSave) else { return nil } // проверка что кодировка контента в дату удалась
        
        if FileManager.default.fileExists(atPath: fileURL.path) { // Проверяем не было ли уже такого же файла по этому пути
            do { try FileManager.default.removeItem(atPath: fileURL.path) } catch { // Если был, то удаляем его
                return nil // если не получилось удалить, то прерываем сохранение данных
            }
        }
        
        guard let _ = try? contentData.write(to: fileURL) else { return nil} // Проверяем удалось ли записать данные в файл
        
        if content.id == nil { // Если это новый файл
                saveFileName(fileName)
        }
        return fileName
    }
    
    static func getContents() -> [Content] {
        
        return fileNames.compactMap({
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
    
    static func getDefaultContent() -> [Content] {
        let ignoreList = UserDefaults.standard.stringArray(forKey: ignoreDefaultContentListKey)
        let defaultContents: [Content] = (0...13).compactMap { number in
            let name = "defaultImage\(number)"
            guard let photo = UIImage(named: name) else { return nil }
            
            if let ignoreList = ignoreList {
                if ignoreList.contains(name) { return nil }
            }
            
            let content = Content(id: name, photo: photo, comment: nil, like: false)
            guard let defaultContentURL = documentsDirectory?.appendingPathComponent(name),
                  let defaultContentData = try? Data(contentsOf: defaultContentURL),
                  let savedСontent = try? JSONDecoder().decode(ContentData.self, from: defaultContentData) else { return content }
            content.like = savedСontent.like
            content.comment = savedСontent.comment
            return content
        }
        
        return defaultContents
    }
    
    static func removeContent(from id: String) {
        
        if id.contains("defaultImage") {
            var ignoreList = UserDefaults.standard.stringArray(forKey: ignoreDefaultContentListKey)
            ignoreList = ignoreList == nil ? [id] : ignoreList?.firstIndex(of: id) == nil ? ignoreList! + [id] : nil
            if ignoreList != nil { UserDefaults.standard.set(ignoreList!, forKey: ignoreDefaultContentListKey)}
            print(UserDefaults.standard.stringArray(forKey: ignoreDefaultContentListKey))
        }
        
        var newFileNames = fileNames
        
        guard let removeIndex = newFileNames.firstIndex(of: id) else { return }
        
        let removeFileName = newFileNames.remove(at: removeIndex)
        guard let fileURL = documentsDirectory?.appendingPathComponent(removeFileName),
              ((try? FileManager.default.removeItem(atPath: fileURL.path)) != nil) else { return }
        
        UserDefaults.standard.set(newFileNames, forKey: contentKey)
    }
    
    static private func saveFileName(_ fileName: String) {
        
        var newFileNames = fileNames
        newFileNames.insert(fileName, at: 0)
        UserDefaults.standard.set(newFileNames, forKey: contentKey)
    }
}

