import Foundation
import UIKit

protocol AuthorizationScreenControllerDelegate: AnyObject {
    func authorizationScreen(_ authorizationScreen: AuthorizationScreenController, passwordIncorrect alert: UIAlertController)
    func authorizationScreen(_ authorizationScreen: AuthorizationScreenController, login: User)
}
