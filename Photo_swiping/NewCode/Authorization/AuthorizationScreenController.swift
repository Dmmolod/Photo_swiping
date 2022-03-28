import Foundation
import UIKit
import SVProgressHUD

class AuthorizationScreenController: UIViewController {
    
    weak var delegate: AuthorizationScreenControllerDelegate?
    let authorizationScreen = AuthorizationScreenView()
    private var user: User?
    private let blind = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = authorizationScreen
        setupAutorizationScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkUserInData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        clearTextFields()
    }
    
    private func clearTextFields() {
        authorizationScreen.textFields.forEach({ $0.text = nil })
    }
    
    private func setupAutorizationScreen() {
        authorizationScreen.textFields.forEach({ $0.delegate = self })
        authorizationScreen.joinButton.addAction(UIAction { _ in self.joinButtonPressed() }, for: .touchUpInside)
    }
    
    private func checkUserInData() {
        guard let user = UserDataManager.loadUser() else { return }
        self.user = user
        authorizationScreen.setupUIWith(user)
    }
    
    private func joinButtonPressed() {
        let passwordText = textFromField(fieldType: .password)
        if !TextFieldType.password.checkInfoIsReadyFunction()(passwordText) {
            let alert = UIAlertController(title: "Password error".localizable,
                                          message: "Password must consist of 4 digits".localizable,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK".localizable, style: .cancel))
            delegate?.authorizationScreen(self, passwordIncorrect: alert)
            return
        }
        
        resignFirstResponder()
        
        if let user = user {
            if passwordText != user.password {
                let alert = UIAlertController(title: "Wrong password".localizable, message: "Try again".localizable, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK".localizable, style: .destructive))
                delegate?.authorizationScreen(self, passwordIncorrect: alert)
                authorizationScreen.textFields[TextFieldType.password.textFieldIndex()].text = nil
                return
            }
            view.endEditing(true)
            delegate?.authorizationScreen(self, login: user)
            return
        }
        
        let name = textFromField(fieldType: .name)
        let user = User(name: (name.isEmpty ? "Anonymous".localizable : name),
                        password: textFromField(fieldType: .password))
        UserDataManager.saveUser(user)
        delegate?.authorizationScreen(self, login: user)
    }
    
}

