//
//  NewProductViewController.swift
//  GlobalPages
//
//  Created by Nour  on 8/10/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class NewProductViewController: AbstractController {
    
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var adtitleTextField: UITextField!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imagesTitleLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var adCategoryTitleLabel: UILabel!
    @IBOutlet weak var adCategoryCollectionView: UICollectionView!
    @IBOutlet weak var subCategortTitleLabel: UILabel!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet weak var subCategoryView: UIView!
    
    @IBOutlet weak var addButton: XUIButton!
    @IBOutlet weak var subCategoryHeightConstraint: NSLayoutConstraint!
    
    //city views
    @IBOutlet weak var cityTitleLabel: UILabel!
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    @IBOutlet weak var areaTitleLabel: UILabel!
    @IBOutlet weak var areaCollectionView: UICollectionView!
    
    @IBOutlet weak var areaView: UIView!
    
    // MARK:- Skills Section
    @IBOutlet weak var lblSkillsTitle: UILabel!
    @IBOutlet weak var skillsCollectionView: UICollectionView!
    @IBOutlet weak var skillsCollectionViewConstant: NSLayoutConstraint!
    @IBOutlet weak var btnAddSkill: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var selectedCity: City?
    var selectedArea: City?
    var cities: [City] { return DataStore.shared.cities }
    var areas: [City]  {
        if let city = selectedCity { return city.locations ?? [] }
        return []
    }
    var citiesCount = 0
    var areasCount = 0
    var cityId = ""
    var locationId = ""
    var subCategoryViewHeight: CGFloat = 0{
        didSet{
            subCategoryHeightConstraint.setNewConstant(subCategoryViewHeight)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutSubviews()
            }, completion: nil)
        }
    }
    let cellId = "filterCell2"
    let imageCellId = "ImageCell"
    var images:[UIImage] = []
    var media:[Media] = []
    var tags: [Tag] = []
    var selectedCategory: Category?
    var selectedSubCategory: Category?
    var categoryfilters: [Category]{
        return DataStore.shared.productCategories.filter { $0.parentCategoryId == nil }
    }
    var subCategoryFilters: [Category] {
        if let cat = selectedCategory {
            return DataStore.shared.productCategories.filter({$0.parentCategoryId == cat.Fid}) }
        return []
    }
    var categoriesCount = 0
    var subCategoriesCount = 0
    var selectedLocation:Location?
    var tempProduct: MarketProduct?
    var bussinessId: String?
    var editMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup skills collection view
        self.skillsCollectionView.delegate = self
        self.skillsCollectionView.dataSource = self
        self.skillsCollectionView.register(UINib(nibName: "SkillCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SkillCollectionViewCell")
        self.skillsCollectionView.collectionViewLayout = AlignedCollectionViewFlowLayout(horizontalAlignment: AppConfig.currentLanguage == .arabic ? .right : .left, verticalAlignment: .top)
        
        self.showNavBackButton = true
        self.subCategoryViewHeight = 0
        
        if let bussiness = tempProduct{
            fillData()
            editMode = true
        }
        else{
            tempProduct = MarketProduct()
        }
        
        if !editMode{
            self.setNavBarTitle(title: "Add New Product".localized)
        }else{
            self.setNavBarTitle(title: "Edit Product".localized)
        }
        
        getProductFilters()
        getCityFilters()
        
        self.citiesCount = self.cities.count
        self.subCategoryView.isHidden = false
        self.areaView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.showNavBackButton = true
    }
    
    override func viewWillLayoutSubviews() {
        self.skillsCollectionViewConstant.constant = self.skillsCollectionView.contentSize.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.addButton.dropShadow()
        self.addButton.applyStyleGredeant()
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func customizeView() {
        super.customizeView()
        // fonts
        self.adTitleLabel.font = AppFonts.big
        self.adtitleTextField.font = AppFonts.xBigBold
        self.descriptionTitleLabel.font = AppFonts.big
        self.descriptionTextView.font = AppFonts.xBigBold
        self.imagesTitleLabel.font = AppFonts.big
        self.adCategoryTitleLabel.font = AppFonts.big
        self.subCategortTitleLabel.font = AppFonts.big
        self.cityTitleLabel.font = AppFonts.big
        self.areaTitleLabel.font = AppFonts.big
        self.addButton.titleLabel?.font = AppFonts.bigBold
        self.lblSkillsTitle.font = AppFonts.big
        self.btnAddSkill.titleLabel?.font = AppFonts.normalBold
        
        // texts
        self.lblSkillsTitle.text = "JOB_SKILLS".localized
        self.btnAddSkill.setTitle("ADD_BUTTON_TITLE".localized, for: .normal)
        self.adtitleTextField.placeholder = "NEW_PRODUCT_NAME_PLACEHOLDER".localized
        self.descriptionTextView.placeholder = "(Optional)".localized
        
        if !editMode{
            self.addButton.setTitle("ADD_BUTTON_TITLE".localized, for: .normal)
        }else{
            self.addButton.setTitle("Update".localized, for: .normal)
        }
        
        
        
        setupCollectionViews()
    }
    
    func fillData(){
        
        guard let product = tempProduct else {return}
        if let name = product.title {self.adtitleTextField.text = name}
        if let array = product.images{
            var count = 0
            for url in array{
                let imageView = UIImageView()
                var tempurl = url
                if !url.contains(find: "http://") { tempurl = "http://\(url)"}
                imageView.sd_setShowActivityIndicatorView(true)
                imageView.sd_setIndicatorStyle(.gray)
                imageView.sd_setImage(with: URL(string:tempurl), completed: { (image, error, cach, url) in
                    if let img = image{
                        self.images.append(img)
                    }
                    count += 1
                    if count == array.count{
                        self.imageCollectionView.reloadData()
                    }
                })
            }
        }
        
        self.tags = self.tempProduct?.tags ?? []
        if let desc = product.description {self.descriptionTextView.text = desc}
        
        
        
        selectedCategory = product.category
        selectedSubCategory = product.subCategory
        if let city = product.city{
            selectedCity = city
        }else if let id = product.cityID{
            let city = City()
            city.Fid = id;
            selectedCity = city
        }
        
        
        if let city = product.location{
            selectedArea = city
        }else if let id = product.locationID{
            let city = City()
            city.Fid = id;
            selectedArea = city
        }
        
        self.cityCollectionView.reloadData()
        self.areaCollectionView.reloadData()
        self.adCategoryCollectionView.reloadData()
        self.subCategoryCollectionView.reloadData()
        self.skillsCollectionView.reloadData()
        self.contentView.layoutIfNeeded()
    }
    
    
    func scrollToSelectedCategory(){
        if let categoryIndex = categoryfilters.index(where: {$0.Fid == selectedCategory?.Fid}){
            self.adCategoryCollectionView.scrollToItem(at: IndexPath(item: categoryIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
        
    }
    func scrollToSelectedSubCategory(){
        
        if let subCategoryIndex = subCategoryFilters.index(where: {$0.Fid == selectedSubCategory?.Fid}){
            self.subCategoryCollectionView.scrollToItem(at: IndexPath(item: subCategoryIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
        
    }
    func scrollToSelectedCity(){
        
        if let citIndex = cities.index(where: {$0.Fid == selectedCity?.Fid}){
            self.cityCollectionView.scrollToItem(at: IndexPath(item: citIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
        
    }
    func scrollToSelectedArea(){
        
        if let areaIndex = areas.index(where: {$0.Fid == selectedArea?.Fid}){
            self.areaCollectionView.scrollToItem(at: IndexPath(item: areaIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    func getProductFilters(){
        if DataStore.shared.productCategories.isEmpty{
            self.showActivityLoader(true)
        }
        ApiManager.shared.marketProductCategories { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                
                self.categoriesCount = self.categoryfilters.count
                self.adCategoryCollectionView.reloadData()
                self.scrollToSelectedCategory()
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
    func getSubCategories(){
        self.subCategoriesCount = self.subCategoryFilters.count
        subCategoryCollectionView.reloadData()
        subCategoryCollectionView.collectionViewLayout.invalidateLayout()
        subCategoryCollectionView.layoutSubviews()
        UIView.animate(withDuration: 0.2, animations: {
            self.subCategoryViewHeight  = 100
        }){ (success) in}
        scrollToSelectedSubCategory()
    }
    
    func hideSubCategoryView(){
        UIView.animate(withDuration: 0.2, animations: {
            self.subCategoryViewHeight  = 0
        }){ (success) in}
    }
    
    func getAreas(){
        self.areasCount = self.areas.count
        areaCollectionView.reloadData()
        areaCollectionView.collectionViewLayout.invalidateLayout()
        areaCollectionView.layoutSubviews()
        self.areaView.isHidden = false
        scrollToSelectedArea()
        
    }
    
    func HideAreaView(){
        self.areaView.isHidden = true
        
    }
    
    
    
    func getCityFilters(){
        if DataStore.shared.cities.isEmpty{
            self.showActivityLoader(true)
        }
        ApiManager.shared.getCities { (success, error, result,cities) in
            self.showActivityLoader(false)
            if success{
                DataStore.shared.cities = cities
                self.citiesCount = self.cities.count
                self.cityCollectionView.reloadData()
                self.cityCollectionView.collectionViewLayout.invalidateLayout()
                if let city = self.selectedCity{
                    self.selectedCity = self.cities.filter({$0.Fid == city.Fid}).first
                }
                self.scrollToSelectedCity()
                self.getAreas()
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
    
    func setupCollectionViews(){
        
        let nib = UINib(nibName: cellId, bundle: nil)
        
        self.adCategoryCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        self.subCategoryCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        self.cityCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        self.areaCollectionView.register(nib, forCellWithReuseIdentifier: cellId)
        let imageNib = UINib(nibName: imageCellId, bundle: nil)
        self.imageCollectionView.register(imageNib, forCellWithReuseIdentifier: imageCellId)
        
    }
    
    
    func validate()-> Bool{
        
        if let title = adtitleTextField.text , !title.isEmpty{
            tempProduct?.titleAr = title
            tempProduct?.titleEn = title
        }else{
            self.showMessage(message: "please Enter a title".localized, type: .error)
            return false
        }
        
        if let cat = selectedCategory {
            tempProduct?.categoryID = cat.Fid
        }else{
            self.showMessage(message: "please select a category".localized, type: .error)
            return false
        }
        
        
        if let cat = selectedSubCategory {
            tempProduct?.subCategoryID = cat.Fid
        }else{
            self.showMessage(message: "please select a subCategory".localized, type: .error)
            return false
        }
        
        if let cat = selectedCity {
            cityId = cat.Fid!
            tempProduct?.cityID = cityId
        }else{
            self.showMessage(message: "please select a city".localized, type: .error)
            return false
        }
        
        if let cat = selectedArea {
            locationId = cat.Fid!
            tempProduct?.locationID = locationId
        }else{
            self.showMessage(message: "please select an area".localized, type: .error)
            return false
        }
        
        
        if let desc = descriptionTextView.text , !desc.isEmpty{
            tempProduct?.descriptionAr = desc
            tempProduct?.descriptionEn = desc
        }else{
            tempProduct?.descriptionAr = nil
            tempProduct?.descriptionEn = nil
        }
        
        tempProduct?.ownerID = DataStore.shared.me?.objectId
        tempProduct?.tags = self.tags
        
        if let bussinessId = bussinessId {
            tempProduct?.businessID = bussinessId
        }
        
        return true
    }
    
    
    func uploadImages(){
        self.showActivityLoader(true)
        ApiManager.shared.uploadImages(images: self.images) { (urls, error) in
            self.media = urls
            self.tempProduct?.images = urls.map({($0.fileUrl ?? "")})
            if self.editMode{
                self.updateProduct()
            }else{
                self.addProduct()
            }
        }
    }
    
    
    @IBAction func addProductAction(_ sender: AnyObject) {
        if validate(){
            if self.images.count > 0{
                uploadImages()
                
            }else{
                self.showActivityLoader(true)
                if self.editMode{
                    self.updateProduct()
                }else{
                    self.addProduct()
                }
            }
        }
    }
    
    @IBAction func AddSkillAction(_ sender: Any) {
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: AddSkillViewController.className) as! AddSkillViewController
        vc.tags = self.tags
        vc.delegate = self
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
        vc.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
        self.present(vc, animated: true, completion: nil)
    }
    
    func addProduct(){
        ApiManager.shared.addMarketProduct(product: self.tempProduct!, bussinessId: self.bussinessId ?? "", completionBlock: { (success, error) in
            self.showActivityLoader(false)
            if success{
                self.showMessage(message: "Done".localized, type: .success)
                self.dismiss(animated: true, completion: nil)
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        })
    }
    
    
    func updateProduct(){
        ApiManager.shared.editMarketProduct(product: self.tempProduct!, bussinessId: self.bussinessId ?? "") { (success, error) in
            self.showActivityLoader(false)
            if success{
                self.showMessage(message: "Done".localized, type: .success)
                self.dismiss(animated: true, completion: nil)
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }
}

extension NewProductViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imageCollectionView{
            return images.count + 1
        }
        
        if collectionView == self.adCategoryCollectionView{
            return categoryfilters.count
        }
        
        if collectionView == self.subCategoryCollectionView{
            return subCategoryFilters.count
        }
        
        if collectionView == self.skillsCollectionView {
            return self.tags.count
        }
        
        if collectionView == cityCollectionView         { return citiesCount }
        if collectionView == areaCollectionView         { return areasCount }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imageCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellId, for: indexPath) as! ImageCell
            if indexPath.item < images.count{
                cell.delegate = self
                cell.image = images[indexPath.item]
                cell.tag = indexPath.item
                cell.editMode(state:true)
            }else{
                cell.image = #imageLiteral(resourceName: "ic_add")
                cell.editMode(state:false)
            }
            return cell
        }
        
        if collectionView == adCategoryCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as? filterCell2 else{return UICollectionViewCell()}
            if let category = selectedCategory{
                if category.Fid == categoryfilters[indexPath.item].Fid{
                    cell.isSelected = true
                    //                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                    self.getSubCategories()
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.title = categoryfilters[indexPath.item].title ?? ""
            cell.setupView(type:.normal)
            cell.configureCell()
            return cell
        }
        if collectionView == subCategoryCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as? filterCell2 else{return UICollectionViewCell()}
            if let category = selectedSubCategory{
                if category.Fid == subCategoryFilters[indexPath.item].Fid{
                    cell.isSelected = true
                    //                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.title = subCategoryFilters[indexPath.item].title ?? ""
            cell.setupView(type:.normal)
            cell.configureCell()
            return cell
        }
        
        if collectionView == cityCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as? filterCell2 else{return UICollectionViewCell()}
            if let city = selectedCity{
                if city.Fid == cities[indexPath.item].Fid{
                    cell.isSelected = true
                    //                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                    getAreas()
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.title = cities[indexPath.item].title ?? ""
            cell.setupView(type:.normal)
            cell.configureCell()
            return cell
        }
        
        if collectionView == areaCollectionView{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as? filterCell2 else{return UICollectionViewCell()}
            if let city = selectedArea{
                if city.Fid == areas[indexPath.item].Fid{
                    cell.isSelected = true
                    //                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.title = areas[indexPath.item].title ?? ""
            cell.setupView(type:.normal)
            cell.configureCell()
            return cell
        }
        
        if collectionView == self.skillsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCollectionViewCell", for: indexPath) as! SkillCollectionViewCell
            
            cell.title = self.tags[indexPath.row].name ?? ""
            cell.btnRemove.isHidden = true
            
            cell.layoutIfNeeded()
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
}

extension NewProductViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCollectionView{
            let height = self.imageCollectionView.bounds.height - 16
            return CGSize(width: height, height: height)
        }
        
        if collectionView == adCategoryCollectionView{
            let height = self.adCategoryCollectionView.bounds.height - 16
            let width = (categoryfilters[indexPath.item].title?.getLabelWidth(font: AppFonts.normal))! + 32
            return CGSize(width: width, height: 30)
        }
        
        if collectionView == subCategoryCollectionView{
            let height = self.subCategoryCollectionView.bounds.height - 16
            let width = (subCategoryFilters[indexPath.item].title?.getLabelWidth(font: AppFonts.normal))! + 32
            return CGSize(width: width, height: 30)
        }
        
        if collectionView == cityCollectionView{
            return CGSize(width: cities[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: 30)
        }
        if collectionView == areaCollectionView{
            return CGSize(width: areas[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: 30)
        }
        
        if collectionView == self.skillsCollectionView {
            let width = self.tags[indexPath.row].name!.getLabelWidth(font: AppFonts.normal) + 32
            
            return CGSize(width: width, height: 30)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == adCategoryCollectionView{
            guard let cell = collectionView.cellForItem(at: indexPath) as? filterCell2 else {return}
            
            if let value = selectedCategory{
                if value.Fid == categoryfilters[indexPath.item].Fid{
                    cell.isSelected = false
                    selectedCategory = nil
                    collectionView.deselectItem(at: indexPath, animated: true)
                    self.hideSubCategoryView()
                }else{
                    selectedCategory = categoryfilters[indexPath.item]
                    selectedSubCategory = nil
                    cell.isSelected = true
                    self.getSubCategories()
                }
            }else{
                selectedCategory = categoryfilters[indexPath.item]
                cell.isSelected = true
                self.getSubCategories()
            }
            cell.configureCell()
            
        }
        if collectionView == subCategoryCollectionView{
            guard let cell = collectionView.cellForItem(at: indexPath) as? filterCell2 else {return}
            if let value = selectedSubCategory{
                if value.Fid == subCategoryFilters[indexPath.item].Fid{
                    selectedSubCategory = nil
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }else{
                    selectedSubCategory = subCategoryFilters[indexPath.item]
                    cell.isSelected = true
                }
            }else{
                selectedSubCategory = subCategoryFilters[indexPath.item]
                cell.isSelected = true
            }
            cell.configureCell()
        }
        if collectionView == cityCollectionView{
            guard let cell = collectionView.cellForItem(at: indexPath) as? filterCell2 else {return}
            if let value = selectedCity{
                if value.Fid == cities[indexPath.item].Fid{
                    cell.isSelected = false
                    selectedCity = nil
                    collectionView.deselectItem(at: indexPath, animated: true)
                    self.HideAreaView()
                }else{
                    selectedCity = cities[indexPath.item]
                    cell.isSelected = true
                    self.getAreas()
                }
            }else{
                selectedCity = cities[indexPath.item]
                cell.isSelected = true
                self.getAreas()
            }
            cell.configureCell()
            
        }else if collectionView == areaCollectionView{
            guard let cell = collectionView.cellForItem(at: indexPath) as? filterCell2 else {return}
            if let value = selectedArea{
                if value.Fid == areas[indexPath.item].Fid{
                    selectedArea = nil
                    cell.isSelected = false
                    collectionView.deselectItem(at: indexPath, animated: true)
                }else{
                    selectedArea = areas[indexPath.item]
                    cell.isSelected = true
                }
            }else{
                selectedArea = areas[indexPath.item]
                cell.isSelected = true
            }
            cell.configureCell()
        }
        
        
        if collectionView == imageCollectionView{
            if indexPath.item == images.count{
                takePhoto()
            }else{
                let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
                if let image = cell.iamgeView.image{
                    self.showFullScreenImage(image: image)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        if collectionView == adCategoryCollectionView {
            guard let  cell = collectionView.cellForItem(at: indexPath) as? filterCell2 else{ return}
            selectedCategory = nil
            selectedSubCategory = nil
            cell.isSelected = false
            cell.configureCell()
        }
        if collectionView == subCategoryCollectionView{
            guard let  cell = collectionView.cellForItem(at: indexPath) as? filterCell2 else{ return}
            selectedSubCategory = nil
            cell.isSelected = false
            cell.configureCell()
        }
        if collectionView == cityCollectionView{
            if let cell = collectionView.cellForItem(at: indexPath) as? filterCell2{
                selectedCity = nil
                cell.isSelected = false
                cell.configureCell()
            }
        }
        if collectionView == areaCollectionView{
            if let cell = collectionView.cellForItem(at: indexPath) as? filterCell2{
                selectedArea = nil
                cell.isSelected = false
                cell.configureCell()
            }
        }
        
    }
    
}

// MARK:- AddSkillDelegate
extension NewProductViewController: AddSkillDelegate {
    func didAddTags(_ tags: [Tag]) {
        self.tags = tags

        self.skillsCollectionView.reloadData()
        self.skillsCollectionViewConstant.constant = self.skillsCollectionView.contentSize.height
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
        viewWillLayoutSubviews()
    }
}


// image handleras
extension NewProductViewController: ImageCellDelegete{
    
    override func setImage(image: UIImage) {
        images.append(image)
        self.imageCollectionView.reloadData()
    }
    
    func deleteImage(tag: Int) {
        self.images.remove(at: tag)
        self.imageCollectionView.reloadData()
    }
    
    func deleteVideo(tag: Int) {
        
    }
}

