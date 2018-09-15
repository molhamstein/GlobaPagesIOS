//
//  UIView.swift
//  BrainSocket Code base
//
//  Created by BrainSocket on 6/13/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setImageForURL(_ url: String, placeholder: UIImage?) {
        self.image = placeholder
        self.kf.indicatorType = .activity
        self.kf.setImage(with: URL(string: "http://\(url)")!, placeholder: image)
    }
    
}
