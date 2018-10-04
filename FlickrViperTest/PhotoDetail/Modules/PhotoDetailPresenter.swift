//
//  Created by ViXette on 27/07/2018.
//

import UIKit


class PhotoDetailPresenter {
	
	weak var view: PhotoDetailVCInput!
	
	var interactor: PhotoDetailInteractorInput!
	
}

// MARK: - PhotoDetailInteractorOutput
extension PhotoDetailPresenter: PhotoDetailInteractorOutput {
	
	///
	func getLoadedPhoto(image: UIImage) {
		view.setPhoto(image)
		
		view.setTitle(interactor.getTitle())
	}
	
}

// MARK: - PhotoDetailVCOutput
extension PhotoDetailPresenter: PhotoDetailVCOutput {
	
	///
	func saveSelectedPhoto (_ photo: FlickrPhotoModel) {
		self.interactor.configurePhoto(photo)
	}
	
}
