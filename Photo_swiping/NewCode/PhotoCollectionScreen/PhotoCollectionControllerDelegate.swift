//
//  PhotoCollectionControllerDelegate.swift
//  HomeWork19
//
//  Created by Дмитрий Молодецкий on 18.03.2022.
//

import Foundation

protocol PhotoCollectionControllerDelegate: AnyObject {
    
    func photoCollection(_ photoCollectionController: PhotoCollectionController, didSelectPhoto contentIndex: Int, from allContent: [Content])
    
    func photoCollectionDidLogOut(_ photoCollectionController: PhotoCollectionController)
}
