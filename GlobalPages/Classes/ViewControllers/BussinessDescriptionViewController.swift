//
//  AdsDescriptionViewController.swift
//  GlobalPages
//
//  Created by Nour  on 7/1/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class BussinessDescriptionViewController: AbstractController {
    
   
    @IBOutlet weak var contactBottomButton: XUIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptinTitleLabel: UILabel!
    @IBOutlet weak var contactButton: XUIButton!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var areaTitleLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityTitleLable: UILabel!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bussiniesTitleLabel: UILabel!
    @IBOutlet weak var bussinessCategoryLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var categoryTitleLabel: XUILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var subCategoryTitleLabel: XUILabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var addProductButton: UIButton!
    
    
    
    
    @IBOutlet weak var tagViewWidthConstraint: XNSLayoutConstraint!
    @IBOutlet weak var subCategoryWidthConstraint: XNSLayoutConstraint!
    
    var bussiness:Bussiness?
    var products:[Product] = []
    var images:[Media] = []
    var editMode:Bool = false
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
    
    
    var cellID = "ImageCell"
    var productCellId = "ProductCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addProductButton.isHidden = !editMode
        fillData()
    }
    
    override func customizeView() {
        
        let nib = UINib(nibName: cellID, bundle: nil)
        imageCollectionView.register(nib, forCellWithReuseIdentifier: cellID)
        
        productsCollectionView.register(UINib(nibName: productCellId, bundle: nil), forCellWithReuseIdentifier: productCellId)
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        // fonts
        self.bussiniesTitleLabel.font = AppFonts.xBigBold
        self.bussinessCategoryLabel.font = AppFonts.xBigBold
        self.categoryTitleLabel.font = AppFonts.smallBold
        self.categoryLabel.font = AppFonts.normalBold
        self.subCategoryTitleLabel.font = AppFonts.smallBold
        self.subCategoryLabel.font = AppFonts.normalBold
        self.cityTitleLable.font = AppFonts.smallBold
        self.cityLabel.font = AppFonts.normalBold
        self.areaTitleLabel.font = AppFonts.smallBold
        self.areaLabel.font = AppFonts.normalBold
        self.contactButton.titleLabel?.font = AppFonts.normalBold
        self.contactBottomButton.titleLabel?.font  = AppFonts.normalBold
        self.descriptionTextView.font = AppFonts.normalBold
        self.descriptinTitleLabel.font = AppFonts.normalBold
        
        //colors
        self.headerView.backgroundColor = AppColors.grayXDark
        
        //shadow
        self.contactBottomButton.dropShadow()
        self.containerView.dropShadow()
   
        // page Controller
        self.pageController.numberOfPages = 0
        
        // change nav bar tint color for back button
        self.navigationController?.navigationBar.tintColor = .white
        
        
        guard let bussiness = self.bussiness else{return}
        
        // set data
        self.bussiniesTitleLabel.text = bussiness.title
        self.bussinessCategoryLabel.text = bussiness.category?.title
        self.categoryLabel.text = bussiness.category?.title
        self.subCategoryLabel.text = bussiness.subCategory?.title
//        self.cityLabel.text =
//        self.areaLabel.font = AppFonts.normalBold
        self.descriptionTextView.text = bussiness.description
        if let value = self.bussiness?.products{
            self.products = value
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        // change the page controlelr indecator size and alpha
        pageController.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 2, y: 2)
            $0.alpha  = 0.5
        }
        self.showNavBackButton = true
    }
    
    
    
    override func backButtonAction(_ sender: AnyObject) {
          self.dismiss(animated: true, completion: nil)
   //     self.popOrDismissViewControllerAnimated(animated: true)
    }
    
    func fillData(){
        guard  let bussiness = self.bussiness else {return}
        if let value = bussiness.title { self.bussiniesTitleLabel.text = value}
        if let value = bussiness.category?.title { self.bussinessCategoryLabel.text = value}
        if let value = bussiness.category?.title { self.categoryLabel.text = value}
        if let value = bussiness.subCategory?.title { self.subCategoryLabel.text = value}
        if let value = bussiness.city?.title { self.cityLabel.text = value}
        if let value = bussiness.location?.title { self.areaLabel.text = value}
        if let value = bussiness.description { self.descriptionTextView.text = value}
        if let value = bussiness.products { self.products = value}
        productsCollectionView.reloadData()
        if let value = bussiness.media{self.images = value}
        imageCollectionView.reloadData()
        self.pageController.numberOfPages = self.images.count
    }
    
    @IBAction func addProduct(_ sender: UIButton) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "NewProductViewController")  as! NewProductViewController
        vc.bussinessId = bussiness?.id
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
}



extension BussinessDescriptionViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productsCollectionView{
            return products.count
        }
        if collectionView == imageCollectionView {
            return self.images.count
        }
        return 3
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCell
        cell.media = self.images[indexPath.item]
        return cell
        }
        if collectionView == productsCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellId, for: indexPath) as! ProductCell
            cell.product = self.products[indexPath.item]
            if self.editMode{ cell.editMode()}
            return cell
        }
        return UICollectionViewCell()
    }
    
}

extension BussinessDescriptionViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCollectionView{
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth, height: itemHeight + 64)
        }
        if collectionView == productsCollectionView {
            let itemWidth = collectionView.bounds.width
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth * 0.75, height: itemHeight - 16)
        }
        return CGSize(width: 0, height: 0)
    }
    
    
 
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == productsCollectionView{
            if editMode{
                let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "NewProductViewController")  as! NewProductViewController
                vc.bussinessId = bussiness?.id
                vc.tempProduct = self.products[indexPath.item]
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
}



// page controller delegates

extension BussinessDescriptionViewController{
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("x \(targetContentOffset.pointee.x)")
        let pagenumber = Int(abs(targetContentOffset.pointee.x) / view.frame.width)
        self.pageController.currentPage = pagenumber
    }
    
    
    
}

