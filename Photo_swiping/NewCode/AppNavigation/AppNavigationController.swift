import Foundation
import UIKit
import SVProgressHUD

class AppNavigationController: UINavigationController {
    
    let authorizationScreen = AuthorizationScreenController()
    
    init() {
        super.init(rootViewController: authorizationScreen)
        self.navigationBar.isHidden = true
        self.interactivePopGestureRecognizer?.isEnabled = false
        authorizationScreen.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppNavigationController: AuthorizationScreenControllerDelegate {
    
    func authorizationScreen(_ authorizationScreen: AuthorizationScreenController, passwordIncorrect alert: UIAlertController) {
        present(alert, animated: true)
    }
    
    func authorizationScreen(_ authorizationScreen: AuthorizationScreenController, login: User) {
        let photoCollection = PhotoCollectionController()
        photoCollection.delegate = self
        self.pushViewController(photoCollection, animated: true)
    }
    
    
}

extension AppNavigationController: PhotoCollectionControllerDelegate {
   
    func photoCollection(_ photoCollectionController: PhotoCollectionController, didSelectPhoto contentIndex: Int, from allContent: [Content]) {
        let detailScreen = DetailPhotoScreenController(currentContentIndex: contentIndex, allContent: allContent)
        detailScreen.delegate = self
        pushViewController(detailScreen, animated: true)
    }
    func photoCollectionDidLogOut(_ photoCollectionController: PhotoCollectionController) {
        popViewController(animated: true)
    }
    
}

extension AppNavigationController: DetailPhotoScreenControllerDelegate {
    func detailPhotoScreen(_ detailPhotoScreenController: DetailPhotoScreenController, deleteIndexContent: Int) {
        popViewController(animated: true)
        (topViewController as? PhotoCollectionController)?.ignoreDefaultContentList = deleteIndexContent
    }
    
    func detailPhotoScreenBackPressed(_ detailPhotoScreenController: DetailPhotoScreenController) {
        popViewController(animated: true)
    }
}


