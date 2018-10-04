//
//  Created by ViXette on 27/07/2018.
//

import UIKit


class PhotoDetailAssembly {
	
	static let shared = PhotoDetailAssembly()
	
	///
	func build (_ viewController: PhotoDetailVC) {
		let APIDataManager = FlickrDataManager()
		let presenter = PhotoDetailPresenter()
		let interactor = PhotoDetailInteractor()
		
		viewController.presenter = presenter
		interactor.presenter = presenter
		interactor.imageDataManager = APIDataManager
		
		presenter.view = viewController
		presenter.interactor = interactor
	}
	
}
