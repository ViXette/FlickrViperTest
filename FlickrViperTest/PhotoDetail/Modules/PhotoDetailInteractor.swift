//
//  Created by ViXette on 27/07/2018.
//

import UIKit


protocol PhotoDetailInteractorOutput: class {
	
	func getLoadedPhoto (image: UIImage)
	
}

///
protocol PhotoDetailInteractorInput: class {
	
	func configurePhoto (_ photo: FlickrPhotoModel)
	
	func getTitle () -> String
	
}

///
class PhotoDetailInteractor {
	
	weak var presenter: PhotoDetailInteractorOutput!
	
	var imageDataManager: FlickrPhotoLoadProtocol!
	
	var photo: FlickrPhotoModel?
	
	///
	private func loadImageFromURL () {
		imageDataManager.loadImageFromUrl(photo?.largePhotoURL as! URL) {
			(image, data, error, finished) in
			
			guard let image = image else {
				return
			}
			
			self.presenter.getLoadedPhoto(image: image)
		}
	}
	
}

// MARK: - PhotoDetailInteractorInput
extension PhotoDetailInteractor: PhotoDetailInteractorInput {
	
	///
	func configurePhoto (_ photo: FlickrPhotoModel) {
		self.photo = photo
		
		loadImageFromURL()
	}
	
	///
	func getTitle() -> String {
		return photo?.title ?? ""
	}
	
}
