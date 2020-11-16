//
//  AdsDescriptionViewController.swift
//  GlobalPages
//
//  Created by Nour  on 7/1/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import Lightbox
import Firebase

class AdsDescriptionViewController: AbstractController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contactBottomButton: XUIButton!
    @IBOutlet weak var btnLeftArrow: UIButton!
    @IBOutlet weak var btnRightArrow: UIButton!
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
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tagView: GradientView!
    @IBOutlet weak var categoryView: GradientView!
    @IBOutlet weak var tagViewWidthConstraint: XNSLayoutConstraint!
    @IBOutlet weak var subCategoryWidthConstraint: XNSLayoutConstraint!
    

    // contact view
    @IBOutlet weak var contactsBGView: UIView!
    @IBOutlet weak var contactsMiddleView: UIView!
    @IBOutlet weak var phone1TitleLabel: XUILabel!
    @IBOutlet weak var phone1Label: UILabel!
    @IBOutlet weak var phone1Button: UIButton!
    @IBOutlet weak var callNowBottomButton: XUIButton!


    var tagViewWidth:CGFloat = 0{
        
        didSet{
            let newWidth = min(self.view.frame.width,tagViewWidth)
            tagViewWidthConstraint.setNewConstant(newWidth)
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutSubviews()
            }, completion: nil)
        }
        
    }
    
    var subTagViewWidth:CGFloat = 0{
        
        didSet{
            let newWidth = min(self.view.frame.width,subTagViewWidth)
            subCategoryWidthConstraint.setNewConstant(newWidth)
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutSubviews()
            }, completion: nil)
        }
        
    }
    
    var images:[Media] = []
    var SkImages:[SKPhoto] = []
    var cellID = "ImageCell"
    var currentImagesIndex = 0
    var post:Post?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let post = post  else {
            backButtonAction(self)
            return
        }

        if let value = post.creationDate{dateLabel.text = DateHelper.getStringFromDate(value)}
        if let value = post.description{descriptionTextView.text = value}
//        if let value = post. areaLabel.text
        if let value = post.title{titleLabel.text = value}
        if let value = post.subCategory?.title{subCategoryLabel.text = value}
        if let value = post.category?.title{categoryLable.text = value}
        if let value = post.media {images = value}
        if let city = post.city , let value = city.title{ self.cityLabel.text = value}
        if let city = post.location , let value = city.title{ self.areaLabel.text = value}

        if let phone1 = post.owner?.phoneNumber {
            self.phone1Label.text = phone1
            
        }
        Analytics.logEvent("ad_details_opened", parameters: [:])
    }
    
    override func customizeView() {
        
        let nib = UINib(nibName: cellID, bundle: nil)
        imageCollectionView.register(nib, forCellWithReuseIdentifier: cellID)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        // fonts
        self.dateTitleLabel.font = AppFonts.smallBold
        self.dateLabel.font = AppFonts.normalBold
        self.categoryLable.font = AppFonts.normalBold
        self.subCategoryLabel.font = AppFonts.smallBold
        self.titleLabel.font = AppFonts.normalBold
        self.cityTitleLable.font = AppFonts.smallBold
        self.cityLabel.font = AppFonts.normalBold
        self.areaLabel.font = AppFonts.normal
        self.contactButton.titleLabel?.font = AppFonts.normalBold
        self.contactBottomButton.titleLabel?.font  = AppFonts.normalBold
        self.callNowBottomButton.titleLabel?.font  = AppFonts.normalBold
        self.descriptionTextView.font = AppFonts.normalBold
        self.descriptinTitleLabel.font = AppFonts.normalBold
        
        //colors
        self.headerView.backgroundColor = AppColors.grayXDark
        
         //shadow
        self.contactBottomButton.dropShadow()
        self.callNowBottomButton.dropShadow()
        self.containerView.dropShadow()
        self.tagView.dropShadow()
        self.categoryView.dropShadow()
        
        // page Controller
        self.pageController.numberOfPages = images.count
        
        
        // change nav bar tint color for back button
        self.navigationController?.navigationBar.tintColor = .white
        
        self.btnLeftArrow.dropShadow()
        self.btnRightArrow.dropShadow()

        
    }
    
    override func viewDidLayoutSubviews() {
        // change the page controlelr indecator size and alpha
        pageController.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
            $0.alpha  = 0.5
        }
        
        self.showNavBackButton = true
        self.tagViewWidth = (self.categoryLable.text?.getLabelWidth(font: AppFonts.normalBold))! + CGFloat(54)
        self.subTagViewWidth = (self.subCategoryLabel.text?.getLabelWidth(font: AppFonts.smallBold))! + CGFloat(32)
    }

    override func backButtonAction(_ sender: AnyObject) {
        self.popOrDismissViewControllerAnimated(animated: true)
    }

    func callPhone(phone:String){
        guard let number = URL(string: "tel://" + phone) else { return }
        UIApplication.shared.openURL(number)
    }
    
}

// MARK:- @IBAction
extension AdsDescriptionViewController {
    @IBAction func nextImage_left(_ sender: UIButton) {
        if currentImagesIndex == 0 {
            return
        }else {
            self.imageCollectionView.scrollToItem(at: IndexPath(row: self.currentImagesIndex - 1 , section: 0), at: .left, animated: true)
            self.currentImagesIndex -= 1
        }

    }
    
    @IBAction func nextImage_right(_ sender: UIButton) {
        if currentImagesIndex >= (self.images.count - 1) {
            return
        }else {
            self.imageCollectionView.scrollToItem(at: IndexPath(row: self.currentImagesIndex + 1 , section: 0), at: .left, animated: true)
            self.currentImagesIndex += 1
        }
    }
    
    @IBAction func close(_ sender: UIButton) {
        self.popOrDismissViewControllerAnimated(animated: true)
    }
    
    @IBAction func showContactsView(_ sender: UIButton) {
        self.contactsBGView.isHidden = false
        self.contactsMiddleView.animateIn(mode: .animateInFromBottom, delay: 0.2)
        Analytics.logEvent("show_ad_contact", parameters: [:])
    }

    @IBAction func hideContactsView(_ sender: UITapGestureRecognizer) {
        self.contactsBGView.isHidden = true
    }
    
    @IBAction func callPhone1(_ sender: UIButton) {
        if let phone1 = post?.owner?.phoneNumber {
            callPhone(phone:phone1)
        }
    }
}

extension AdsDescriptionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count > 0 {
            return images.count
        }
        return 1
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCell
        if images.count > 0 {
            cell.media = images[indexPath.item]
        }
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == imageCollectionView {
            if self.images.count > 0 {
                ActionShowMediaInFullScreen.execute(pageDelegate: self, dismissalDelegate: self, media: self.images, currentPage: indexPath.row)
            }
        }
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

// MARK:- LightBoxDelegate
extension AdsDescriptionViewController: LightboxControllerDismissalDelegate, LightboxControllerPageDelegate {
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        
    }
}


// page controller delegates

extension AdsDescriptionViewController{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //print("x \(targetContentOffset.pointee.x)")
        let pagenumber = Int(abs(targetContentOffset.pointee.x) / view.frame.width)
        self.pageController.currentPage = pagenumber
    }

}
