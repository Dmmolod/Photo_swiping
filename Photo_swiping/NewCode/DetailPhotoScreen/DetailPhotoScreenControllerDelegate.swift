//
//  DetailPhotoScreenControllerDelegate.swift
//  Photo_swiping
//
//  Created by Дмитрий Молодецкий on 24.03.2022.
//

import Foundation

protocol DetailPhotoScreenControllerDelegate: AnyObject {
    
    func detailPhotoScreen(_ detailPhotoScreenController: DetailPhotoScreenController, deleteIndexContent: Int)
    func detailPhotoScreenBackPressed(_ detailPhotoScreenController: DetailPhotoScreenController)
}
