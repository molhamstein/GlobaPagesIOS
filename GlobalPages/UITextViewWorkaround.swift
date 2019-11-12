//
//  UITextViewWorkaround.swift
//  GlobalPages
//
//  Created by Abd Hayek on 11/9/19.
//  Copyright © 2019 Abd Hayek. All rights reserved.
//

import UIKit

/**
 This class fix the bug in xcode 11.2 when trying to implement a UITextView as a subcalss in storyboard, the following function should be called in AppDelegate class
 */
@objc
class UITextViewWorkaround : NSObject {

    static func executeWorkaround() {
        if #available(iOS 13.2, *) {
        } else {
            let className = "_UITextLayoutView"
            let theClass = objc_getClass(className)
            if theClass == nil {
                let classPair: AnyClass? = objc_allocateClassPair(UIView.self, className, 0)
                objc_registerClassPair(classPair!)
            }
        }
    }

}
