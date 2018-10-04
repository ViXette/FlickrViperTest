//
//  Created by ViXette on 05/08/2018.
//

import UIKit


public protocol ReuseIdentifierProtocol: class {
	
	static var defaultReuseIdentifier: String { get }
	
}

///
public extension ReuseIdentifierProtocol where Self: UIView {
	
	static var defaultReuseIdentifier: String {
		return NSStringFromClass(self).components(separatedBy: ".").last!
	}
	
}
