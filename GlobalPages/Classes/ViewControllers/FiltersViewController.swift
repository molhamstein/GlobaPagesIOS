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
    
    @IBOutlet weak var applyButton: UIButton!
    
    
    
    var filters:[String] = ["Real State","Cars","Jobs"]
    
    var isInitialized = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !self.isInitialized {
            // colors
            self.applyButton.applyGradient(colours: [AppColors.yellowDark,AppColors.yellowLight], direction: .diagonal)
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
        
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}




extension FiltersViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as! filterCell2
        cell.title = filters[indexPath.item]
        collectionView.deselectItem(at: indexPath, animated: true)
        return cell
    }
    

}


extension FiltersViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: filters[indexPath.item].getLabelWidth(font: AppFonts.normal) + 32, height: self.categoryCollectionView.frame.height - 16)
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
        cell.configureCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
        cell.configureCell()
    }
}
