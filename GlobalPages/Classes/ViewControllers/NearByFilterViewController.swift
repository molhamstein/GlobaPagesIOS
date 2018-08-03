//
//  NearByFilterViewController.swift
//  GlobalPages
//
//  Created by Nour  on 7/23/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class NearByFilterViewController: AbstractController {
    
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
        return filters.filter{$0.parentCategoryId == nil}
    }
    
    var subCategoryFilters:[categoriesFilter]{
        if let cat = selectedCategory{
            return filters.filter({$0.parentCategoryId == cat.Fid})
        }
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
         self.navigationController?.navigationBar.tintColor = .white
        
        getBussinessFilters()
    }
    
    
    override func customizeView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            // fonts
        self.infoLabel.font = AppFonts.big
        self.categoryTitleLabel.font = AppFonts.big
        self.subCategoryTitleLabel.font = AppFonts.big
        
        let nib = UINib(nibName: filtterCellId, bundle: nil)
        self.categoryCollectionView.register(nib, forCellWithReuseIdentifier: filtterCellId)
        self.subCategoryCollectionView.register(nib, forCellWithReuseIdentifier: filtterCellId)
    }
    
    override func buildUp() {
        self.showNavBackButton = true
        self.categoryView.animateIn(mode: .animateInFromRight, delay: 0.2)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if subCategoryView.isHidden == false{
            self.showCategory()
        }else{self.dismiss(animated: true, completion: nil)}
    }
    
    
    
    
    func getBussinessFilters(){
        self.showActivityLoader(true)
        ApiManager.shared.businessCategories { (success, error, result) in
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

    
}


extension NearByFilterViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as! filterCell2
            if let category = categoryfiltertype.filter.category{
                if category.Fid == categoryfilters[indexPath.item].Fid{
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
            cell.filter = categoryfilters[indexPath.item]
            cell.setupView(type:.map)
            return cell
        }
        
        
        if collectionView == subCategoryCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FiltersViewController.filtterCellId, for: indexPath) as! filterCell2
            
            if let category = categoryfiltertype.filter.category{
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
            cell.filter = subCategoryFilters[indexPath.item]
            cell.setupView(type:.map)
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
            show3NearBy()
        }
    }
    
    
    func showSubCategory(){
  //      self.categoryView.animateIn(mode: .animateOutToLeft, delay: 0.2)
        subCategoryCollectionView.reloadData()
        dispatch_main_after(0.2) {
            self.subCategoryView.isHidden = false
            self.subCategoryView.animateIn(mode: .animateInFromRight, delay: 0.2)
            self.categoryView.isHidden = true
        }
        
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

extension NearByFilterViewController:UICollectionViewDelegateFlowLayout{
    
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

