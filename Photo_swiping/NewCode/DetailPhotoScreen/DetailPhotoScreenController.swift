//
//  DetailPhotoScreenController.swift
//  HomeWork19
//
//  Created by Дмитрий Молодецкий on 18.03.2022.
//

import UIKit

class DetailPhotoScreenController: UIViewController {
    
    weak var delegate: DetailPhotoScreenControllerDelegate?
    
    let detailPhotoScreen = DetailPhotoScreenView()
    var allContent: [Content]
    var currentContentIndex: Int
    var currentContent: Content {
        return allContent[currentContentIndex]
    }
    var zoomingPhotoRecognizer = UITapGestureRecognizer()
    
    init(currentContentIndex: Int, allContent: [Content]) {
        self.allContent = allContent
        self.currentContentIndex = currentContentIndex

        super.init(nibName: nil, bundle: nil)
        
        detailPhotoScreen.configure(currentContent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailPhotoScreen
        addRecognizers()
        detailPhotoScreen.setupButtonsAction(back: UIAction { _ in self.backButtonPressed()},
                                             like: UIAction { _ in self.likeButtonPressed()},
                                             previous: UIAction { _ in self.previousButtonPressed()},
                                             next: UIAction { _ in self.nextButtonPressed()})
        registerForKeyboardNotifications()
        detailPhotoScreen.commentField.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func hideKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc private func deletePhoto(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        guard let currentId = currentContent.id else { return }
        let ac = UIAlertController(title: "Delete this photo?".localizable, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "DELETE".localizable, style: .destructive, handler: { _ in
            self.delegate?.detailPhotoScreen(self, deleteIndexContent: self.currentContentIndex)
            self.allContent.remove(at: self.currentContentIndex)
            ContentManager.removeContent(from: currentId) }))
        ac.addAction(UIAlertAction(title: "Cancel".localizable, style: .cancel))
        
        present(ac, animated: true)
    }
    
    private func addRecognizers() {
        
        // MARK: Swipe recognizers
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(previousButtonPressed))
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(nextButtonPressed))
        leftSwipeRecognizer.direction = .left
        rightSwipeRecognizer.direction = .right
        [leftSwipeRecognizer, rightSwipeRecognizer].forEach({ view.addGestureRecognizer($0) })
        
        // MARK: Tap recognizers
        zoomingPhotoRecognizer = UITapGestureRecognizer(target: detailPhotoScreen, action: #selector(detailPhotoScreen.zoomingPhoto))
        detailPhotoScreen.currentPhoto.addGestureRecognizer(zoomingPhotoRecognizer)
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
    }
    
    private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    private func likeButtonPressed() {
        currentContent.like = currentContent.like ? false : true
        detailPhotoScreen.configure(currentContent)
        let _ = ContentManager.saveContent(currentContent)
    }
    
    @objc private func previousButtonPressed() {
        let check = currentContentIndex - 1 >= 0
        let newContentIndex = check ? currentContentIndex - 1 : allContent.count - 1
        
        detailPhotoScreen.startAnimation(side: .left, newContent: allContent[newContentIndex])
        self.currentContentIndex = newContentIndex
    }
    
    @objc private func nextButtonPressed() {
        let check = currentContentIndex + 1 < allContent.count
        let newContentIndex = check ? currentContentIndex + 1 : 0
        
        detailPhotoScreen.startAnimation(side: .right, newContent: allContent[newContentIndex])
        self.currentContentIndex = newContentIndex
    }
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        if notification.name == UIResponder.keyboardWillHideNotification {
            detailPhotoScreen.currentPhoto.addGestureRecognizer(zoomingPhotoRecognizer)
            detailPhotoScreen.bottomConstraint.constant = 0
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            detailPhotoScreen.currentPhoto.removeGestureRecognizer(zoomingPhotoRecognizer)
            detailPhotoScreen.bottomConstraint.constant = -keyboardScreenEndFrame.height - 15
        }

        view.needsUpdateConstraints()
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}

extension DetailPhotoScreenController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentContent.comment = textField.text
        ContentManager.saveContent(currentContent)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        currentContent.comment = textField.text
        ContentManager.saveContent(currentContent)
        return false
    }
}
