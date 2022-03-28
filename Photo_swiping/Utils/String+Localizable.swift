import Foundation

extension String {
    var localizable: String {
        return NSLocalizedString(self, comment: "")
    }
}
