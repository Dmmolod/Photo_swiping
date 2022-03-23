import Foundation
import UIKit

class AddPhotoCell: UICollectionViewCell {
    
    static let identifier = "AddPhotoCell"
    
    private let addIcon = UIImageView(image: UIImage(systemName: "plus.square.fill"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(addIcon)
        addIcon.contentMode = .scaleAspectFill
        addIcon.tintColor = .gray
        addIcon.anchor(top: contentView.topAnchor,
                       bottom: contentView.bottomAnchor,
                       leading: contentView.leadingAnchor,
                       trailing: contentView.trailingAnchor)
    }
}
