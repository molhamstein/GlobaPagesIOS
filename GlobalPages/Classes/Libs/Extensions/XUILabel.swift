//
//  XUILabel.swift
//  Wardah
//
//  Created by Nour  on 12/22/17.
//  Copyright © 2017 AlphaApps. All rights reserved.
//

import Foundation
import UIKit

class XUILabel:UILabel{

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        if self.tag == -1{
//            self.font = AppFonts.xSmall
//        }else if self.tag > -1{
//            self.font = AppFonts.normal
//        }else{
//            self.font = UIFont.systemFont(ofSize: 10)
//        }
//        
        
            self.text = self.text?.localized
       
    }

}



//extension UILabel {
//    func textWidth() -> CGFloat {
//        return UILabel.textWidth(label: self)
//    }
//    
//    class func textWidth(label: UILabel) -> CGFloat {
//        return textWidth(label: label, text: label.text!)
//    }
//    
//    class func textWidth(label: UILabel, text: String) -> CGFloat {
//        return textWidth(font: label.font, text: text)
//    }
//    
//    class func textWidth(font: UIFont, text: String) -> CGFloat {
//        let myText = text as NSString
//        
//        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
//        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
//        return ceil(labelSize.width)
//    }
//}

