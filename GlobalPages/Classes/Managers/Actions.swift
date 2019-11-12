//
//  Actions.swift
//  BrainSocket Code base
//
//  Created by BrainSocket on 7/5/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import Foundation
import StoreKit
import AVFoundation
import AVKit
import Lightbox

/**
Repeated and generic actions to be excuted from any context of the app such as show alert
 */
class Action: NSObject {
    class func execute() {}
    class func execute(type:categoryFilterType){}
    class func execute(post:Post){}
}

class ActionLogout:Action {
    override class func execute() {
        let cancelButton = UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil)
        let okButton = UIAlertAction(title: "SETTINGS_USER_LOGOUT".localized, style: .default, handler: {
            (action) in
            //clear user
            ApiManager.shared.userLogout(email: "", password: "", completionBlock: { (_, _, _) in})
            DataStore.shared.logout()
            ActionShowStart.execute()
        })
        let alert = UIAlertController(title: "SETTINGS_USER_LOGOUT".localized, message: "SETTINGS_USER_LOGOUT_CONFIRM_MSG".localized, preferredStyle: .alert)
        alert.addAction(okButton)
        alert.addAction(cancelButton)
        if let controller = UIApplication.visibleViewController() {
            controller.present(alert, animated: true, completion: nil)
            
        }
    }
}

class ActionShowStart: Action {
    override class func execute() {
        UIApplication.appWindow().rootViewController = UIStoryboard.startStoryboard.instantiateViewController(withIdentifier: StartViewController.className)
    }
}

class ActionShowProfile: Action {
    override class func execute() {
//        let profileViewController = UIStoryboard.profileStoryboard.instantiateViewController(withIdentifier: ProfileViewController.className)
//        UIApplication.pushOrPresentViewController(viewController: profileViewController, animated: true)
    }
}


class ActionRateUs {
    class func execute(hostViewController: UIViewController!) {
        if #available( iOS 10.3,*){
            SKStoreReviewController.requestReview()
        } else {
//            let rateViewController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: RateUsPopupViewController.className)
//            rateViewController.providesPresentationContextTransitionStyle = true
//            rateViewController.definesPresentationContext = true
//            rateViewController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext;
//            rateViewController.view.backgroundColor = UIColor.init(white: 0.4, alpha: 0.8)
//            hostViewController.present(rateViewController, animated: true, completion: nil)
        }
            //UIApplication.pushOrPresentViewController(viewController: profileViewController, animated: true)
    }
}

class ActionShareText {
    class func execute(viewController: UIViewController, text: String, sourceView: UIView){
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = sourceView
        viewController.present(activityVC, animated: true, completion: nil)
    }
}


class ActionShowNearByFilters: Action {
    override class func execute() {
        let filterNavigationController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "NearByFilterViewController") as! NearByFilterViewController
        filterNavigationController.modalTransitionStyle = .crossDissolve
        filterNavigationController.modalPresentationStyle = .overFullScreen
        //UINavigationController(rootViewController:   filterNavigationController)
        UIApplication.visibleViewController()?.present(filterNavigationController, animated: true, completion: nil)
    }
}




class ActionShowFilters: Action {
    override class func execute(type:categoryFilterType) {
                let ViewController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: FiltersViewController.className) as! FiltersViewController
        ViewController.categoryfiltertype = type
        let nav = UINavigationController(rootViewController: ViewController)
                UIApplication.visibleViewController()?.present(nav, animated: true, completion: nil)
    }
}


class ActionShowAdsDescrption: Action {
    override class func execute(post:Post) {
        let ViewController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: AdsDescriptionViewController.className) as! AdsDescriptionViewController
        ViewController.post = post
        let nav = UINavigationController(rootViewController: ViewController)
        UIApplication.visibleViewController()?.present(nav, animated: true, completion: nil)
    }
}


 // NewAdViewController
class ActionShowNewAd: Action {
    override class func execute() {
        if DataStore.shared.isLoggedin {
        let ViewController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: NewAdViewController.className) as! NewAdViewController
        let nav = UINavigationController(rootViewController: ViewController)
            UIApplication.visibleViewController()?.present(nav, animated: true, completion: nil)
        }
    }
}

class ActionShowPostCategories: Action {
    override class func execute() {
        if DataStore.shared.isLoggedin {
            let ViewController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "CategoriesSubscriptionViewController") as! CategoriesSubscriptionViewController
            ViewController.modalTransitionStyle = .crossDissolve
            ViewController.modalPresentationStyle = .overFullScreen
            let nav = UINavigationController(rootViewController: ViewController)
            UIApplication.visibleViewController()?.present(nav, animated: true, completion: nil)
        }
    }
}

class ActionPlayVideo: Action {
    class func execute(controller: UIViewController, url: String) {
        let videoURL = URL(string: url)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        controller.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}

class ActionCompressVideo {
    class func execute(inputURL: URL, outputURL: URL, handler:@escaping (_ exportSession: AVAssetExportSession?)-> Void) {
        let urlAsset = AVURLAsset(url: inputURL, options: nil)
        guard let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPresetMediumQuality) else {
            handler(nil)
            return
        }
        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mov
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.exportAsynchronously { () -> Void in
            handler(exportSession)
        }
    }
}

class ActionShowMediaInFullScreen: Action {
    class func execute(pageDelegate: LightboxControllerPageDelegate, dismissalDelegate: LightboxControllerDismissalDelegate, media: [Media], currentPage: Int = 1) {
        // Create an array of images.
        var items: [LightboxImage] = []
        for item in media {
            
            var imageUrl: String?
            var videoUrl: String?
            if item.type == AppMediaType.video {
                imageUrl = item.thumbUrl
                videoUrl = item.fileUrl
                
            }else {
                imageUrl = item.fileUrl
                videoUrl = nil
                
            }
            
            if var imageUrl = imageUrl {
                if !imageUrl.contains(find: "http://") {
                    imageUrl = "http://" + imageUrl
                }
            }
            if var videoUrl = videoUrl {
                if !videoUrl.contains(find: "http://") {
                    videoUrl = "http://" + videoUrl
                }
            }
            
            items.append(LightboxImage(imageURL: URL(string: imageUrl ?? "")!, text: "", videoURL: URL(string: videoUrl ?? "")))
        }
        

        // Create an instance of LightboxController.
        let controller = LightboxController(images: items)

        // Set delegates.
        controller.pageDelegate = pageDelegate
        controller.dismissalDelegate = dismissalDelegate
        
        // Use dynamic background.
        controller.dynamicBackground = true
        
        // Move to selected page
        controller.goTo(currentPage)
        
        // Present your controller.
        let nav = UINavigationController(rootViewController: controller)
        UIApplication.visibleViewController()?.present(nav, animated: true, completion: nil)
    }
}
