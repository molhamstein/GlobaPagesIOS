//
//  AdsDescriptionViewController.swift
//  GlobalPages
//
//  Created by Nour  on 7/1/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit
import SKPhotoBrowser

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
    @IBOutlet weak var phone2TitleLabel: XUILabel!
    @IBOutlet weak var phone2Label: UILabel!
    @IBOutlet weak var phone2Button: UIButton!
    @IBOutlet weak var faxTitleLabel: XUILabel!
    @IBOutlet weak var faxLabel: UILabel!


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

        if let phone1 = post.phone1 {self.phone1Label.text = phone1}
        if let phone2 = post.phone2 {self.phone2Label.text = phone2}
        if let fax = post.fax {self.faxLabel.text = fax}
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
        self.descriptionTextView.font = AppFonts.normalBold
        self.descriptinTitleLabel.font = AppFonts.normalBold
        
        //colors
        self.headerView.backgroundColor = AppColors.grayXDark
        
         //shadow
        self.contactBottomButton.dropShadow()
        self.containerView.dropShadow()
        self.tagView.dropShadow()
        self.categoryView.dropShadow()
        
        // page Controller
        self.pageController.numberOfPages = images.count
        
        
        // change nav bar tint color for back button
        self.navigationController?.navigationBar.tintColor = .white
        
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
    
    
    @IBAction func close(_ sender: UIButton) {
        self.popOrDismissViewControllerAnimated(animated: true)
    }

    override func backButtonAction(_ sender: AnyObject) {
        self.popOrDismissViewControllerAnimated(animated: true)
    }

// contacts view actions

    @IBAction func showContactsView(_ sender: UIButton) {
        self.contactsBGView.isHidden = false
        self.contactsMiddleView.animateIn(mode: .animateInFromBottom, delay: 0.2)
    }

    @IBAction func hideContactsView(_ sender: UITapGestureRecognizer) {
        self.contactsBGView.isHidden = true
    }
    @IBAction func callPhone1(_ sender: UIButton) {
        if let phone1 = post?.phone1 {
            callPhone(phone:phone1)
        }
    }

    @IBAction func callPhone2(_ sender: UIButton) {
        if let phone2 = post?.phone2{
            callPhone(phone:phone2)
        }
    }

    func callPhone(phone:String){
        guard let number = URL(string: "tel://" + phone) else { return }
        UIApplication.shared.openURL(number)
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
            let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
            if cell.media?.type == .video {
                if var url = cell.media?.fileUrl {
                    if !url.contains(find: "http://") {
                        url = "http://" + url
                    }
                    ActionPlayVideo.execute(controller: self, url: url)
                }
            }else {
                if let image = cell.iamgeView.image {
                    self.showFullScreenImage(image: image)
                }
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



// page controller delegates

extension AdsDescriptionViewController{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("x \(targetContentOffset.pointee.x)")
        let pagenumber = Int(abs(targetContentOffset.pointee.x) / view.frame.width)
        self.pageController.currentPage = pagenumber
    }
    
    
    
}
