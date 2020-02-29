//
//  MarketProductDetailsViewController.swift
//  GlobalPages
//
//  Created by Abd Hayek on 1/5/20.
//  Copyright © 2020 GlobalPages. All rights reserved.
//

import UIKit
import Lightbox

class MarketProductDetailsViewController: AbstractController {
    
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblSubCategory: UILabel!
    @IBOutlet weak var lblDateTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCityTitle: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblAreaTitle: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDescriptionTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblGalleryTitle: UILabel!
    @IBOutlet weak var lblSkillsTitle: UILabel!
    @IBOutlet weak var btnDeactiveProduct: UIButton!
    
    @IBOutlet weak var btnTopContact: XUIButton!
    @IBOutlet weak var btnBottomContact: XUIButton!
    
    @IBOutlet weak var skillsCollectionViewConstant: NSLayoutConstraint!
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var scrollViewContent: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // contact view
    @IBOutlet weak var contactsBGView: UIView!
    @IBOutlet weak var contactsMiddleView: UIView!
    @IBOutlet weak var phone1TitleLabel: XUILabel!
    @IBOutlet weak var phone1Label: UILabel!
    @IBOutlet weak var phone1Button: UIButton!
    @IBOutlet weak var callNowBottomButton: XUIButton!
    
    public var marketProduct: MarketProduct?
    fileprivate var images: [Media] = []
    fileprivate var cellID = "ImageCell"
    fileprivate var currentImagesIndex = 0
    fileprivate var tags: [Tag] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.scrollView.isUserInteractionEnabled = true
        self.scrollViewContent.isUserInteractionEnabled = true
        
        

        
    }

    
    override func customizeView() {
        lblCategory.font = AppFonts.normalBold
        lblSubCategory.font = AppFonts.normalSemiBold
        lblDateTitle.font = AppFonts.smallSemiBold
        lblDate.font = AppFonts.normalSemiBold
        lblTitle.font = AppFonts.normalSemiBold
        lblCityTitle.font = AppFonts.smallSemiBold
        lblCity.font = AppFonts.normalSemiBold
        lblAreaTitle.font = AppFonts.smallSemiBold
        lblSkillsTitle.font = AppFonts.normalBold
        lblArea.font = AppFonts.normalSemiBold
        lblPriceTitle.font = AppFonts.smallSemiBold
        lblPrice.font = AppFonts.normalSemiBold
        lblDescriptionTitle.font = AppFonts.normalBold
        lblDescription.font = AppFonts.normal
        lblGalleryTitle.font = AppFonts.normalBold
        phone1Label.font = AppFonts.normalBold
        btnDeactiveProduct.titleLabel?.font = AppFonts.smallSemiBold
        
        lblSkillsTitle.text = "JOB_SKILLS".localized
        lblDateTitle.text = "ADS_DESC_DATE_LABEL".localized
        lblPriceTitle.text = "ADS_DESC_PRICE".localized
        lblCityTitle.text = "ADS_DESC_CITY_LABEL".localized
        lblAreaTitle.text = "ADS_DESC_AREA_LABEL".localized
        lblDescriptionTitle.text = "ADS_DESC_DESCRIPTION".localized
        lblGalleryTitle.text = "ADS_DESC_GALLERY".localized
        btnTopContact.setTitle("ADS_DESC_CONTACT_BUTTON".localized, for: .normal)
        btnBottomContact.setTitle("ADS_DESC_CONTACT_BUTTON".localized, for: .normal)
        btnDeactiveProduct.setTitle("JOB_DEACTIVE".localized, for: .normal)
        
        let nib = UINib(nibName: cellID, bundle: nil)
        imagesCollectionView.register(nib, forCellWithReuseIdentifier: cellID)
        galleryCollectionView.register(nib, forCellWithReuseIdentifier: cellID)
        imagesCollectionView.delegate = self
        imagesCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        galleryCollectionView.dataSource = self
        
        // Setup skills collection view
        self.skillsCollectionView.delegate = self
        self.skillsCollectionView.dataSource = self
        self.skillsCollectionView.isScrollEnabled = false
        self.skillsCollectionView.register(UINib(nibName: "SkillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkillCollectionViewCell")
        self.skillsCollectionView.collectionViewLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: AppConfig.currentLanguage == .arabic ? .right : .left, verticalAlignment: .top)
        
        fillUpData()
        
        // change nav bar tint color for back button
        //self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        pageController.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
            $0.alpha  = 0.5
        }
        
        self.showNavBackButton = true
        
        self.skillsCollectionViewConstant.constant = self.skillsCollectionView.contentSize.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.imagesCollectionView.reloadData()
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        self.popOrDismissViewControllerAnimated(animated: true)
    }
    
    func fillUpData() {
        for i in marketProduct?.images ?? [] {
            let media = Media()
            media.type = .image
            media.fileUrl = i
            
            images.append(media)
        }
        
        if let value = marketProduct?.creationDate{lblDate.text = DateHelper.getStringFromDate(value)}
        self.lblTitle.text = marketProduct?.title
        self.lblCity.text = marketProduct?.city?.title
        self.lblArea.text = marketProduct?.location?.title
        self.lblCategory.text = marketProduct?.category?.title
        self.lblSubCategory.text = marketProduct?.subCategory?.title
        self.lblDescription.text = marketProduct?.description
        self.lblPrice.text = String(marketProduct?.price ?? 0)
        
        if let phone1 = marketProduct?.bussiness?.phone1 {
            self.phone1Label.text = phone1
        }else if let phone2 = marketProduct?.bussiness?.phone2 {
            self.phone1Label.text = phone2
        }else if let phone3 = marketProduct?.owner?.phoneNumber {
            self.phone1Label.text = phone3
        }
        
        // page Controller
        self.pageController.numberOfPages = images.count
        
        if let skills = marketProduct?.tags {
            tags = skills
            skillsCollectionView.reloadData()
            //skillsCollectionViewConstant.constant = skillsCollectionView.contentSize.height
            self.scrollViewContent.layoutIfNeeded()
            self.viewWillLayoutSubviews()
        }
        
        if (self.marketProduct?.ownerID == DataStore.shared.me?.objectId || self.marketProduct?.bussiness?.ownerId == DataStore.shared.me?.objectId) && self.marketProduct?.status != Status.active.rawValue {
            self.btnDeactiveProduct.isHidden = false
        }else {
            self.btnDeactiveProduct.isHidden = true
        }
        
        imagesCollectionView.reloadData()
        galleryCollectionView.reloadData()
    }

    func callPhone(phone:String){
        guard let number = URL(string: "tel://" + phone) else { return }
        UIApplication.shared.openURL(number)
    }
}

// MARK:- @IBAction
extension MarketProductDetailsViewController {
  
    @IBAction func close(_ sender: UIButton) {
        self.popOrDismissViewControllerAnimated(animated: true)
    }
    
    @IBAction func showContactsView(_ sender: UIButton) {
        self.contactsBGView.isHidden = false
        self.contactsMiddleView.animateIn(mode: .animateInFromBottom, delay: 0.2)
    }

    @IBAction func hideContactsView(_ sender: UITapGestureRecognizer) {
        self.contactsBGView.isHidden = true
    }
    
    @IBAction func callPhone1(_ sender: UIButton) {
        if let phone1 = marketProduct?.bussiness?.phone1 {
            callPhone(phone:phone1)
        }else if let phone2 = marketProduct?.bussiness?.phone2 {
            callPhone(phone:phone2)
        }else if let phone3 = marketProduct?.owner?.phoneNumber {
            callPhone(phone:phone3)
        }
    }
    @IBAction func deactiveProductAction(_ sender: Any){
        let deactiveAlert = UIAlertController(title: "GLOBAL_WARNING_TITLE".localized, message: "PRODUCT_DEACTIVE_WARNING".localized, preferredStyle: .alert)
        deactiveAlert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
        deactiveAlert.addAction(UIAlertAction(title: "JOB_DEACTIVE".localized, style: .destructive, handler: {_ in
            if let prod = self.marketProduct {
                self.showActivityLoader(true)
                prod.status = Status.deactivated.rawValue
                ApiManager.shared.editMarketProduct(product: prod, bussinessId: self.marketProduct?.businessID ?? "") { (success, error) in
                    self.showActivityLoader(false)
                    if let error = error {
                        self.showMessage(message: error.type.errorMessage , type: .error )
                        return
                    }
                    self.btnDeactiveProduct.isHidden = true
                }
            }
        }))
        self.present(deactiveAlert, animated: true, completion: nil)
    }
}

extension MarketProductDetailsViewController : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imagesCollectionView {
            if images.count == 0 {
                return 1
            }else {
                return images.count
            }
        }else if collectionView == skillsCollectionView {
            return tags.count
            
        } else {
            return images.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == imagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCell
            
            if self.images.count > 0 {
                cell.media = self.images[indexPath.row]
            }
            
            
            return cell
        }else if collectionView == skillsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCollectionViewCell", for: indexPath) as! SkillCollectionViewCell
            
            cell.title = self.tags[indexPath.row].name ?? ""
            cell.btnRemove.isHidden = true
            
            cell.layoutIfNeeded()
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCell
            
            cell.media = self.images[indexPath.row]
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == imagesCollectionView {
            let itemWidth = collectionView.frame.width
            let itemHeight = collectionView.frame.height
            return CGSize(width: itemWidth, height: itemHeight)
            
        }else if collectionView == skillsCollectionView {
            let width = self.tags[indexPath.row].name!.getLabelWidth(font: AppFonts.normal) + 32
            
            return CGSize(width: width, height: 30)
            
        } else {
            return CGSize(width: 90, height: 90)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != self.skillsCollectionView {
            if self.images.count > 0 {
                ActionShowMediaInFullScreen.execute(pageDelegate: self, dismissalDelegate: self, media: self.images, currentPage: indexPath.row)
            }
        }
        
    }
    
}

extension MarketProductDetailsViewController : LightboxControllerDismissalDelegate, LightboxControllerPageDelegate {
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        
    }
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        
    }
}

// page controller delegates

extension MarketProductDetailsViewController{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == imagesCollectionView {
            //print("x \(targetContentOffset.pointee.x)")
            let pagenumber = Int(abs(targetContentOffset.pointee.x) / view.frame.width)
            self.pageController.currentPage = pagenumber
        }
        
    }

}
