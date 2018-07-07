//
//  AdsDescriptionViewController.swift
//  GlobalPages
//
//  Created by Nour  on 7/1/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class AdsDescriptionViewController: AbstractController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contactBottomButton: XUIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptinTitleLabel: UILabel!
    @IBOutlet weak var contactButton: XUIButton!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var areaTitleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTitleLable: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTitleLabel: XUILabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var categoryLable: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    
    
    
    var cellID = "ImageCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showNavBackButton = true
        
        let nib = UINib(nibName: cellID, bundle: nil)
        imageCollectionView.register(nib, forCellWithReuseIdentifier: cellID)
    
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    override func customizeView() {
        
        
        // fonts
        self.dateTitleLabel.font = AppFonts.smallBold
        self.dateLabel.font = AppFonts.normalBold
        self.categoryLable.font = AppFonts.normalBold
        self.subCategoryLabel.font = AppFonts.normalBold
        self.titleLabel.font = AppFonts.normalBold
        self.cityTitleLable.font = AppFonts.smallBold
        self.cityLabel.font = AppFonts.normalBold
        self.areaLabel.font = AppFonts.smallBold
        self.contactButton.titleLabel?.font = AppFonts.normalBold
        self.contactBottomButton.titleLabel?.font  = AppFonts.normalBold
        self.descriptionTextView.font = AppFonts.normalBold
        
        // page Controller
        self.pageController.numberOfPages = 3
        
    }
    
    override func viewDidLayoutSubviews() {
        // change the page controlelr indecator size and alpha
        pageController.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
            $0.alpha  = 0.5
        }
    }
    
    
    
    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    


}



extension AdsDescriptionViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCell
        print(cell.frame.height)
        return cell
    }
    
}

extension AdsDescriptionViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight + 64)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}



// page controller delegates

extension AdsDescriptionViewController{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("x \(targetContentOffset.pointee.x)")
        let pagenumber = Int(abs(targetContentOffset.pointee.x) / view.frame.width)
        self.pageController.currentPage = pagenumber
    }
    
    
    
}
