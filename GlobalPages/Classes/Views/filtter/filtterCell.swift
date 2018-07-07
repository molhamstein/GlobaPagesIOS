//
//  filtterCell.swift
//  GlobalPages
//
//  Created by Nour  on 6/8/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit


protocol filterCellProtocol {
    func removeFilter(tag:Int)
}

class filtterCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    var delegate:filterCellProtocol?
    
    var title:String = ""{
        didSet{
            self.titleLabel.text = title
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = AppFonts.normal
        titleLabel.sizeToFit()
        self.perform(#selector(setupView), with: nil, afterDelay: 0.3)
       
    }

    func setupView(){
        self.makerounded()
        self.addShadow()
     
    }

    @IBAction func clear(_ sender: UIButton) {
        delegate?.removeFilter(tag:self.tag)
        
    }
    
    
  
}




