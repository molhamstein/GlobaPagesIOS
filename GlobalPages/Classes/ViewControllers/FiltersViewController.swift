//
//  FiltersViewController.swift
//  GlobalPages
//
//  Created by Nour  on 6/25/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit


enum categoryFilterType{
    case Home
    case Category
    var filter:Filter{
        switch self {
        case .Home:
            return Filter.home
        case .Category:
            return Filter.bussinesGuid
        }
    }
}


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
    
    
    var categoryfiltertype:categoryFilterType?
    
    var filters:[categoriesFilter] = []
    
    var selectedCategory:categoriesFilter?
    
    var categoryfilters:[categoriesFilter]{
        return filters.filter{$0.parentCategoryId == nil}
    }
    
    var subCategoryFilters:[categoriesFilter]{
        if let cat = selectedCategory{
            return filters.filter({$0.parentCategoryId == cat.Fid})
        }
        return []
    }
    
    
    var cities:[categoriesFilter] = []
    var selectedCity:categoriesFilter?
    var areas:[categoriesFilter] {
        if let city = selectedCity{
           return city.locations
        }
        return []
    }
    
    var categoriesCount = 0
    var subCategoriesCount = 0
    var citiesCount = 0
    var areasCount = 0
    
    var isInitialized = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.isHidden = true
        if let keyword = categoryfiltertype?.filter.keyWord , !keyword.isEmpty {
            self.keyWordTextField.text = keyword
        }
        if self.categoryfiltertype == categoryFilterType.Home{
            self.filters = DataStore.shared.postCategories
            getPostFilters()
        }else{
            self.filters = DataStore.shared.categoriesfilters
            getBussinessFilters()
        }
        self.cities = DataStore.shared.citiesfilters
        getCityFilters()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !self.isInitialized {
            // colors
            self.applyButton.applyGradient(colours: [AppColors.yellowDark,AppColors.yellowLight], direction: .diagonal)
        }
        self.isInitialized = true
        self.showNavBackButton = true
    }
    
    
    override func buildUp() {
        containerView.isHidden = false
        self.containerView.animateIn(mode: .animateInFromBottom, delay: 0.3)
        // shadowAppFonts
        self.containerView.dropShadow()
        
    }

    override func customizeView() {
        
        
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
        self.searchKeyWordTitleLabel.font = AppFonts.normalBold
        self.keyWordTextField.font = AppFonts.bigBold
        self.categoryTitleLabel.font = AppFonts.normalBold
        self.subCategoryTitleLabel.font = AppFonts.normalBold
        self.cityTitleLabel.font = AppFonts.normalBold
        self.areaTitleLabel.font = AppFonts.normalBold
        self.applyButton.titleLabel?.font = AppFonts.bigBold
        
        self.searchKeyWordTitleLabel.textColor = AppColors.grayDark
        self.categoryTitleLabel.textColor = AppColors.grayDark
        self.subCategoryTitleLabel.textColor = AppColors.grayDark
        self.cityTitleLabel.textColor = AppColors.grayDark
        self.areaTitleLabel.textColor = AppColors.grayDark
        // style
        self.keyWordTextField.borderStyle = .none
        
        
        self.applyButton.dropShadow()
        
        self.hideSubCategoryView()
        self.HideAreaView()
        self.filters = DataStore.shared.categoriesfilters
        self.cities  = DataStore.shared.citiesfilters
        
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
        if let keyword = keyWordTextField.text , !keyword.isEmpty{
            categoryfiltertype?.filter.keyWord = keyword
        }else{
            categoryfiltertype?.filter.keyWord = nil
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func getSubCategories(){
        self.subCategoriesCount = self.subCategoryFilters.count
        subCategoryCollectionView.reloadData()
        subCategoryCollectionView.collectionViewLayout.invalidateLayout()
        subCategoryCollectionView.layoutSubviews()
        UIView.animate(withDuration: 0.2, animations: {
            self.subCategoryView.isHidden = false
            self.hideAbleView1.isHidden = true
        }){ (success) in}
    }
    
    func hideSubCategoryView(){
        UIView.animate(withDuration: 0.2, animations: {
            self.subCategoryView.isHidden = true
            self.hideAbleView1.isHidden = false
        }){ (success) in}
    }
    
    
    func getAreas(){
        self.areasCount = self.areas.count
        areaCollectionView.reloadData()
        areaCollectionView.collectionViewLayout.invalidateLayout()
        areaCollectionView.layoutSubviews()
        UIView.animate(withDuration: 0.2, animations: {
            self.areaView.isHidden = false
            self.hideAbelView2.isHidden = true
        }){ (success) in}
            
    }
    func HideAreaView(){
               UIView.animate(withDuration: 0.2, animations: {
                self.areaView.isHidden = true
                self.hideAbelView2.isHidden = false
             }){ (success) in}
        }
    
    
    func getBussinessFilters(){
        if DataStore.shared.categoriesfilters.isEmpty{
            self.showActivityLoader(true)
        }
        ApiManager.shared.businessCategories { (success, error, result,cats) in
            self.showActivityLoader(false)
            if success{
                    self.filters = result
                    self.categoriesCount = self.categoryfilters.count
                    self.categoryCollectionView.reloadData()
                    self.categoryCollectionView.collectionViewLayout.invalidateLayout()
                }
                if error != nil{
                    if let msg = error?.errorName{
                        self.showMessage(message: msg, type: .error)
                    }
                }
        }
    }
    
    func getCityFilters(){
        if DataStore.shared.citiesfilters.isEmpty{
            self.showActivityLoader(true)
        }
        ApiManager.shared.getCities { (success, error, result,cats) in
            self.showActivityLoader(false)
            if success{
                self.cities = result
                self.citiesCount = self.cities.count
                self.cityCollectionView.reloadData()
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
    //postCategories
    func getPostFilters(){
        if DataStore.shared.postCategories.isEmpty{
            self.showActivityLoader(true)
        }
        ApiManager.shared.postCategories { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                self.filters = result
                self.categoriesCount = self.categoryfilters.count
                self.categoryCollectionView.reloadData()
                self.categoryCollectionView.collectionViewLayout.invalidateLayout()
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
 
}


extension FiltersViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView    { return categoriesCount }
        if collectionView == subCategoryCollectionView { return subCategoriesCount }
        if collectionView == cityCollectionView        { return citiesCount }
        if collectionView == areaCollectionView        { return areasCount }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as? filterCell2 else{return UICollectionViewCell()}
            if let category = categoryfiltertype?.filter.category{
                if category.Fid == categoryfilters[indexPath.item].Fid{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                    self.selectedCategory = category
                    self.getSubCategories()
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.filter = categoryfilters[indexPath.item]
            cell.filter?.filtervalue = filterValues.category
            cell.setupView(type:.normal)
           return cell
        }else if collectionView == subCategoryCollectionView{
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as? filterCell2 else{return UICollectionViewCell()}
            if let subCategory = categoryfiltertype?.filter.subCategory{
                if subCategory.Fid == subCategoryFilters[indexPath.item].Fid{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                  //  self.getSubCategories()
                }else{
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }
                
            }else{
                cell.isSelected = false
                collectionView.deselectItem(at: indexPath, animated: true)
            }

            cell.filter = subCategoryFilters[indexPath.item]
            cell.filter?.filtervalue = filterValues.subCategory
            cell.setupView(type:.normal)
          return cell
        }else if collectionView == cityCollectionView{
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as? filterCell2 else{return UICollectionViewCell()}
            if let city = categoryfiltertype?.filter.city{
                if city.Fid == cities[indexPath.item].Fid{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                    self.selectedCity = city
                    self.getAreas()
                }else{
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }
            }else{
                cell.isSelected = false
                collectionView.deselectItem(at: indexPath, animated: true)
            }

            cell.filter = cities[indexPath.item]
            cell.filter?.filtervalue = filterValues.city
            cell.setupView(type:.normal)
           return cell
        }else if collectionView == areaCollectionView{
               guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as? filterCell2 else{return UICollectionViewCell()}
            if let area = categoryfiltertype?.filter.area{
                if area.Fid == areas[indexPath.item].Fid{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                }else{
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }
            }else{
                cell.isSelected = false
                collectionView.deselectItem(at: indexPath, animated: true)
            }

            cell.filter = areas[indexPath.item]
            cell.filter?.filtervalue = filterValues.area
            cell.setupView(type:.normal)
            return cell
        }
        
        return UICollectionViewCell()
    }
    

}


extension FiltersViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView{
            return CGSize(width: categoryfilters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: self.categoryCollectionView.frame.height - 24)
        }
        if collectionView == subCategoryCollectionView{
            return CGSize(width: subCategoryFilters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: self.subCategoryCollectionView.frame.height - 24)
        }
        if collectionView == cityCollectionView{
            return CGSize(width: cities[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: self.cityCollectionView.frame.height - 24)
        }
        if collectionView == areaCollectionView{
            return CGSize(width: areas[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: self.areaCollectionView.frame.height - 24)
        }
        
           return CGSize(width: filters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: self.areaCollectionView.frame.height - 24)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? filterCell2 else {return}
        if collectionView == categoryCollectionView {
            if let value = categoryfiltertype?.filter.category{
                if value.Fid == categoryfilters[indexPath.item].Fid{
                   categoryfiltertype?.filter.clearCategory()
                    cell.isSelected = false
                    selectedCategory = nil
                    collectionView.deselectItem(at: indexPath, animated: true)
                    self.hideSubCategoryView()
                }else{
                    categoryfiltertype?.filter.category = categoryfilters[indexPath.item]
                    cell.isSelected = true
                    selectedCategory = categoryfiltertype?.filter.category
                    self.getSubCategories()
                }
            }else{
                categoryfiltertype?.filter.category = categoryfilters[indexPath.item]
                cell.isSelected = true
                selectedCategory = categoryfiltertype?.filter.category
                self.getSubCategories()
            }
            
            
        }else if collectionView == subCategoryCollectionView{
            if let value = categoryfiltertype?.filter.subCategory{
                if value.Fid == subCategoryFilters[indexPath.item].Fid{
                    categoryfiltertype?.filter.subCategory = nil
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }else{
                    categoryfiltertype?.filter.subCategory = subCategoryFilters[indexPath.item]
                    cell.isSelected = true
                }
            }else{
                categoryfiltertype?.filter.subCategory = subCategoryFilters[indexPath.item]
                cell.isSelected = true
            }
        }else if collectionView == cityCollectionView{
            if let value = categoryfiltertype?.filter.city{
                if value.Fid == cities[indexPath.item].Fid{
                   categoryfiltertype?.filter.clearCity()
                    cell.isSelected = false
                    selectedCity = nil
                    collectionView.deselectItem(at: indexPath, animated: true)
                    self.HideAreaView()
                }else{
                    categoryfiltertype?.filter.city = cities[indexPath.item]
                    cell.isSelected = true
                    selectedCity = categoryfiltertype?.filter.city
                    self.getAreas()
                }
            }else{
                categoryfiltertype?.filter.city = cities[indexPath.item]
                cell.isSelected = true
                selectedCity = categoryfiltertype?.filter.city
                self.getAreas()
            }
            
        }else if collectionView == areaCollectionView{
            if let value = categoryfiltertype?.filter.area{
                if value.Fid == areas[indexPath.item].Fid{
                    categoryfiltertype?.filter.area = nil
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }else{
                    categoryfiltertype?.filter.area = areas[indexPath.item]
                    cell.isSelected = true
                }
            }else{
                categoryfiltertype?.filter.area = areas[indexPath.item]
                cell.isSelected = true
            }
        }
        cell.configureCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) as? filterCell2{
            categoryfiltertype?.filter.category = nil
            selectedCategory = nil
            cell.isSelected = false
            cell.configureCell()
            }
        }else if collectionView == subCategoryCollectionView{
            if let cell = collectionView.cellForItem(at: indexPath) as? filterCell2{
            categoryfiltertype?.filter.subCategory = nil
            cell.isSelected = false
            cell.configureCell()
            }
        }else if collectionView == cityCollectionView{
            if let cell = collectionView.cellForItem(at: indexPath) as? filterCell2{
            categoryfiltertype?.filter.city = nil
            selectedCity = nil
            cell.isSelected = false
            cell.configureCell()

            }
        }else if collectionView == areaCollectionView{
            if let cell = collectionView.cellForItem(at: indexPath) as? filterCell2{
            categoryfiltertype?.filter.area = nil
            cell.isSelected = false
            cell.configureCell()
            }
        }
        
    }
}
