//
//  Created by ViXette on 27/07/2018.
//

import UIKit

protocol PhotoDetailVCInput: class {
	
	func setPhoto (_ image: UIImage)
	
	func setTitle (_ text: String)
	
}

///
protocol PhotoDetailVCOutput: class {
	
	func saveSelectedPhoto (_ photo: FlickrPhotoModel)
	
}

///
class PhotoDetailVC: UIViewController {
	
	var presenter: PhotoDetailVCOutput!
	
	@IBOutlet weak var image: UIImageView!
	
	@IBOutlet weak var titleView: UILabel!
	
	///
	override func awakeFromNib() {
		super.awakeFromNib()
		
		PhotoDetailAssembly.shared.build(self)
	}
	
	///
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
}

// MARK: - PhotoDetailVCInput
extension PhotoDetailVC: PhotoDetailVCInput {
	
	///
	func setPhoto (_ image: UIImage) {
		self.image.image = image
	}
	
	///
	func setTitle (_ text: String) {
		self.titleView.text = text
	}
	
}
