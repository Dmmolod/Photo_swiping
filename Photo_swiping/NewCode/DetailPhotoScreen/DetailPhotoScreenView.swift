import UIKit

class DetailPhotoScreenView: UIView {
    private typealias AnimateConstaints = (previousCenter: NSLayoutConstraint,
                                           nextLeading: NSLayoutConstraint)
    
    private let navigationBar = UIView()
    private let backButton = UIButton()
    private let likeButton = UIButton()
    private let previousButton = UIButton()
    private let nextButton = UIButton()
    private let photoContainer = UIView()
    private let currentPhoto = UIImageView(image: UIImage(systemName: "tortoise"))
    let commentField = UITextField()

    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupButtonsAction(back: UIAction, like: UIAction, previous: UIAction, next: UIAction) {
        let actions = [back, like, previous, next]
        [backButton, likeButton, previousButton, nextButton].enumerated().forEach({ $1.addAction(actions[$0], for: .touchUpInside) })
    }
    
    func configure(_ content: Content) {
        currentPhoto.image = content.photo
        commentField.text = content.comment
        likeButton.tintColor = content.like ? .systemPink : .systemGray4
    }
    
    func startAnimation(side: SwipeSide, newContent: Content) {
        let isLeftSwipe = side == SwipeSide.left
        
        let newPhotoView = UIImageView()
        [newPhotoView].forEach({
            photoContainer.addSubview($0)
            $0.image = isLeftSwipe ? currentPhoto.image : newContent.photo
            $0.layer.cornerRadius = 22
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.frame = currentPhoto.frame
            $0.frame.origin.x += isLeftSwipe ? 0 : frame.size.width
        })
        
        if isLeftSwipe { currentPhoto.image = newContent.photo }

        UIView.animate(withDuration: 0.3, delay: 0) {
            newPhotoView.frame.origin.x -= self.frame.size.width
        } completion: { _ in
            if !isLeftSwipe { self.configure(newContent) }
            self.commentField.text = newContent.comment
            self.likeButton.tintColor = newContent.like ? .systemPink : .systemGray3
            newPhotoView.removeFromSuperview()
        }
    }
    
    private func setupUI() {
        setupBackground(name: "nightCity")
        let bottomContainer = UIView()
        let textFieldContainer = UIView()
        backgroundColor = .white
        
        // MARK: Elements with blur effect
        bottomContainer.setupBlur(with: .light)
        navigationBar.setupBlur(with: .light)
        textFieldContainer.setupBlur(with: .light, blurAlpha: 1)
        
        // MARK: AddSubviews
        [navigationBar, photoContainer, bottomContainer, textFieldContainer].forEach({ addSubview($0) })
        [backButton, likeButton].forEach({ navigationBar.addSubview($0) })
        
        // MARK: Navigation bar setup
        navigationBar.backgroundColor = .clear
        navigationBar.anchor(top: topAnchor,
                             bottom: safeAreaLayoutGuide.topAnchor,
                             leading: leadingAnchor,
                             trailing: trailingAnchor, paddingBottom: -60)
        backButton.setBackgroundImage(UIImage(systemName: "xmark.circle"), for: .normal)
        backButton.tintColor = .systemGray4
        backButton.anchor(bottom: navigationBar.bottomAnchor,
                          leading: navigationBar.leadingAnchor,
                          paddingBottom: 30 - 22,
                          paddingLeading: 20, width: 44, height: 44)
        
        likeButton.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.anchor(top: backButton.topAnchor,
                          bottom: backButton.bottomAnchor,
                          trailing: navigationBar.trailingAnchor,
                          paddingTrailing: 20)
        likeButton.dimensionAnchors(width: backButton.widthAnchor, height: backButton.heightAnchor)
        
        // MARK: Photo container setup
        photoContainer.anchor(top: navigationBar.bottomAnchor, bottom: textFieldContainer.topAnchor, leading: leadingAnchor, trailing: trailingAnchor)
        photoContainer.addSubview(currentPhoto)
        
        currentPhoto.layer.cornerRadius = 22
        currentPhoto.contentMode = .scaleAspectFill
        currentPhoto.clipsToBounds = true
        
        currentPhoto.anchor(top: photoContainer.topAnchor,
                            bottom: photoContainer.bottomAnchor,
                            leading: photoContainer.leadingAnchor,
                            trailing: photoContainer.trailingAnchor,
                            paddingTop: 20, paddingBottom: 20, paddingLeading: 20, paddingTrailing: 20)
        
        // MARK: Text Field container setup
        textFieldContainer.anchor(bottom: bottomContainer.topAnchor, leading: bottomContainer.leadingAnchor, trailing: bottomContainer.trailingAnchor)
        textFieldContainer.addSubview(commentField)
        
        commentField.textAlignment = .center
        commentField.textColor = .black
        commentField.anchor(top: textFieldContainer.topAnchor,
                            bottom: textFieldContainer.bottomAnchor,
                            leading: textFieldContainer.leadingAnchor,
                            trailing: textFieldContainer.trailingAnchor,
                            paddingLeading: 20, paddingTrailing: 20, height: 40)
        
        // MARK: Bottom container setup
        bottomContainer.anchor(top: safeAreaLayoutGuide.bottomAnchor,bottom: bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, paddingTop: -50)
        [previousButton, nextButton].forEach({
            bottomContainer.addSubview($0)
            let imageName = $0 == previousButton ? "arrow.left" : "arrow.right"
            
            $0.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 44, weight: .bold, scale: .large)), for: .normal)
            $0.tintColor = .white
        })
        
        previousButton.centerY(inView: bottomContainer)
        previousButton.anchor(leading: bottomContainer.leadingAnchor, paddingLeading: 20)
        
        nextButton.centerY(inView: previousButton)
        nextButton.dimensionAnchors(width: previousButton.widthAnchor, height: previousButton.heightAnchor)
        nextButton.anchor(leading: previousButton.trailingAnchor, trailing: bottomContainer.trailingAnchor, paddingLeading: 20, paddingTrailing: 20)
    }
}
