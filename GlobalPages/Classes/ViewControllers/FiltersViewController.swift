//
//  FiltersViewController.swift
//  GlobalPages
//
//  Created by Nour  on 6/25/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class FiltersViewController: AbstractController {

    @IBOutlet weak var containerView: UIView!
    
    static var filtterCellId = "filterCell2"
    // key word view
    @IBOutlet weak var searchKeyWordView: UIView!
    @IBOutlet weak var searchKeyWordTitleLabel: UILabel!
    @IBOutlet weak var keyWordTextField: XUITextField!
    
    
    // category View
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    // subCategory View
    @IBOutlet weak var subCategoryView: UIView!
    @IBOutlet weak var subCategoryTitleLabel: UILabel!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    
    
    // cityView
    @IBOutlet weak var cityView: UIView!
    @IBOutlet weak var cityTitleLabel: UILabel!
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    // area View
    @IBOutlet weak var areaView: UIView!
    @IBOutlet weak var areaTitleLabel: UILabel!
    @IBOutlet weak var areaCollectionView: UICollectionView!
    
    
    
    @IBOutlet weak var hideAbleView1: UIView!
    @IBOutlet weak var hideAbelView2: UIView!
    
    
    @IBOutlet weak var applyButton: UIButton!
    
    
    
    var filters:[String] = ["Real State","Cars","Jobs"]
    
    var isInitialized = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let keyword = filter.keyWord {
            self.keyWordTextField.text = keyword
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isInitialized {
            // colors
            self.applyButton.applyGradient(colours: [AppColors.yellowDark,AppColors.yellowLight], direction: .diagonal)
            // shadowAppFonts
            self.containerView.dropShadow()
        }
        self.isInitialized = true
        
    }
    
    override func buildUp() {
        self.containerView.animateIn(mode: .animateInFromBottom, delay: 0.4)
        
    }

    override func customizeView() {
        self.showNavBackButton = true
        
        // set text
        self.setNavBarTitle(title: "FILTER_VIEW_TITLE".localized)
        
        self.searchKeyWordTitleLabel.text = "FILTER_KEY_WORD_TITLE".localized
        self.keyWordTextField.placeholder = "FILTER_KEYWORD_TEXT_FIELD_PLACEHOLDER".localized
        self.categoryTitleLabel.text = "FILTER_CATEGORY_TITLE".localized
        self.subCategoryTitleLabel.text = "FILTER_SUB_CATEGORY_TITLE".localized
        self.cityTitleLabel.text = "FILTER_CITY_TITLE".localized
        self.areaTitleLabel.text = "FILTER_AREA_TITLE".localized
        self.applyButton.setTitle("FILTER_APPLY_BUTTON_TITLE".localized, for: .normal)
        
        
        // fonts
        self.searchKeyWordTitleLabel.font = AppFonts.normal
        self.keyWordTextField.font = AppFonts.normal
        self.categoryTitleLabel.font = AppFonts.normal
        self.subCategoryTitleLabel.font = AppFonts.normal
        self.cityTitleLabel.font = AppFonts.normal
        self.areaTitleLabel.font = AppFonts.normal
        self.applyButton.titleLabel?.font = AppFonts.normalBold
        
        
        // style
        self.keyWordTextField.borderStyle = .none
        
        
        
        
        self.hideSubCategoryView()
        self.HideAreaView()
        
        setupCollectionViews()
    }
    
    
    func setupCollectionViews(){
        let nib = UINib(nibName: FiltersViewController.filtterCellId, bundle: nil)
        
        self.categoryCollectionView.register(nib, forCellWithReuseIdentifier: FiltersViewController.filtterCellId)
        self.subCategoryCollectionView.register(nib, forCellWithReuseIdentifier: FiltersViewController.filtterCellId)
        self.cityCollectionView.register(nib, forCellWithReuseIdentifier: FiltersViewController.filtterCellId)
        self.areaCollectionView.register(nib, forCellWithReuseIdentifier: FiltersViewController.filtterCellId)
        
        
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        self.subCategoryCollectionView.delegate = self
        self.subCategoryCollectionView.dataSource = self
        self.cityCollectionView.dataSource = self
        self.cityCollectionView.delegate = self
        self.areaCollectionView.delegate = self
        self.areaCollectionView.dataSource = self
        
        
        self.categoryCollectionView.allowsMultipleSelection = false
        self.subCategoryCollectionView.allowsMultipleSelection = false
        self.cityCollectionView.allowsMultipleSelection = false
        self.areaCollectionView.allowsMultipleSelection = false
        
        
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func apply(_ sender: UIButton) {
        if let keyword = keyWordTextField.text{
            filter.keyWord = keyword
        }else{
            filter.keyWord = nil
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func getSubCategories(){
        dispatch_main_after(0.1) {
      //  UIView.animate(withDuration: 0, animations: {
        
            self.subCategoryView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            self.hideAbleView1.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
       // }){ (success) in
            self.subCategoryView.isHidden = false
            self.hideAbleView1.isHidden = true
       // }
        }
    }
    
    func hideSubCategoryView(){
        dispatch_main_after(0.1) {
     //   UIView.animate(withDuration: 0, animations: {
            self.subCategoryView.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
            self.hideAbleView1.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
       // }){ (success) in
            self.subCategoryView.isHidden = true
            self.hideAbleView1.isHidden = false
            //}
            
        }

    }
    
    
    func getAreas(){
        dispatch_main_after(0.1) {
     //   UIView.animate(withDuration: 0, animations: {
            self.areaView.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            self.hideAbelView2.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
       // }){ (success) in
            self.areaView.isHidden = false
            self.hideAbelView2.isHidden = true
            // }
            
        }
    }
    
    func HideAreaView(){
        dispatch_main_after(0.1) {
            //   UIView.animate(withDuration: 0, animations: {
            self.areaView.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
            self.hideAbelView2.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
            // }){ (success) in
            self.areaView.isHidden = true
            self.hideAbelView2.isHidden = false
            //}
        }
     
       
        
    }
    
    
}




extension FiltersViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return filters.count
        }else if collectionView == subCategoryCollectionView{
            return filters.count
        }else if collectionView == cityCollectionView{
            return filters.count
        }else if collectionView == areaCollectionView{
            return filters.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as! filterCell2
        if collectionView == categoryCollectionView {
            if let category = filter.category{
                if category == filters[indexPath.item]{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                    self.getSubCategories()
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.title = filters[indexPath.item]
           
        }else if collectionView == subCategoryCollectionView{
            
            if let subCategory = filter.subCategory{
                if subCategory == filters[indexPath.item]{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                    self.getSubCategories()
                }else{
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }
            }else{
                cell.isSelected = false
                collectionView.deselectItem(at: indexPath, animated: true)
            }

            cell.title = filters[indexPath.item]
          
        }else if collectionView == cityCollectionView{
            if let city = filter.city{
                if city == filters[indexPath.item]{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                    self.getAreas()
                }else{
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }
            }else{
                cell.isSelected = false
                collectionView.deselectItem(at: indexPath, animated: true)
            }

            cell.title = filters[indexPath.item]
           
        }else if collectionView == areaCollectionView{
            
            if let area = filter.area{
                if area == filters[indexPath.item]{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                    self.getAreas()
                }else{
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }
            }else{
                cell.isSelected = false
                collectionView.deselectItem(at: indexPath, animated: true)
            }

            cell.title = filters[indexPath.item]
            
        }
        
        return cell
    }
    

}


extension FiltersViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: filters[indexPath.item].getLabelWidth(font: AppFonts.normal) + 32, height: self.categoryCollectionView.frame.height - 16)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
        
        
        if collectionView == categoryCollectionView {
            if let value = filter.category{
                if value == filters[indexPath.item]{
                    filter.clearCategory()
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                    self.hideSubCategoryView()
                }else{
                    filter.category = filters[indexPath.item]
                    cell.isSelected = true
                    self.getSubCategories()
                }
            }else{
                filter.category = filters[indexPath.item]
                cell.isSelected = true
                self.getSubCategories()
            }
            
        }else if collectionView == subCategoryCollectionView{
            if let value = filter.subCategory{
                if value == filters[indexPath.item]{
                    filter.subCategory = nil
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }else{
                    filter.subCategory = filters[indexPath.item]
                    cell.isSelected = true
                    self.getSubCategories()
                }
            }else{
                filter.subCategory = filters[indexPath.item]
                cell.isSelected = true
                self.getSubCategories()
            }
        }else if collectionView == cityCollectionView{
            if let value = filter.city{
                if value == filters[indexPath.item]{
                    filter.clearCity()
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                    self.HideAreaView()
                }else{
                    filter.city = filters[indexPath.item]
                    cell.isSelected = true
                    self.getAreas()
                }
            }else{
                filter.city = filters[indexPath.item]
                cell.isSelected = true
                self.getAreas()
            }
            
        }else if collectionView == areaCollectionView{
            if let value = filter.area{
                if value == filters[indexPath.item]{
                    filter.area = nil
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }else{
                    filter.area = filters[indexPath.item]
                    cell.isSelected = true
                    self.getAreas()
                }
            }else{
                filter.area = filters[indexPath.item]
                cell.isSelected = true
                self.getAreas()
            }
        }
        filter.getDictionry()
        cell.configureCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
        
        
        if collectionView == categoryCollectionView {
            filter.category = nil
            cell.isSelected = false
        }else if collectionView == subCategoryCollectionView{
            filter.subCategory = nil
            cell.isSelected = false
        }else if collectionView == cityCollectionView{
            filter.city = nil
            cell.isSelected = false
        }else if collectionView == areaCollectionView{
            filter.area = nil
            cell.isSelected = false
        }
        cell.configureCell()
    }
}
