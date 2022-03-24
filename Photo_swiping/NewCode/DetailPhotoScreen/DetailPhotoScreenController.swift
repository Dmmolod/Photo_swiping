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
    private var currentContent: Content {
        return allContent[currentContentIndex]
    }
    
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
        
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(deletePhoto)))
        
        detailPhotoScreen.setupButtonsAction(back: UIAction { _ in self.backButtonPressed()},
                                             like: UIAction { _ in self.likeButtonPressed()},
                                             previous: UIAction { _ in self.previousButtonPressed()},
                                             next: UIAction { _ in self.nextButtonPressed()})
        
        detailPhotoScreen.commentField.delegate = self
    }
    
    @objc private func deletePhoto(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        print("OKEY")
        guard let currentId = currentContent.id else { return }
        let ac = UIAlertController(title: "Delete this photo?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { _ in
            print("DELETE")
            print(self.allContent.count)
            self.delegate?.detailPhotoScreen(self, deleteIndexContent: self.currentContentIndex)
            self.allContent.remove(at: self.currentContentIndex)
            ContentManager.removeContent(from: currentId) }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    private func likeButtonPressed() {
        currentContent.like = currentContent.like ? false : true
        detailPhotoScreen.configure(currentContent)
        ContentManager.saveContent(currentContent)
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
