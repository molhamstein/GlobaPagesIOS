//
//  NewAdViewController.swift
//  GlobalPages
//
//  Created by Nour  on 8/4/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class NewBussinesesViewController: AbstractController {
    
    
    // outlates
    @IBOutlet weak var adTitleLabel: UILabel!
    @IBOutlet weak var adtitleTextField: UITextField!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var imagesTitleLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var phonenumber1TitleLabel: XUILabel!
    @IBOutlet weak var phonenumber1TextField: XUITextField!
    @IBOutlet weak var phonenumber2TitleLabel: XUILabel!
    @IBOutlet weak var phonenumber2TextField: XUITextField!
    
    @IBOutlet weak var adCategoryTitleLabel: UILabel!
    
    @IBOutlet weak var adCategoryCollectionView: UICollectionView!
    
    @IBOutlet weak var subCategortTitleLabel: UILabel!
    
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!
    @IBOutlet weak var locationTextField: XUITextField!
    
    @IBOutlet weak var locationTitleLabel: XUILabel!
    @IBOutlet weak var faxTitleLabel: XUILabel!
    @IBOutlet weak var faxTextView: UITextView!
    @IBOutlet weak var subCategoryView: UIView!
    @IBOutlet weak var hideAbleView1: UIView!
    @IBOutlet weak var hideAbelView2: UIView!
    @IBOutlet weak var addButton: XUIButton!
    @IBOutlet weak var subCategoryHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectLocationButton: UIButton!
    
    @IBOutlet weak var openDaysBGView: UIView!
    @IBOutlet weak var openDayView: UIView!
    @IBOutlet var openDaysButtons: [UIButton]!
    @IBOutlet weak var openDaysButtonView: UIView!


    //city views
    @IBOutlet weak var cityTitleLabel: UILabel!
    @IBOutlet weak var cityCollectionView: UICollectionView!

    @IBOutlet weak var areaTitleLabel: UILabel!
    @IBOutlet weak var areaCollectionView: UICollectionView!

    @IBOutlet weak var areaView: UIView!
    var selectedCity:City?
    var selectedArea:City?
    var cities:[City] { return DataStore.shared.cities }
    var areas:[City]  {
        if let city = selectedCity { return city.locations ?? [] }
        return []
    }

    var citiesCount = 0
    var areasCount = 0
    var cityId = ""
    var locationId = ""

    
    var subCategoryViewHeight:CGFloat = 0{
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
    
    var selectedCategory:Category?
    var selectedSubCategory:Category?{
        didSet{
            if selectedSubCategory?.code == "pharmacies" {
                isOpenDay = true
            }else{
                isOpenDay = false
            }
        }
    }
    
    var categoryfilters:[Category]{
        return DataStore.shared.categories.filter { $0.parentCategoryId == nil }
    }
    var subCategoryFilters:[Category] {
        if let cat = selectedCategory {
            return DataStore.shared.categories.filter({$0.parentCategoryId == cat.Fid}) }
        return []
    }
    
    
    var openDays:[Bool] = [false,false,false,false,false,false,false,false]
    var isOpenDay:Bool = false{
        didSet{
            openDaysButtonView.isHidden = !isOpenDay
        }
    }
    
    var categoriesCount = 0
    var subCategoriesCount = 0
    
    var selectedLocation:Location?
    
    var tempBussiness:Bussiness?
    
    var editMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subCategoryViewHeight = 0
   
        if let bussiness = tempBussiness{
            fillData()
            editMode = true
            print(bussiness.dictionaryRepresentation())
        }
        else{
            tempBussiness = Bussiness()
        }
        
        if !editMode{
            self.setNavBarTitle(title: "Add New Bussiness".localized)
        }else{
            self.setNavBarTitle(title: "Edit Bussiness".localized)
        }
//        getBussinessFilters()
//        getCityFilters()
        self.subCategoryView.isHidden = false
        self.areaView.isHidden = true
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.showNavBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.addButton.applyStyleGredeant()
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
        self.phonenumber1TitleLabel.font = AppFonts.big
        self.phonenumber1TextField.font = AppFonts.xBigBold
        self.phonenumber2TitleLabel.font = AppFonts.big
        self.phonenumber2TextField.font = AppFonts.xBigBold
        self.locationTextField.font = AppFonts.xBigBold
        self.faxTitleLabel.font = AppFonts.big
        self.faxTextView.font = AppFonts.xBigBold
        self.addButton.titleLabel?.font = AppFonts.bigBold
        
        // texts
        self.adtitleTextField.placeholder = "NEW_PRODUCT_NAME_PLACEHOLDER".localized
        self.descriptionTextView.placeholder = "(Optional)".localized
        self.faxTextView.placeholder = "(Optional)".localized
        self.phonenumber1TextField.placeholder = "(Optional)".localized
        self.phonenumber2TextField.placeholder = "(Optional)".localized
        self.locationTextField.placeholder = "(Optional)".localized
        if !editMode{
            self.addButton.setTitle("ADD_BUTTON_TITLE".localized, for: .normal)
        }else{
            self.addButton.setTitle("Update".localized, for: .normal)
        }
        self.locationTextField.addIconButton(image: "ic_nearby")


        setupCollectionViews()

    }
    
    
    func fillData(){
        
        guard let bussiness = tempBussiness else {return}
        if let name = bussiness.nameEn {self.adtitleTextField.text = name}
        if let array = bussiness.media{
            var count = 0
            for mediaObj in array{
                let imageView = UIImageView()
                if let url = mediaObj.fileUrl{
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
        }
        
        if let phone = bussiness.phone1 {self.phonenumber1TextField.text = phone}
        if let phone = bussiness.phone2 {self.phonenumber2TextField.text = phone}

        if let location = bussiness.address { self.locationTextField.text = location}
        if let desc = bussiness.description {self.descriptionTextView.text = desc}
        if let fax = bussiness.fax {self.faxTextView.text = fax}
        
        if let days = bussiness.openingDays{
            for day in days{
                if day == 7 {
                    openDaysButtons[0].isSelected = true
                }else if day != 0{
                    openDaysButtons[day].isSelected = true
                }
                if day != 0 {
                    openDays[day] = true
                }
            }
        }


        selectedCategory = bussiness.category
        selectedSubCategory = bussiness.subCategory
        if let city = bussiness.city{
            selectedCity = city
        }else if let id = bussiness.cityId{
            let city = City()
            city.Fid = id;
            selectedCity = city
        }


        if let city = bussiness.location{
            selectedArea = city
        }else if let id = bussiness.locationId{
            let city = City()
            city.Fid = id;
            selectedArea = city
        }

        self.cityCollectionView.reloadData()
        self.areaCollectionView.reloadData()
        self.adCategoryCollectionView.reloadData()
        self.subCategoryCollectionView.reloadData()
//        scrollToSelected()

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
    
    func getBussinessFilters(){
        self.showActivityLoader(true)
        ApiManager.shared.businessCategories { (success, error, result , cats) in
            self.showActivityLoader(false)
            if success{
                DataStore.shared.categories = cats
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
        self.showActivityLoader(true)
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
                tempBussiness?.nameAr = title
                tempBussiness?.nameEn = title
        }else{
            self.showMessage(message: "please Enter a title".localized, type: .error)
            return false
        }
        
        if let phone = phonenumber1TextField.text , !phone.isEmpty{
            if phone.isPhoneNumber { tempBussiness?.phone1 = phone }
            else{
                self.showMessage(message: "Please enter a valid phone number".localized, type: .error)
                return false
            }
        }else{
            tempBussiness?.phone1 = nil
        }
        
        if let phone2 = phonenumber2TextField.text , !phone2.isEmpty{
            if phone2.isPhoneNumber { tempBussiness?.phone2 = phone2 }
            else{
                self.showMessage(message: "Please enter a valid phone number".localized, type: .error)
                return false
            }
        }else{
            tempBussiness?.phone2 = nil
        }
        
        
        if let cat = selectedCategory {
            tempBussiness?.categoryId = cat.Fid
        }else{
            self.showMessage(message: "please select a category".localized, type: .error)
            return false
        }
        
        
        if let cat = selectedSubCategory {
            tempBussiness?.subCategoryId = cat.Fid
        }else{
            self.showMessage(message: "please select a subCategory".localized, type: .error)
            return false
        }

        if let cat = selectedCity {
            cityId = cat.Fid!
            tempBussiness?.cityId = cityId
        }else{
            self.showMessage(message: "please select a city".localized, type: .error)
            return false
        }

        if let cat = selectedArea {
            locationId = cat.Fid!
            tempBussiness?.locationId = locationId
        }else{
            self.showMessage(message: "please select an area".localized, type: .error)
            return false
        }
        
        if let loc  = self.selectedLocation{
            tempBussiness?.locationPoint = Points()
            tempBussiness?.locationPoint?.lat = loc.lat
            tempBussiness?.locationPoint?.long = loc.long
        }
        
        if let address = locationTextField.text , !address.isEmpty {
            tempBussiness?.address = address
        }else{
            tempBussiness?.address =  nil
        }
        
        
        if let desc = descriptionTextView.text , !desc.isEmpty{
            tempBussiness?.description = desc
        }else{
            tempBussiness?.description = nil
        }
        
        if let fax = faxTextView.text , !fax.isEmpty{
            tempBussiness?.fax = fax
        }else{
            tempBussiness?.fax = nil
        }
        tempBussiness?.openingDaysEnabled = isOpenDay
        tempBussiness?.openingDays = Array<Int>()
        if isOpenDay {
        for i in 1...7 {
            if openDays[i]{
                tempBussiness?.openingDays?.append(i)
            }
            }
        }
        
        tempBussiness?.ownerId = DataStore.shared.me?.objectId
        return true
    }
    
    
    func uploadImages(){
        self.showActivityLoader(true)
        ApiManager.shared.uploadImages(images: self.images) { (urls, error) in
            self.media = urls
            self.tempBussiness?.media = urls
            if self.editMode{
                self.updateBussiness()
            }else{
                self.addBussiness()
            }
        }
    }
    
    override func backButtonAction(_ sender: AnyObject) {
//        self.dismiss(animated: true, completion: nil)
        self.popOrDismissViewControllerAnimated(animated: true)
    }
    
    @IBAction func addBusinessAction(_ sender: AnyObject) {
        if validate(){
            if self.images.count > 0{
                uploadImages()
                
            }else{
                self.showActivityLoader(true)
            if self.editMode{
                self.updateBussiness()
            }else{
                self.addBussiness()
                }
            }
        }
    }
    
    func addBussiness(){
        ApiManager.shared.addBussiness(bussiness: tempBussiness!) { (success, error) in
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
    
    
    func updateBussiness(){
        ApiManager.shared.editBussiness(bussiness: tempBussiness!) { (success, error) in
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
    // open Days view
    
    @IBAction func togglyDay(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        openDays[sender.tag] = sender.isSelected
        print(openDays)
    }
    
    @IBAction func showOpenDaysView(_ sender: UIButton) {
        self.openDaysBGView.isHidden = false
        self.openDayView.animateIn(mode: .animateInFromBottom, delay: 0.2)
    }
    
    @IBAction func hideDaysView(_ sender: UITapGestureRecognizer) {
        self.openDaysBGView.isHidden = true
    }
    
    
    @IBAction func selectRecipientLocation(_ sender: UIButton) {
        NotificationCenter.default.removeObserver(self, name: .notificationLocationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setLocation), name: .notificationLocationChanged, object: nil)
        openLocationSelector()
        
        self.locationTextField.addIconButton(image: "ic_nearby")
        let locationTextFieldRightButton = locationTextField.rightView as! UIButton
        locationTextFieldRightButton.addTarget(self, action: #selector(selectRecipientLocation(_:)), for: .touchUpInside)
    }
    
    func openLocationSelector() {
        
        let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func setLocation(){
        let loc = DataStore.shared.location
        self.selectLocationButton.isHidden = true
        self.selectedLocation = loc 
        self.locationTextField.text = loc.address ?? ""
    }
}


extension NewBussinesesViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    
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
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
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
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
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
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
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
        return UICollectionViewCell()
    }

}

extension NewBussinesesViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == imageCollectionView{
            let height = self.imageCollectionView.bounds.height - 16
            return CGSize(width: height, height: height)
        }
        
        if collectionView == adCategoryCollectionView{
            let height = self.adCategoryCollectionView.bounds.height - 16
            let width = (categoryfilters[indexPath.item].title?.getLabelWidth(font: AppFonts.normal))! + 32
            return CGSize(width: width, height: height)
        }
        
        if collectionView == subCategoryCollectionView{
            let height = self.subCategoryCollectionView.bounds.height - 16
            let width = (subCategoryFilters[indexPath.item].title?.getLabelWidth(font: AppFonts.normal))! + 32
            return CGSize(width: width, height: height)
        }

        if collectionView == cityCollectionView{
            return CGSize(width: cities[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: self.cityCollectionView.frame.height - 16)
        }
        if collectionView == areaCollectionView{
            return CGSize(width: areas[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 32, height: self.areaCollectionView.frame.height - 16)
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


// image handleras
extension NewBussinesesViewController:ImageCellDelegete{

    override func setImage(image: UIImage) {
        images.append(image)
        self.imageCollectionView.reloadData()
    }
    
    func deleteImage(tag: Int) {
        self.images.remove(at: tag)
        self.imageCollectionView.reloadData()
    }
    
    
}



