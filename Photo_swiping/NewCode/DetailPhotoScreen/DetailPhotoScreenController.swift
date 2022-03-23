//
//  DetailPhotoScreenController.swift
//  HomeWork19
//
//  Created by Дмитрий Молодецкий on 18.03.2022.
//

import UIKit

class DetailPhotoScreenController: UIViewController {
    
    let detailPhotoScreen = DetailPhotoScreenView()
    var allContent: [Content]
    var currentContentIndex: Int
    
    init(currentContentIndex: Int, allContent: [Content]) {
        self.allContent = allContent
        self.currentContentIndex = currentContentIndex
        
        super.init(nibName: nil, bundle: nil)
        
        guard currentContentIndex >= 0,
              currentContentIndex < allContent.count else { return }
        
        let content = allContent[currentContentIndex]
        detailPhotoScreen.configure(content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailPhotoScreen
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto(rec:))))
        detailPhotoScreen.setupButtonsAction(back: UIAction { _ in self.backButtonPressed()},
                                             like: UIAction { _ in self.likeButtonPressed()},
                                             previous: UIAction { _ in self.previousButtonPressed()},
                                             next: UIAction { _ in self.nextButtonPressed()})
        detailPhotoScreen.commentField.delegate = self
    }
    
    @objc private func deletePhoto(rec: UILongPressGestureRecognizer) {
        guard rec.state != .changed else { return }
        print("DELETE")
    }
    
    private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    private func likeButtonPressed() {
        
        print("like")
    }
    
    private func previousButtonPressed() {
        let check = currentContentIndex - 1 >= 0
        let newContentIndex = check ? currentContentIndex - 1 : allContent.count - 1
        
        detailPhotoScreen.startAnimation(side: .left, newContent: allContent[newContentIndex])
        self.currentContentIndex = newContentIndex
    }
    
    private func nextButtonPressed() {
        let check = currentContentIndex + 1 < allContent.count
        let newContentIndex = check ? currentContentIndex + 1 : 0
        
        detailPhotoScreen.startAnimation(side: .right, newContent: allContent[newContentIndex])
        self.currentContentIndex = newContentIndex
    }
}

extension DetailPhotoScreenController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("END EDITING")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("RETURN")
        return false
    }
}
