//
//  Created by ViXette on 27/07/2018.
//

import Foundation
import SDWebImage

///
protocol FlickrPhotoSearchProtocol: class {
	
	func fetchPhotosFor (searchText: String, page: NSInteger, completion: @escaping (NSError?, NSInteger, [FlickrPhotoModel]?) -> Void) -> Void
	
}

///
protocol FlickrPhotoLoadProtocol {

	func loadImageFromUrl (_ url: URL, completion: @escaping (UIImage?, Data?, Error?, Bool) -> Void)
	
}

///
class FlickrDataManager: FlickrPhotoSearchProtocol {
	
	///
	struct Errors {
		
		static let invalidAccessErrorCode = 100
		
	}
	
	///
	struct FlickAPIMetadataKeys {
		
		static let failureStatusCode = "code"
		
	}
	
	///
	struct FlickrAPI {
		
		static let APIKey = "adbc42078734674ba224ba0431047a9a"
		
		static let tagsSearchFormat = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&page=%i&format=json&nojsoncallback=1"
		
	}
	
	///
	func fetchPhotosFor (searchText: String, page: NSInteger, completion: @escaping (NSError?, NSInteger, [FlickrPhotoModel]?) -> Void) -> Void {
		let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
	
		let photosURL = String(
			format: FlickrAPI.tagsSearchFormat,
			arguments: [
				FlickrAPI.APIKey,
				escapedSearchText,
				page
			]
		)
		
		let url = NSURL(string: photosURL)!
		let request = NSURLRequest(url: url as URL)
		
		URLSession.shared.dataTask(with: request as URLRequest) {
			(data, response, error) in
			
			if error != nil {
				print("Error: \(error.debugDescription)")
				
				completion(error as NSError?, 0, nil)
				
				return
			}
			
			do {
				let resultsDict = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]
				
				guard let results = resultsDict else { return }
				
				if let statusCode = results[FlickAPIMetadataKeys.failureStatusCode] as? Int,
					statusCode == Errors.invalidAccessErrorCode
				{
					let invalidAccessError = NSError(domain: "FlickrAPIDomain", code: statusCode, userInfo: nil)
					
					completion(invalidAccessError, 0, nil)
					
					return
				}
				
				guard let photosContainer = results["photos"] as? NSDictionary,
						let totalPageCountString = photosContainer["total"] as? String,
						let totalPageCount = NSInteger(totalPageCountString),
						let photosArray = photosContainer["photo"] as? [NSDictionary]
				else { return }
				
				let flickrPhotos: [FlickrPhotoModel] = photosArray.map({
					photoDict -> FlickrPhotoModel in
					
					let flickrPhoto = FlickrPhotoModel(
						photoId: photoDict["id"] as? String ?? "",
						farm: photoDict["farm"] as? Int ?? 0,
						secret: photoDict["secret"] as? String ?? "",
						server: photoDict["server"] as? String ?? "",
						title: photoDict["title"] as? String ?? ""
					)
					
					return flickrPhoto
				})
				
				completion(nil, totalPageCount, flickrPhotos)
				
			} catch let error as NSError {
				print("Error at parsing JSON: \(error.localizedDescription)")
				
				completion(error, 0, nil)
				
				return
			}
		}.resume()
	}
	
}

///
extension FlickrDataManager: FlickrPhotoLoadProtocol {
	
	///
	func loadImageFromUrl (_ url: URL, completion: @escaping (UIImage?, Data?, Error?, Bool) -> Void) {
		SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: .continueInBackground, progress: nil, completed: {
			(image, data, error, finished) in
			
			completion(image, data, error, finished)
		})
	}
	
}
