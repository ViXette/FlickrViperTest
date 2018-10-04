//
//  Created by ViXette on 27/07/2018.
//

import UIKit

///
class PhotoSearchAssembly {
	
	static let shared = PhotoSearchAssembly()

	///
	func build (_ viewController: PhotoSearchVC) {
		let APIDataManager = FlickrDataManager()
		let interactor = PhotoSearchInteractor()
		let presenter = PhotoSearchPresenter()
		let router = PhotoSearchRouting()
		
		presenter.view = viewController
		viewController.presenter = presenter
		
		interactor.presenter = presenter
		presenter.interactor = interactor
		presenter.router = router
		interactor.APIDataManager = APIDataManager
		
		router.viewController = viewController
	}
	
}
