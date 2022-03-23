//
//  PhotoCollectionController.swift
//  HomeWork19
//
//  Created by Дмитрий Молодецкий on 17.03.2022.
//

import Foundation
import UIKit

class PhotoCollectionController: UIViewController {
    
    weak var delegate: PhotoCollectionControllerDelegate?
    private let photoCollectionView = PhotoCollectionView()
    private var allContentModel = [Content]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = photoCollectionView
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupDefaultImages()
        setSavedPhoto()
        setupCollection()
        photoCollectionView.logOutButtonAction = UIAction { _ in self.logOutButtonPressed()}
    }
    
    func contentCount() -> Int {
        return allContentModel.count
    }
    
    func contentIndex(from indexPath: IndexPath) -> Int? {
        let contentIndex = indexPath.row - 1
        
        guard (contentIndex) < allContentModel.count else { return nil }
        return contentIndex
    }
    
    func content(from indexPath: IndexPath) -> Content? {
        let contentIndex = indexPath.item - 1
        guard contentIndex < allContentModel.count else { return nil }
        return allContentModel[contentIndex]
    }
    
    func allContent() -> [Content] {
        return allContentModel
    }
    
    func updatePhotoCollection(_ imageToAdd: UIImage) {
        let newContent = Content(photo: imageToAdd)
        allContentModel.insert(newContent, at: 0)
        ContentManager.makeAndSaveContent(newContent)
        photoCollectionView.photoCollection.reloadData()
    }
    
    private func setSavedPhoto() {
        guard let savedContents = ContentManager.getContents() else { return }
        
        allContentModel.insert(contentsOf: savedContents, at: 0)
        photoCollectionView.photoCollection.reloadData()
    }
    
    private func logOutButtonPressed() {
        delegate?.photoCollectionDidLogOut(self)
    }
    
    private func setupDefaultImages() {
        let allContent: [Content] = (0...13).compactMap { number in
            guard let photo = UIImage(named: "image\(number)") else { return nil }
            return Content(photo: photo, comment: nil)
        }
        self.allContentModel = allContent
    }
    
    private func setupCollection() {
        photoCollectionView.photoCollection.delegate = self
        photoCollectionView.photoCollection.dataSource = self
        photoCollectionView.photoCollection.register(PhotoColllectionCell.self, forCellWithReuseIdentifier: PhotoColllectionCell.identifier)
        photoCollectionView.photoCollection.register(AddPhotoCell.self, forCellWithReuseIdentifier: AddPhotoCell.identifier)
    }
    
    func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        picker.sourceType = sourceType
        picker.modalPresentationStyle = .fullScreen
        
        present(picker, animated: true)
    }

}
