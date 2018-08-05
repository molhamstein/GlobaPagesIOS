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
    let bussinesCellId = ""
    
    var adds:[Ads] = []
    var filters:[String] = ["Real States","Jobs","Cars","Restaurants"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNavBarTitle(title: "My Profile")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.showNavBackButton = true
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
        
        self.categoryCollectionView.delegate = self
        self.categoryCollectionView.dataSource = self
        self.myAdsCollectionView.delegate = self
        self.myAdsCollectionView.dataSource = self
        
        self.myBussinessCollectionView.delegate = self
        self.myBussinessCollectionView.dataSource = self
        
        getAds()
    }
    
    override func backButtonAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func getAds(){
        
        adds.append(Ads(title:"Villa for sale in Saburah", image: "AI_Image", info: "Damascus Al-Mazzeh Villas", tag: "Real Estate", address: "", type: .titled))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "", type: .image))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "", type: .image))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "", type: .image))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "", type: .image))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "", type: .image))
        
        adds.append(Ads(title:"Villa for sale in Saburah", image: "AI_Image", info: "Damascus Al-Mazzeh Villas", tag: "Real Estate", address: "", type: .titled))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "", type: .image))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate", address: "", type: .image))
        
        adds.append(Ads(title: "Damascus Al-Mazzeh Villas", image: "AI_Image", info: "Villa for sale in Saburah", tag: "Real Estate dsfsdfs ", address: "", type: .image))
        
        adds.append(Ads(title:"Villa for sale in Saburah", image: "AI_Image", info: "Damascus Al-Mazzeh Villas", tag: "Real Estate", address: "", type: .titled))
        self.myAdsCollectionView.collectionViewLayout.invalidateLayout()
        self.myAdsCollectionView.reloadData()
        
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
            return adds.count
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
            let ad = adds[indexPath.item]
            if ad.type == .image{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adImagedCellId, for: indexPath) as! AdsImageCell
            cell.add = adds[indexPath.item]
                cell.resizeTagView()
                return cell
                
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: adTitledCellId, for: indexPath) as! AdsTitledCell
                cell.add = adds[indexPath.item]
                cell.resizeTagView()
                return cell
            }

        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
            cell.isSelected = true
            cell.configureCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView{
            let cell = collectionView.cellForItem(at: indexPath) as! filterCell2
            cell.isSelected = false
            cell.configureCell()
        }
    }

    
    func getCellContentSize(indexPath:IndexPath) -> CGFloat{
        var height:CGFloat = 0
        if adds[indexPath.item].type == .image{
            height += 100
        }else{
            height += self.adds[indexPath.item].title.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17))
            height += 16
        }
        height += (self.adds[indexPath.item].address.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17)))
        height += (self.adds[indexPath.item].info.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: UIFont.systemFont(ofSize: 17)))
        height += (32)
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
            return CGSize(width: self.view.frame.width * 0.5 - 32, height: height)//getCellContentSize(indexPath: indexPath))
        }
        return CGSize(width: 0, height: 0)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
}
