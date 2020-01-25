//
//  AppDelegate.swift
//  GlobalPages
//
//  Created by Molham mahmoud on 6/3/18.
//  Copyright © 2018 GlobalPages. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Fix UITextView crash bug in xcode 11.2
        UITextViewWorkaround.executeWorkaround()
        
        // make nav bar trasculante
        AppConfig.setNavigationStyle()

        getBussinessFilters()
        getMetaData()
        
        // MARK:- Firebase
        // Firebase configuration
        FirebaseApp.configure()
        
        // Register for remote notifications
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // Set the messaging delegate
        Messaging.messaging().delegate = self
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                AppConfig.FCMToken = result.token
                
                Messaging.messaging().subscribe(toTopic: "allUsers") { error in
                    print("Subscribed to all users topic")
                }
            }
        }
        return true
    }


    func getBussinessFilters(){
        ApiManager.shared.businessCategories { (success, error, result , cats) in}
        ApiManager.shared.postCategories(completionBlock: { (_, _, _) in})
        ApiManager.shared.getCities { (_, _, _, _) in}
        ApiManager.shared.jobCategories { (_, _, _, _) in}
    }
    
    func getMetaData(){
        
        ApiManager.shared.getMetaData { (_, _, _) in}
        
    }
    

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

@available(iOS 10.0, *)
extension AppDelegate  {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo

        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert , .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo

        // Print full message.
        print("tap on on forground app", userInfo)
        print("content \(response.notification.request.content)")
        
        if let volumeId = userInfo["volumeId"] as? String {
            
            ApiManager.shared.getOneVolume(id: volumeId , completionBlock: {(success, error, result) in
            
                
                if success {
                    ActionShowVolume.execute(volume: result)
                }
                
                
            })
        }else if let adId = userInfo["adId"] as? String {
            
            ApiManager.shared.getPostById(id: adId, completionBlock: { (success, error, result) in
            
                
                if success {
                    ActionShowAdsDescrption.execute(post: result!)
                }
                
               
            })
        }else if let businessId = userInfo["businessId"] as? String {
            
            ApiManager.shared.getBussinessById(id: businessId, completionBlock: { (success, error, result) in
            
                
                if success {
                    ActionShowBusinessDescrption.execute(business: result)
                }
            
            })
            
            
        }else if let marketProductId = userInfo["marketProductId"] as? String {
            
            ApiManager.shared.getMarketProductById(id: marketProductId, completionBlock: { (success, error, result) in
                
                if success {
                    
                    ActionShowMarketProductDescrption.execute(marketProduct: result)
                }
                
                
            })
        }else if let jobId = userInfo["jobId"] as? String {
            ActionShowJob.execute(jobId: jobId)
        }
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
}
