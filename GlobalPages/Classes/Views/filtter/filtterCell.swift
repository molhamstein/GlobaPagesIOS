//
//  filtterCell.swift
//  GlobalPages
//
//  Created by Nour  on 6/8/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit


protocol filterCellProtocol {
    func removeFilter(filter:categoriesFilter)
}

class filtterCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    
    var delegate:filterCellProtocol?
    
    var filter:categoriesFilter?{
        didSet{
            guard let filter = filter else{return}
            if let Ftitle = filter.title{
                self.title = Ftitle
            }
        }
    }
    
    var filtervalue:filterValues?
    
    var title:String = ""{
        didSet{
            self.titleLabel.text = title
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = AppFonts.normal
        titleLabel.sizeToFit()
        
       
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutIfNeeded()
        
        self.makerounded()
        self.addShadow()
    }

    @IBAction func clear(_ sender: UIButton) {
        delegate?.removeFilter(filter: self.filter!)
    }
    
    
  
}




