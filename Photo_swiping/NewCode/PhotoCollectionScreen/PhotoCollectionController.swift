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
    var ignoreDefaultContentList: Int = Int() {
        didSet {
            allContentModel.remove(at: ignoreDefaultContentList)
            photoCollectionView.photoCollection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = photoCollectionView
        
        allContentModel.append(contentsOf: ContentManager.getDefaultContent())
        setSavedPhoto()
        setupCollection()
        photoCollectionView.logOutButtonAction = UIAction { _ in self.logOutButtonPressed()}
    }
    
    func contentCount() -> Int {
        return allContentModel.count
    }
    
    func contentIndex(from indexPath: IndexPath) -> Int? {
        let contentIndex = indexPath.row - 1
        
        guard contentIndex < allContentModel.count else { return nil }
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
        let contentToSave = Content(photo: imageToAdd)
        let id = ContentManager.saveContent(contentToSave)
        let content = Content(id: id, photo: imageToAdd, comment: nil, like: false)
        allContentModel.insert(content, at: 0)
        photoCollectionView.photoCollection.reloadData()
    }
    
    private func setSavedPhoto() {
        let savedContents = ContentManager.getContents()
        
        allContentModel.insert(contentsOf: savedContents, at: 0)
        photoCollectionView.photoCollection.reloadData()
    }
    
    private func logOutButtonPressed() {
        delegate?.photoCollectionDidLogOut(self)
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
