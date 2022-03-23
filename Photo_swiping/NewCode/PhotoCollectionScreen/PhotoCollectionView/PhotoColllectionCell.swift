//
//  PhotoColllectionCell.swift
//  HomeWork19
//
//  Created by Дмитрий Молодецкий on 17.03.2022.
//

import Foundation
import UIKit

class PhotoColllectionCell: UICollectionViewCell {
    
    static let identifier = "PhotoColllectionCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with photo: UIImage) {
        imageView.image = photo
    }
    
    private func setupUI() {
        backgroundColor = .systemGray2
        layer.cornerRadius = 20
        contentView.addSubview(imageView)
        
        imageView.contentMode = .scaleAspectFill
        imageView.anchor(top: contentView.topAnchor,
                         bottom: contentView.bottomAnchor,
                         leading: contentView.leadingAnchor,
                         trailing: contentView.trailingAnchor)
    }
}
