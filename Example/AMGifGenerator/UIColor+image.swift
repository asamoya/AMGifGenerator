//
//  Copyright (c) 2021 kaname ohara All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    func image(size: CGSize = CGSize(width: 300, height: 300)) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
