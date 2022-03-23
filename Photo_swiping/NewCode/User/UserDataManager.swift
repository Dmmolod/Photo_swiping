import Foundation
import UIKit

class UserDataManager {
    
    static private let fileName = "UserData"
    static private let userDataURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(fileName)
    
    static func saveUser(_ user: User) {
    
        guard let fileURL = Self.userDataURL,
        let userData = try? JSONEncoder().encode(user) else { return }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(atPath: fileURL.path)
        }
        
        try? userData.write(to: fileURL)
    }
    
    static func loadUser() -> User? {
        guard let fileURL = Self.userDataURL,
              let userData = try? Data(contentsOf: fileURL),
              let user = try? JSONDecoder().decode(User.self, from: userData) else { return nil }
        return user
    }
    
    static func deleteUser() {
        guard let fileURL = userDataURL else { return }
        try? FileManager.default.removeItem(atPath: fileURL.path)
    }
}
