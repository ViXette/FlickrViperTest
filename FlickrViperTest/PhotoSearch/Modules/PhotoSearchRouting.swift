//
//  Created by ViXette on 27/07/2018.
//

import UIKit


protocol PhotoSearchRoutingInput {
	
	func navigateToPhotoDetail ()
	
	func passDataToDetail (_ segue: UIStoryboardSegue)
	
}

///
class PhotoSearchRouting {
	
	weak var viewController: PhotoSearchVC!
	
}

// MARK: - PhotoSearchRoutingInput
extension PhotoSearchRouting: PhotoSearchRoutingInput {
	
	///
	func navigateToPhotoDetail () {
		viewController.performSegue(withIdentifier: "ShowDetailVC", sender: nil)
	}
	
	///
	func passDataToDetail (_ segue: UIStoryboardSegue) {
		if segue.identifier == "ShowDetailVC" {
			if let selectedIndexPath = viewController.photoCollectionView.indexPathsForSelectedItems?.first {
				let selectedPhoto = viewController.photos[selectedIndexPath.item]
				
				let photoDetailVC = segue.destination as! PhotoDetailVC
				
				photoDetailVC.presenter.saveSelectedPhoto(selectedPhoto)
			}
		}
	}
	
}
