//
//  JobsViewController.swift
//  GlobalPages
//
//  Created by Abd Hayek on 10/29/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

class JobsViewController: AbstractController {

    @IBOutlet weak var jobsCollectionView: UICollectionView!
    @IBOutlet weak var filterCollectionView: UICollectionView!
    @IBOutlet weak var btnSearch: UIButton!
    
    fileprivate var jobs: [Job] = []
    fileprivate var filters: [categoriesFilter] = []
    fileprivate var isFirstTime: Bool = true // this is for the cache issue
    fileprivate var currentPage: Int = 0 {
        didSet {
            getJobs()
        }
    }
    fileprivate var pageLimit = 100
    fileprivate var selectedJob: Job?
    fileprivate var isSelectedJobNew: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func buildUp() {
        jobsCollectionView.delegate = self
        jobsCollectionView.dataSource = self
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        jobsCollectionView.register(UINib(nibName: "JobOfferCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "JobOfferCollectionViewCell")
        filterCollectionView.register(UINib(nibName: HomeViewController.filtterCellId, bundle: nil), forCellWithReuseIdentifier: HomeViewController.filtterCellId)
        
        getFilters()
    }
    
    override func customizeView() {
        title = "JOB_TITLE".localized
        Filter.jobOffer.clear();
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toJobDescription" {
            let vc = segue.destination as! JobDescriptionViewController
            vc.job = self.selectedJob
            vc.showBudget = isSelectedJobNew
        }
    }
}

// MARK:- IBAction
extension JobsViewController {
    @IBAction func BackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SearchAction(_ sender: UIButton) {
        ActionShowFilters.execute(type: .JobOffer)
    }
}

// MARK:- Functions
extension JobsViewController {
    func getFilters(){
        if !DataStore.shared.didChangedFilters && !isFirstTime {
            return
        }
        DataStore.shared.didChangedFilters = false
        
        filters.removeAll()
        if let keyWord = Filter.jobOffer.keyWord {
            let cat = categoriesFilter()
            cat.filtervalue = .keyword
            cat.titleAr = keyWord
            cat.titleEn = keyWord
            filters.append(cat)
        }
        if let city = Filter.jobOffer.city{
            city.filtervalue = .city
            filters.append(city)
            if let area = Filter.jobOffer.area{
                area.filtervalue = .area
                filters.append(area)
            }
        }else{
            let cat = categoriesFilter()
            cat.titleAr = "كل المدن"
            cat.titleEn = "All Cities"
            cat.Fid = nil
            filters.append(cat)
        }
        
        if let cat = Filter.jobOffer.category{
            cat.filtervalue = .category
            filters.append(cat)
            if let subCat = Filter.jobOffer.subCategory{
                subCat.filtervalue = .subCategory
                filters.append(subCat)
            }
        }else{
            let cat = categoriesFilter()
            cat.titleAr = "كل الفئات"
            cat.titleEn = "All Categories"
            cat.Fid = nil
            filters.append(cat)
        }
        isFirstTime = true
        filterCollectionView.reloadData()
        currentPage = 0
    }
    
    func getJobs(){
        self.showActivityLoader(true)
        ApiManager.shared.getJobs(keyword: Filter.jobOffer.keyWord, catId: Filter.jobOffer.category?.Fid, subCatId: Filter.jobOffer.subCategory?.Fid, cityId: Filter.jobOffer.city?.Fid, pageLimit: pageLimit, page: currentPage, completionBlock: {success, error, result in
            
            self.showActivityLoader(false)
            
            if success{
                if self.isFirstTime {
                    self.isFirstTime = false
                    self.jobs = result
                }else{
                    self.jobs.append(contentsOf:result)
                }
                
                self.jobsCollectionView.reloadData()
            }
            
            if error != nil{
                if let msg = error?.errorName{
                    self.showMessage(message: msg, type: .error)
                }
            }
        })
        
    }
}

// MARK:- UICollectionViewDelegate
extension JobsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case self.jobsCollectionView:
            return self.jobs.count
        //    return 5
        case self.filterCollectionView:
            return filters.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case self.jobsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "JobOfferCollectionViewCell", for: indexPath) as! JobOfferCollectionViewCell
            
            cell.configureCell(self.jobs[indexPath.row])
            
            return cell
            
        case self.filterCollectionView:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.filtterCellId, for: indexPath) as! filtterCell
            cell.filter = filters[indexPath.item]
            cell.tag = indexPath.item
            cell.delegate = self
            
            return cell
        default:
            return UICollectionViewCell()
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.jobsCollectionView:
            let cell = collectionView.cellForItem(at: indexPath) as! JobOfferCollectionViewCell
            self.selectedJob = self.jobs[indexPath.row]
            self.isSelectedJobNew = cell.isNew
            
            self.performSegue(withIdentifier: "toJobDescription", sender: self)
            
        case self.filterCollectionView:
            ActionShowFilters.execute(type: .JobOffer)
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.jobsCollectionView:
            return CGSize(width: self.jobsCollectionView.frame.width, height: 100)
            
        case self.filterCollectionView:
            return CGSize(width: filters[indexPath.item].title!.getLabelWidth(font: AppFonts.normal) + 36, height: 30)
        default:
            return .zero
        }

        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let collectionView = scrollView as? UICollectionView {
            if collectionView == self.jobsCollectionView {
                let offset:CGFloat = 100
                let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
                if (bottomEdge + offset >= scrollView.contentSize.height) {
                    
                    currentPage = currentPage +  pageLimit
                }
            }
        }
    }
    
}

// MARK:- FilterCellDelegate
extension JobsViewController: filterCellProtocol {
    func removeFilter(filter: categoriesFilter) {
        filter.filtervalue?.removeFilter(fltr: Filter.jobOffer)
        DataStore.shared.didChangedFilters = true
        getFilters()
    }
}
