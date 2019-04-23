//
//  VolumeViewController.swift
//  GlobalPages
//
//  Created by Abdulrahman Alhayek on 4/23/19.
//  Copyright © 2019 GlobalPages. All rights reserved.
//

import UIKit

class VolumeViewController: AbstractController {

    @IBOutlet weak var adsCollectionView: UICollectionView!
    
    @IBOutlet weak var volumeTitle: UILabel!
    
    static var adsImageCellId = "AdsImageCell"
    static var adsTitledCellId = "AdsTitledCell"
    
    var categoryfiltertype:categoryFilterType = .Home
    
    var posts:[Post] {
        if let res = DataStore.shared.volume?.posts{
            var temp = res
            if let keyword = categoryfiltertype.filter.keyWord , !keyword.isEmpty{
                temp = temp.filter({($0.title?.lowercased().contains(find: keyword.lowercased()))!})
            }
            if let city = categoryfiltertype.filter.city{
                temp = temp.filter({$0.city?.Fid == city.Fid})
            }
            if let area = categoryfiltertype.filter.area{
                temp = temp.filter({$0.location?.Fid == area.Fid})
            }
            if let cat = categoryfiltertype.filter.category{
                temp = temp.filter({$0.category?.Fid == cat.Fid})
            }
            if let subCat = categoryfiltertype.filter.subCategory{
                temp = temp.filter({$0.subCategory?.Fid == subCat.Fid})
            }
            temp = temp.filter({$0.isActiviated})
            return temp
        }
        return []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewSetup()
        // Do any additional setup after loading the view.
    }

    override func customizeView() {

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.showNavBackButton = true
    }
    
    func collectionViewSetup(){
        
        self.volumeTitle.font = AppFonts.normalBold
        
        let layout = CustomLayout()
        layout.delegate = self
        
        adsCollectionView.collectionViewLayout = layout
        
        adsCollectionView.dataSource = self
        adsCollectionView.delegate = self
        
        setupCollectionViewLayout()
        
        self.adsCollectionView.reloadData()
        
        if let title = DataStore.shared.volume?.title{
            self.volumeTitle?.text = title
        }
    }
    
    func setupCollectionViewLayout() {
        
        // adds Collection view Cells
        let nib2 = UINib(nibName: HomeViewController.adsImageCellId, bundle: nil)
        self.adsCollectionView.register(nib2, forCellWithReuseIdentifier: HomeViewController.adsImageCellId)
        
        let nib3 = UINib(nibName: HomeViewController.adsTitledCellId, bundle: nil)
        self.adsCollectionView.register(nib3, forCellWithReuseIdentifier: HomeViewController.adsTitledCellId)
        guard let collectionView = adsCollectionView, let customLayout = adsCollectionView.collectionViewLayout as? CustomLayout else { return }
        adsCollectionView.register(
            UINib(nibName: "HeaderView", bundle: nil),
            forSupplementaryViewOfKind: CustomLayout.Element.header.kind,
            withReuseIdentifier: CustomLayout.Element.header.id
        )
        adsCollectionView.register(
            UINib(nibName: "MenuView", bundle: nil),
            forSupplementaryViewOfKind: CustomLayout.Element.menu.kind,
            withReuseIdentifier: CustomLayout.Element.menu.id
        )
        
        customLayout.settings.itemSize = CGSize(width: self.view.frame.width, height: 0)
        customLayout.settings.headerSize = CGSize(width: self.view.frame.width, height: 0)
        customLayout.settings.menuSize = CGSize(width: self.view.frame.width, height: 0)
        customLayout.settings.sectionsHeaderSize = CGSize(width: collectionView.frame.width, height: 0)
        customLayout.settings.sectionsFooterSize = CGSize(width: collectionView.frame.width, height: 0)
        customLayout.settings.isHeaderStretchy = false
        customLayout.settings.isAlphaOnHeaderActive = false
        customLayout.settings.headerOverlayMaxAlphaValue = CGFloat(1)
        customLayout.settings.isMenuSticky = false
        customLayout.settings.isSectionHeadersSticky = false
        customLayout.settings.isParallaxOnCellsEnabled = false
        customLayout.settings.maxParallaxOffset = 0
        customLayout.settings.minimumInteritemSpacing = 0
        customLayout.settings.minimumLineSpacing = 3
        adsCollectionView.collectionViewLayout  = customLayout
    }
}

extension VolumeViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView ==  adsCollectionView{
            return self.posts.count
        }
        return 0
    }
    
    // load collecton view cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView ==  adsCollectionView{
            let post = self.posts[indexPath.item]
            if post.type == .image{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.adsImageCellId, for: indexPath) as! AdsImageCell
                cell.post = post
                cell.resizeTagView()
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewController.adsTitledCellId, for: indexPath) as! AdsTitledCell
                cell.post = post
                cell.resizeTagView()
                return cell
            }
            
        }
    
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if collectionView == adsCollectionView {
            let post = self.posts[indexPath.item]
            ActionShowAdsDescrption.execute(post:post)
        }
    }
}

// setup Cell and header Size

extension VolumeViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        if collectionView ==  adsCollectionView{
            return CGSize(width: self.view.frame.width * 0.5 - 16, height: getCellContentSize(indexPath: indexPath))
        }
        return CGSize(width: 0, height:0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == adsCollectionView{return 8}
        return 0
    }
    

}

//MARK: - PINTEREST LAYOUT DELEGATE
extension VolumeViewController : PinterestLayoutDelegate {
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return getCellContentSize(indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat {
        return 0
    }
    
    func getCellContentSize(indexPath:IndexPath) -> CGFloat{
        var height:CGFloat = 0
        let post = self.posts[indexPath.item]
        
        if post.type == .image{
            height += 100 // image heigh
            height += 10 // half of the tag view
            height += (post.city?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal)) ?? 0 // city label height
            height += 8
            height += (post.location?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal)) ?? 0 // area label height
            height += 18 // line view + 8 + 8
            height += (post.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normalBold)) ?? 0 // title label height
            height += 16
        }
        else{
            height += (post.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal)) ?? 0 // title label height
            height += 20 // tag view height
            height += (post.description?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal)) ?? 0 // description label Height
            height += 18 // line view + 8 + 8
            height += (post.city?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normal)) ?? 0 // city label height
            height += 8 // padding
            height += (post.location?.title?.getLabelHeight(width: self.view.frame.width * 0.5 - 32, font: AppFonts.normalBold)) ?? 0 // area label height
            height += 16 // extra
            
        }
        return height
    }
    
}



