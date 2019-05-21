//
//  CategoriesSubscriptionViewController.swift
//  GlobalPages
//
//  Created by Nour  on 1/20/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

class CategoriesSubscriptionViewController: AbstractController {


    @IBOutlet weak var infoLabel: XUILabel!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var categoryView: UIView!
    @IBOutlet weak var subCategoryView: UIView!
    @IBOutlet weak var subCategoryTitleLabel: UILabel!
    @IBOutlet weak var subCategoryCollectionView: UICollectionView!


    var categoryfiltertype:categoryFilterType = .Category

    var filtterCellId = "filterCell2"
    var filters:[categoriesFilter] = []

    var selectedCategory:categoriesFilter?

    var categoryfilters:[categoriesFilter]{
        return DataStore.shared.postCategories.filter{$0.parentCategoryId == nil}
    }


    var subCategoryFilters:[categoriesFilter]{
        if let cat = selectedCategory{
            return DataStore.shared.postCategories.filter({$0.parentCategoryId == cat.Fid})
        }
        return []
    }

    var selectedSubCategories:[categoriesFilter] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.navigationController?.navigationBar.tintColor = .white
//        getBussinessFilters()
    }


    override func customizeView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(5.0)
        getUserCategories()
        // fonts
        self.infoLabel.font = AppFonts.big
        self.categoryTitleLabel.font = AppFonts.big
        self.subCategoryTitleLabel.font = AppFonts.big

        let nib = UINib(nibName: filtterCellId, bundle: nil)
        self.categoryCollectionView.register(nib, forCellWithReuseIdentifier: filtterCellId)
        self.subCategoryCollectionView.register(nib, forCellWithReuseIdentifier: filtterCellId)
        subCategoryCollectionView.allowsMultipleSelection = true
    }
    
    func getUserCategories(){
        guard let user = DataStore.shared.me else{return}
//        guard subCategoryFilters.count > 0 else {return}
        let subCat = DataStore.shared.postCategories.filter({$0.parentCategoryId != nil})
        if let posts = user.posts{
            for post in posts{
                for subcat in subCat {
                    if subcat.Fid == post{
                        self.selectedSubCategories.append(subcat)
                    }
                }
            }
        }
        subCategoryCollectionView.reloadData()
    }

    override func buildUp() {
        self.showNavBackButton = true
        self.categoryView.animateIn(mode: .animateInFromRight, delay: 0.2)
    }

    @IBAction func backAction(_ sender: Any) {
//        if subCategoryView.isHidden == false{
//            self.showCategory()
//        }else{
            self.dismiss(animated: true, completion: nil)

//    }
    }




    func getBussinessFilters(){
        self.showActivityLoader(true)
        ApiManager.shared.businessCategories { (success, error, result ,cats) in
            self.showActivityLoader(false)
            if success{
                self.filters = result
                self.categoryCollectionView.reloadData()
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }
    }

    @IBAction func apply(_ sender: UIButton) {

        self.showActivityLoader(true)
        ApiManager.shared.updateUser(user: DataStore.shared.me!,categories: selectedSubCategories) { (success, error, user) in
            self.showActivityLoader(false)
            if success {
                self.popOrDismissViewControllerAnimated(animated: true)
            }
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        }

    }

}


extension CategoriesSubscriptionViewController:UICollectionViewDelegate,UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {return categoryfilters.count}
        if collectionView == subCategoryCollectionView {return subCategoryFilters.count}
        return 0
    }



    // load collecton view cells

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as? filterCell2 else{return UICollectionViewCell()}
            if let category = categoryfiltertype.filter.category{
                if category.Fid == categoryfilters[indexPath.item].Fid{
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                    self.showSubCategory()
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            }else{
                collectionView.deselectItem(at: indexPath, animated: true)
                cell.isSelected = false
            }
            cell.filter = categoryfilters[indexPath.item]
            cell.setupView(type:.map)
            return cell
        }


        if collectionView == subCategoryCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as? filterCell2 else{return UICollectionViewCell()}
                let category = subCategoryFilters[indexPath.item]
            if  selectedSubCategories.contains(where: { (cat) -> Bool in category.Fid == cat.Fid}){
                    cell.isSelected = true
                    collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init(rawValue: UInt(indexPath.item)))
                }else{
                    collectionView.deselectItem(at: indexPath, animated: true)
                    cell.isSelected = false
                }
            cell.titleLabel.text = subCategoryFilters[indexPath.item].title
            cell.setupView(type:.map)
            cell.configureCell()
            return cell
        }

        return UICollectionViewCell()
    }



    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            self.selectedCategory = categoryfilters[indexPath.item]
            self.showSubCategory()
        }
        if collectionView == subCategoryCollectionView{
            let cat = subCategoryFilters[indexPath.item]
            if selectedSubCategories.contains(where: { (category) -> Bool in category.Fid == cat.Fid}){
                selectedSubCategories = selectedSubCategories.filter({$0.Fid != cat.Fid})
            }else{
                selectedSubCategories.append(cat)
            }
            subCategoryCollectionView.reloadData()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == subCategoryCollectionView{
            let cat = subCategoryFilters[indexPath.item]
            if selectedSubCategories.contains(where: { (category) -> Bool in category.Fid == cat.Fid}){
                selectedSubCategories = selectedSubCategories.filter({$0.Fid != cat.Fid})
            }else{
                selectedSubCategories.append(cat)
            }
            subCategoryCollectionView.reloadData()
        }
    }


    func showSubCategory(){
        //      self.categoryView.animateIn(mode: .animateOutToLeft, delay: 0.2)
        subCategoryCollectionView.reloadData()
//        dispatch_main_after(0.2) {
//            self.subCategoryView.isHidden = false
//            self.subCategoryView.animateIn(mode: .animateInFromRight, delay: 0.2)
//            self.categoryView.isHidden = true
//        }

    }

    func showCategory(){
        //   self.subCategoryView.animateIn(mode: .animateOutToRight, delay: 0.2)
        dispatch_main_after(0.2) {
            self.categoryView.isHidden = false
            self.categoryView.animateIn(mode: .animateInFromLeft, delay: 0.2)
            self.subCategoryView.isHidden = true

        }
    }

    func show3NearBy(){
        NotificationCenter.default.post(name: .notificationShow3NearByChanged, object: nil)
        self.dismiss(animated: true, completion: nil)
    }

}

// setup Cell and header Size

extension CategoriesSubscriptionViewController:UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            return CGSize(width: categoryfilters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 36, height: (47.5 * ScreenSizeRatio.smallRatio) - 16)
        }

        if collectionView == subCategoryCollectionView{
            return CGSize(width: subCategoryFilters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 36, height: (47.5 * ScreenSizeRatio.smallRatio) - 16)

        }
        return CGSize(width:0, height: 0)
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }



}

