//
//  NearByFilterViewController.swift
//  GlobalPages
//
//  Created by Nour  on 7/23/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class NearByFilterViewController: AbstractController {

    
    
    @IBOutlet weak var infoLabel: XUILabel!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var filtterCollectionView: UICollectionView!
    
    
    
    var filtterCellId = "filterCell2"
    var filters:[String] = ["Real State","Cars","Entertaiment","Jobs","Real State","Cars","Entertaiment","Jobs"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
         self.navigationController?.navigationBar.tintColor = .white
    }
    
    
    override func customizeView() {
        self.showNavBackButton = true
    
            // fonts
        self.infoLabel.font = AppFonts.big
        self.categoryTitleLabel.font = AppFonts.big
        
          let nib = UINib(nibName: filtterCellId, bundle: nil)
        self.filtterCollectionView.register(nib, forCellWithReuseIdentifier: filtterCellId)
    }
    
    override func buildUp() {
        self.filtterCollectionView.animateIn(mode: .animateInFromRight, delay: 0.2)
    }
    
    
    
    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
}


extension NearByFilterViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filtterCollectionView {
            return filters.count
            
        }
      
        return 0
    }
    
    
    
    // load collecton view cells
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        if collectionView == filtterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: filtterCellId, for: indexPath) as! filterCell2
            cell.title = filters[indexPath.item]
            
            return cell
            
        }
        
        return UICollectionViewCell()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == filtterCollectionView {
//            ActionShowFilters.execute()
//        }
        
    }
}

// setup Cell and header Size

extension NearByFilterViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if collectionView == filtterCollectionView {
            
            return CGSize(width: filters[indexPath.item].getLabelWidth(font: AppFonts.normal) + 36, height: (47.5 * ScreenSizeRatio.smallRatio) - 16)
        }
        
        return CGSize(width:0, height: 0)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        if collectionView == filtterCollectionView{
            return 8
        }
        return 0
    }
    
    
    
}

