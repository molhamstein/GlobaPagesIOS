//
//  ProfileViewController.swift
//  GlobalPages
//
//  Created by Nour  on 8/4/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit

class ProfileViewController: AbstractController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var usernameTitleLabel: XUILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailTitleLabel: XUILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var adsCountTitleLabel: XUILabel!
    @IBOutlet weak var adsCountLabel: UILabel!
    @IBOutlet weak var categoriesTitleLabel: XUILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var myAdsTitleLabel: XUILabel!
    @IBOutlet weak var myAdsCollectionView: UICollectionView!
    @IBOutlet weak var myBussinessTitleLabel: XUILabel!
    @IBOutlet weak var myBussinessCollectionView: UICollectionView!
    
    let categoryCellId = "filterCell2"
    let adImagedCellId = "AdsImageCell"
    let adTitledCellId = "AdsTitledCell"
    let bussinesCellId = "BussinessGuidListCell"
    
    var posts:[Post] = []
    var bussiness:[Bussiness] = []
    
    var filters:[String] = ["Real States","Jobs","Cars","Restaurants"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarTitle(title: "My Profile")
        // Do any additional setup after loading the view.
        fillUserData()
        fetchUserData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.showNavBackButton = true
       //
        self.showNavEditButton = true
    }
    
    override func customizeView() {
        super.customizeView()
        //fonts
        self.usernameTitleLabel.font = AppFonts.normal
        self.usernameLabel.font = AppFonts.bigBold
        self.emailTitleLabel.font = AppFonts.normal
        self.emailLabel.font = AppFonts.bigBold
        self.adsCountTitleLabel.font = AppFonts.normal
        self.adsCountLabel.font = AppFonts.bigBold
        self.categoriesTitleLabel.font = AppFonts.bigBold
        self.myAdsTitleLabel.font = AppFonts.bigBold
        self.myBussinessTitleLabel.font = AppFonts.bigBold
        
        setupCollectionViews()
    }
    
    
    func setupCollectionViews(){
        let nib = UINib(nibName: categoryCellId, bundle: nil)
        self.categoryCollectionView.register(nib, forCellWithReuseIdentifier: categoryCellId)
        
        let imagedNib = UINib(nibName: adImagedCellId, bundle: nil)
        self.myAdsCollectionView.register(imagedNib, forCellWithReuseIdentifier: adImagedCellId)
        
        let titledNib = UINib(nibName: adTitledCellId, bundle: nil)
        self.myAdsCollectionView.register(titledNib, forCellWithReuseIdentifier: adTitledCellId)
        
        
        self.myBussinessCollectionView.register(UINib(nibName: bussinesCellId, bundle: nil), forCellWithReuseIdentifier: bussinesCellId)
        
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        self.myAdsCollectionView.delegate = self
        self.myAdsCollectionView.dataSource = self
        
        self.myBussinessCollectionView.delegate = self
        self.myBussinessCollectionView.dataSource = self
        
        getAds()
        getBussiness()
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func fillUserData(){
        guard let user = DataStore.shared.me else {return}
        if let username = user.userName {self.usernameLabel.text = username}
        if let email = user.email{self.emailLabel.text = email}
//        if let birdate = user.birthdate{self.da}
        if let count = user.postsCount {self.adsCountLabel.text = "\(count)"}
        
    }
    
    func fetchUserData(){
        
        self.showActivityLoader(true)
        ApiManager.shared.getMe { (success, error, user) in
            self.showActivityLoader(false)
            if success{ self.fillUserData() }
            if error != nil{}
        }
    }
    
    func getAds(){
        guard let ownerId = DataStore.shared.me?.objectId else { return }
        self.showActivityLoader(true)
        ApiManager.shared.getUserPosts(ownerId: ownerId) { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                self.posts = result
                self.myAdsCollectionView.collectionViewLayout.invalidateLayout()
                self.myAdsCollectionView.reloadData()
            }
            if error != nil{}
        }
    }
    
    func getBussiness(){
        guard let ownerId = DataStore.shared.me?.objectId else { return }
        self.showActivityLoader(true)
        ApiManager.shared.getUserBussiness(ownerId: ownerId) { (success, error, result) in
            self.showActivityLoader(false)
            if success{
                self.bussiness = result
                self.myBussinessCollectionView.collectionViewLayout.invalidateLayout()
                self.myBussinessCollectionView.reloadData()
            }
            if error != nil{}
        }
    }
}


extension ProfileViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView{
            return filters.count
        }
        if collectionView == myAdsCollectionView {
            return posts.count
        }
        
        if collectionView == myBussinessCollectionView {
         return bussiness.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! filterCell2
            cell.title = filters[indexPath.item]
            cell.setupView(type: .normal)
            collectionView.deselectItem(at: indexPath, animated: true)
            cell.isSelected = false
            return cell
        }
        if collectionView == myAdsCollectionView{
            let post = posts[indexPath.item]
            if post.type == .image{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adImagedCellId, for: indexPath) as! AdsImageCell
                cell.post = post
                cell.resizeTagView()
                return cell
                
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adTitledCellId, for: indexPath) as! AdsTitledCell
                cell.post = post
                cell.resizeTagView()
                return cell
            }

        }
        if collectionView == myBussinessCollectionView{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bussinesCellId, for: indexPath) as! BussinessGuidListCell
            cell.bussiness = bussiness[indexPath.item]
            cell.profileMode()
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
            cell.isSelected = true
            cell.configureCell()
        }
        if collectionView == myAdsCollectionView{
            let post = self.posts[indexPath.item]
            let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "NewAdViewController") as! NewAdViewController
            vc.tempPost = post
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if collectionView == myBussinessCollectionView{
            
         let vc = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "BussinessDescriptionViewController") as! BussinessDescriptionViewController
         self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
            cell.isSelected = false
            cell.configureCell()
        }
        
        if collectionView == myBussinessCollectionView{
            
            
        }
    }

    
    func getCellContentSize(indexPath:IndexPath) -> CGFloat{
        var height:CGFloat = 0
        let post = posts[indexPath.item]
        if post.type == .image{
            height += 100 // image heigh
            height += 10 // half of the tag view
            height += (post.city?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17))) ?? 0 // city label height
            height += 8
            height += (post.location?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17))) ?? 0 // area label height
            height += 18 // line view + 8 + 8
            height += (post.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17))) ?? 0 // title label height
        }
        else{
            height += (post.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17))) ?? 0 // title label height
            height += 20 // tag view height
            height += (post.description?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17))) ?? 0 // description label Height
            height += 18 // line view + 8 + 8
            height += (post.city?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17))) ?? 0 // city label height
            height += 8 // padding
            height += (post.location?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17))) ?? 0 // area label height
        }

        return height
    }

}


extension ProfileViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView{
            let height = self.categoryCollectionView.bounds.height - 24
            let width = filters[indexPath.item].getLabelWidth(font: AppFonts.normal) + 32
            return CGSize(width: width, height: height)
        }
        
        if collectionView == myAdsCollectionView{
            let height = myAdsCollectionView.bounds.height - 16
            return CGSize(width: self.view.frame.width * 0.5 , height: height)//getCellContentSize(indexPath: indexPath))
        }
        if collectionView == myBussinessCollectionView{
            let height:CGFloat = 72//self.myBussinessCollectionView.bounds.height - 24
            let width = self.myBussinessCollectionView.bounds.width * 0.7
            return CGSize(width: width, height: height)
        }
        return CGSize(width: 0, height: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
}
