//
//  Created by ViXette on 27/07/2018.
//

import Foundation

///
struct FlickrPhotoModel {
	
	let photoId: String
	
	let farm: Int
	
	let secret: String
	
	let server: String
	
	let title: String
	
	///
	var photoURL: NSURL {
		return getUrl()
	}
	
	///
	var largePhotoURL: NSURL {
		return getUrl(forSize: "b")
	}
	
	///
	private func getUrl(forSize size: String = "m") -> NSURL {
		return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_\(size).jpg")!
	}
	
}
