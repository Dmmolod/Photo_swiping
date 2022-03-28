import Foundation
import UIKit
import SwiftyKeychainKit

class UserDataManager {
    
    static private let keychain = Keychain(service: "userInfo.service")
    static private let key = KeychainKey<String>(key: "userPassword")
    static private let fileName = "UserData"
    static private let userDataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
    
    static func saveUser(_ user: User) {
        try? keychain.set(user.password, for: key)
        let userToSave = User(name: user.name, password: "not_now")
        guard let fileURL = Self.userDataURL,
        let userData = try? JSONEncoder().encode(userToSave) else { return }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(atPath: fileURL.path)
        }
        
        try? userData.write(to: fileURL)
    }
    
    static func loadUser() -> User? {
        guard let fileURL = Self.userDataURL,
              let userData = try? Data(contentsOf: fileURL),
              let user = try? JSONDecoder().decode(User.self, from: userData),
              let userPassword = try? keychain.get(key)  else { return nil }
        
        return User(name: user.name, password: userPassword)
    }
    
    static func deleteUser() {
        guard let fileURL = userDataURL else { return }
        try? FileManager.default.removeItem(atPath: fileURL.path)
    }
}
