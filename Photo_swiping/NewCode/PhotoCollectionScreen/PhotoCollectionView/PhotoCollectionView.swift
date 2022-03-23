import Foundation
import UIKit



class PhotoCollectionView: UIView {
    
    private let navigationBar = UIView()
    private let logOutButton = AnimateTapButton()
    var logOutButtonAction: UIAction? {
        didSet {
            guard let logOutButtonAction = logOutButtonAction else { return }
            logOutButton.addAction(logOutButtonAction, for: .touchDown)
        }
    }
    
    let photoCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupBackground(name: "nightCity")
        setupBlur(with: .light)
        navigationBar.setupBlur(with: .light)
        
        [navigationBar, photoCollection].forEach({addSubview($0)})
        
        navigationBar.anchor(top: topAnchor,
                             bottom: safeAreaLayoutGuide.topAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor,
                             paddingBottom: -60)
        
        navigationBar.addSubview(logOutButton)
        
        logOutButton.setImage(UIImage(named: "logout")?.withTintColor(.black), for: .normal)
        logOutButton.anchor(bottom: navigationBar.bottomAnchor,
                            trailing: navigationBar.trailingAnchor,
                            paddingBottom: 30 - 22, paddingTrailing: 20, width: 44, height: 44)

        photoCollection.backgroundColor = .clear
        photoCollection.anchor(top: navigationBar.bottomAnchor,
                               bottom: bottomAnchor,
                               leading: navigationBar.leadingAnchor,
                               trailing: navigationBar.trailingAnchor)
    }

}

