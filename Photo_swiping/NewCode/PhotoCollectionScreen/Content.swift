import Foundation
import UIKit

struct Content {
    var id: String? = nil
    var photo: UIImage
    var comment: String?
    var like: Bool = false
    
    init(id: String, photo: UIImage, comment: String?, like: Bool) {
        self.id = id
        self.photo = photo
        self.comment = comment
        self.like = like
    }
    
    init(photo: UIImage, comment: String?) {
        self.photo = photo
        self.comment = comment
    }
    
    init(photo: UIImage) {
        self.photo = photo
        self.comment = nil
    }
    
}
