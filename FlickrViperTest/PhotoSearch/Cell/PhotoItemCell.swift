//
//  Created by ViXette on 05/08/2018.
//

import UIKit


class PhotoItemCell: UICollectionViewCell, ReuseIdentifierProtocol {
	
	@IBOutlet weak var photoImageView: UIImageView!
	
	///
	override func awakeFromNib() {
		self.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
	}
	
}
