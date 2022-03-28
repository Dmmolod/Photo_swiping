import Foundation
import UIKit

extension PhotoCollectionController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentCount() + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item != 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoColllectionCell.identifier,
                                                                for: indexPath) as? PhotoColllectionCell,
                  let content = content(from: indexPath) else { return UICollectionViewCell() }
            
            cell.configure(with: content.photo)
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddPhotoCell.identifier,
                                                            for: indexPath) as? AddPhotoCell else { return UICollectionViewCell() }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let side = (collectionView.frame.size.width - 30) / 2
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != 0,
           let contentIndex = contentIndex(from: indexPath) {
            delegate?.photoCollection(self, didSelectPhoto: contentIndex, from: allContent())
            return
        }
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Camera".localizable, style: .default, handler: { _ in self.presentImagePicker(sourceType: .camera)}))
        ac.addAction(UIAlertAction(title: "Gallery".localizable, style: .default, handler: { _ in self.presentImagePicker(sourceType: .photoLibrary)}))
        ac.addAction(UIAlertAction(title: "Cancel".localizable, style: .cancel))
        
        present(ac, animated: true)
    }
}

extension PhotoCollectionController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let editedImage = info[.editedImage] as? UIImage
        let originalImage = info[.originalImage] as? UIImage
        if let imageToAdd: UIImage = editedImage != nil ? editedImage : originalImage != nil ? originalImage : nil {
            updatePhotoCollection(imageToAdd)
        }
        
        picker.dismiss(animated: true)
    }
}
