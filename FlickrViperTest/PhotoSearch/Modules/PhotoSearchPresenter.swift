//
//  Created by ViXette on 27/07/2018.
//

import UIKit


class PhotoSearchPresenter {
	
	weak var view: PhotoSearchVCInput!
	
	var interactor: PhotoSearchInteractorInput!
	
	var router: PhotoSearchRoutingInput!

}

// MARK: - PhotoSearchInteractorOutput
extension PhotoSearchPresenter: PhotoSearchInteractorOutput {
	
	///
	func providedPhotos (_ photos: [FlickrPhotoModel], totalPages: Int) {
		view.hideWaitingView()
		
		view.displayFetchedPhotos(photos, totalPages: totalPages)
	}
	
	///
	func serviceError (_ error: NSError) {
		view.displayErrorView(error.localizedDescription)
	}
	
}

// MARK: - PhotoSearchVCOutput
extension PhotoSearchPresenter: PhotoSearchVCOutput {
	
	/// Presenter tells to Interactor aboout VC needs of photos
	func fetchPhotos (_ searchTag: String, page: NSInteger) {
		if view.getTotalPhotoCount() == 0 {
			view.showWaitingView()
		}
		interactor.fetchAllPhotosFromDataManager(searchTag, page: page)
	}
	
	///
	func navigateToPhotoDetail() {
		router.navigateToPhotoDetail()
	}
	
	///
	func passDataToDetail (_ segue: UIStoryboardSegue) {
		router.passDataToDetail(segue)
	}
	
}
