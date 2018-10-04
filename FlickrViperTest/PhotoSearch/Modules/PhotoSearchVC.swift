//
//  Created by ViXette on 27/07/2018.
//

import UIKit

///
protocol PhotoSearchVCOutput: class {
	
	func fetchPhotos (_ searchTag: String, page: NSInteger)
	
	func navigateToPhotoDetail ()
	
	func passDataToDetail (_ segue: UIStoryboardSegue)
	
}

///
protocol PhotoSearchVCInput: class {
	
	func displayFetchedPhotos (_ photos: [FlickrPhotoModel], totalPages: Int)
	
	func displayErrorView (_ errorMessage: String)
	
	func showWaitingView ()
	
	func hideWaitingView ()
	
	func getTotalPhotoCount () -> Int
	
}

///
class PhotoSearchVC: UIViewController {
	
	@IBOutlet weak var photoCollectionView: UICollectionView!
	
	var presenter: PhotoSearchVCOutput!
	
	var photos: [FlickrPhotoModel] = []
	
	var currentPage = 1
	var totalPages = 1
	
	///
	override func awakeFromNib() {
		super.awakeFromNib()
		
		PhotoSearchAssembly.shared.build(self)
	}
	
	///
	override func viewDidLoad() {
		super.viewDidLoad()
		
		performSearchWith("Party")
	}
	
	///
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		self.title = "Party"
	}
	
	///
	func performSearchWith (_ searchText: String) {
		presenter.fetchPhotos(searchText, page: currentPage)
	}
	
	///
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		presenter.passDataToDetail(segue)
	}
	
}

// MARK: - PhotoSearchVCInput

///
extension PhotoSearchVC: PhotoSearchVCInput {
	
	///
	func displayFetchedPhotos (_ photos: [FlickrPhotoModel], totalPages: Int) {
		self.photos.append(contentsOf: photos)
		self.totalPages = totalPages
		
		DispatchQueue.main.async {
			self.photoCollectionView.reloadData()
		}
	}
	
	///
	func displayErrorView (_ errorMessage: String) {
		let refreshAlert = UIAlertController(title: "Error", message: "Try latter", preferredStyle: .alert)
		refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
			action in
			
			refreshAlert.dismiss(animated: true, completion: nil)
		}))
		
		present(refreshAlert, animated: true, completion: nil)
	}
	
	// MARK: - ActivityView
	
	///
	func showWaitingView () {
		let alert = UIAlertController(title: nil, message: waitingKey, preferredStyle: .alert)
		
		alert.view.tintColor = .black
		
		let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
		loadingIndicator.hidesWhenStopped = true
		loadingIndicator.activityIndicatorViewStyle = .gray
		loadingIndicator.startAnimating()
		
		alert.view.addSubview(loadingIndicator)
		
		present(alert, animated: true, completion: nil)
	}
	
	///
	func hideWaitingView () {
		dismiss(animated: true, completion: nil)
	}
	
	///
	func getTotalPhotoCount () -> Int {
		return photos.count
	}
	
}

// MARK: - DataSource

///
extension PhotoSearchVC: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	///
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return currentPage < totalPages ? photos.count + 1 :  photos.count
	}
	
	///
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if indexPath.row < photos.count {
			return photoItemCell(collectionView, cellForItemAt: indexPath)
		} else {
			currentPage += 1
			
			performSearchWith("Party")
			
			return loadingItemCell(collectionView, cellForItemAt: indexPath)
		}
	}
	
	///
	private func photoItemCell (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCell.defaultReuseIdentifier, for: indexPath) as! PhotoItemCell
		
		let flickrPhoto = photos[indexPath.row]
		
		cell.photoImageView.alpha = 0
		cell.photoImageView.sd_setImage(with: flickrPhoto.photoURL as URL) {
			(image, error, cache, url) in
			
			cell.photoImageView.image = image
			
			UIView.animate(withDuration: 0.2, animations: {
				cell.photoImageView.alpha = 1
			})
		}
		
		return cell
	}
	
	///
	private func loadingItemCell (_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoLoadingCell.defaultReuseIdentifier, for: indexPath) as! PhotoLoadingCell
		
		return cell
	}
	
}

// MARK: - Delegate

///
extension PhotoSearchVC: UICollectionViewDelegate {
	
	///
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter.navigateToPhotoDetail()
	}
	
}

///
extension PhotoSearchVC: UICollectionViewDelegateFlowLayout {

	///
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var itemSize: CGSize
		let length = UIScreen.main.bounds.width / 3 - 1
		
		if indexPath.row < photos.count{
			itemSize = CGSize(width: length, height: length)
		} else {
			itemSize = CGSize(width: photoCollectionView.bounds.width, height: 50.0)
		}
		
		return itemSize
	}
	
	///
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 0.5
	}
	
	///
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 0.5
	}
}
