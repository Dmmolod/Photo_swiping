import Foundation
import UIKit

class AuthorizationScreenView: UIView {
    
    private let backgroundImage = UIImageView(image: UIImage(named: "nightCity"))
    private let containerAuth = UIView()
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let title: UILabel = {
        let title = UILabel()
        title.text = "Welcome".localizable + "!"
        title.textAlignment = .center
        title.font = .systemFont(ofSize: 20, weight: .heavy)
        return title
    }()
    let textFields: [UITextField]
    let joinButton = UIButton(configuration: .filled())
    
    init() {
        textFields = TextFieldType.allCases.map({ Self.textField(fieldType: $0) })
        super.init(frame: .zero)
        setupUI()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapDetected)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapDetected() {
        endEditing(true)
    }
    
    func setupUIWith(_ user: User) {
        guard var text = title.text else { return }
        text.removeLast()
        text += text == "Welcome".localizable ? ", \(user.name.localizable)!" : ""
        title.text = text
        joinButton.setTitle("Login".localizable, for: .normal)
        
        textFields[TextFieldType.name.textFieldIndex()].anchor(height: 0)
    }
    
    static private func textField(fieldType: TextFieldType) -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .systemGray5
        
        textField.autocapitalizationType = fieldType.autocapitalizationType()
        textField.placeholder = fieldType.placeholder()
        textField.textAlignment = .center
        textField.isSecureTextEntry = fieldType.isSecurityText()
        textField.returnKeyType = fieldType.returnType()
        if let keyboardType = fieldType.keyboardType() {
            textField.keyboardType = keyboardType
        }
        
        return textField
    }
    
    private func setupUI() {
        
        let mainContainer = UIView()
        [backgroundImage, mainContainer].forEach({ addSubview($0) })
        mainContainer.addSubview(containerAuth)
        [blurView, title].forEach({ containerAuth.addSubview($0) })
        
        backgroundImage.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        
        mainContainer.anchor(top: topAnchor, bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        
        containerAuth.layer.cornerRadius = 20
        containerAuth.clipsToBounds = true
        containerAuth.centerX(inView: mainContainer)
        containerAuth.centerY(inView: mainContainer)
        containerAuth.anchor(leading: mainContainer.leadingAnchor, trailing: mainContainer.trailingAnchor, paddingLeading: 20, paddingTrailing: 20)
        containerAuth.dimensionAnchors(height: containerAuth.widthAnchor, multiplierHeight: 1/2)
        
        blurView.anchor(top: containerAuth.topAnchor, bottom: containerAuth.bottomAnchor, leading: containerAuth.leadingAnchor, trailing: containerAuth.trailingAnchor)
        
        title.anchor(top: containerAuth.topAnchor, leading: containerAuth.leadingAnchor, trailing: containerAuth.trailingAnchor)
        
        textFields.forEach({
            guard let lastView = containerAuth.subviews.last else { return }
            containerAuth.addSubview($0)
            $0.anchor(top: lastView.bottomAnchor, paddingTop: 20)
            $0.centerX(inView: lastView)
            $0.dimensionAnchors(width: containerAuth.widthAnchor, multiplierWidth: 1/1.5)
        })
        containerAuth.addSubview(joinButton)
        joinButton.anchor(bottom: containerAuth.bottomAnchor, paddingBottom: 20)
        joinButton.centerX(inView: containerAuth)
        
        joinButton.setTitle("Sign Up".localizable, for: .normal)
    }
}
