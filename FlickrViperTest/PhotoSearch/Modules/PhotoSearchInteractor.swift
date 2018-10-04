//
//  Created by ViXette on 27/07/2018.
//

import UIKit

///
protocol PhotoSearchInteractorInput: class {
	
	func fetchAllPhotosFromDataManager (_ searchTag: String, page: NSInteger)
	
}

///
protocol PhotoSearchInteractorOutput: class {

	func providedPhotos (_ photos: [FlickrPhotoModel], totalPages: Int)
	
	func serviceError (_ error: NSError)
	
}

///
class PhotoSearchInteractor {
	
	weak var presenter: PhotoSearchInteractorOutput!
	
	var APIDataManager: FlickrPhotoSearchProtocol!

}

///
extension PhotoSearchInteractor: PhotoSearchInteractorInput {
	
	///
	func fetchAllPhotosFromDataManager (_ searchTag: String, page: NSInteger) {
		APIDataManager.fetchPhotosFor(searchText: searchTag, page: page) {
			(error, totalPages, flickrPhotos) in
			
			if let flickrPhotos = flickrPhotos {
				self.presenter.providedPhotos(flickrPhotos, totalPages: totalPages)
				
				print(flickrPhotos)
			} else if let error = error {
				print(error)
				
				self.presenter.serviceError(error)
			}
		}
	}
	
}
