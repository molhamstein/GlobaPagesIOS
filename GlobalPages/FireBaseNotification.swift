//
//  FireBaseNotification.swift
//  twigBIG
//
//  Created by Nour  on 2/25/18.
//
//

import Foundation
import Firebase
import UserNotifications


extension AppDelegate {
    
    func configureFireBase(_ application:UIApplication){
        
        
        FirebaseApp.configure()
        
        
        
        configurePushNotification(application)
    }
    
    
    
    
    
    func configurePushNotification(_ application:UIApplication){
        
        
        
        Messaging.messaging().delegate = self
        
        
        
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
        
        
    }
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        self.handelReciviedMSGInForeGround(userInfo)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        
        
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground\(userInfo)")
        
        
        self.handelReciviedMSGInBackGround(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken)")
        //  Messaging.messaging().apnsToken = deviceToken
    }
    
    
}




////// Fire base



// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        
        
        let userInfo = notification.request.content.userInfo
        
        
        self.handelReciviedMSGInForeGround(userInfo)
        
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground\(notification.request.content.userInfo)")
        
        // Change this to your preferred presentation option
        completionHandler([])
        
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        
        self.handelReciviedMSGInBackGround(userInfo)
        
        print("Handle push from foreground\(response.notification.request.content.userInfo)")
        
        
        completionHandler()
    }
}
// [END ios_10_message_handling]



extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        //  DataStore.shared.FCMToken = fcmToken
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        // DataStore.shared.FCMToken = fcmToken
        
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
    
    // [START ios_10_data_message]
    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
    
    
    func showAlertAppDelegate(title: String,message : String,buttonTitle: String,window: UIWindow){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: nil))
        //window.rootViewController?.present(alert, animated: false, completion: nil)
        UIApplication.visibleViewController()?.present(alert, animated: true, completion: nil)
        
    }
    // Firebase ended here
    
    
    func handelReciviedMSGInBackGround(_ userInfo:[AnyHashable: Any]){
        let gcmMessageIDKey = "gcm.message_id"
        
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground\(userInfo)")
        
        if let dict = userInfo["aps"] as? NSDictionary{
            print(dict)
            let d : [String : Any] = dict["alert"] as! [String : Any]
            let body : String = d["body"] as! String
            let title : String = d["title"] as! String
            print("Title:\(title) + body:\(body)")
            self.showAlertAppDelegate(title: title,message:body,buttonTitle:"ok",window:self.window!)
        }
        // Print full message.
        print(userInfo)
        
    }
    
    
    func handelReciviedMSGInForeGround(_ userInfo:[AnyHashable: Any]){
        let gcmMessageIDKey = "gcm.message_id"
        
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        
        // custom code to handle push while app is in the foreground
        print("Handle push from foreground\(userInfo)")
        
        if let dict = userInfo["aps"] as? NSDictionary{
            print(dict)
            let d : [String : Any] = dict["alert"] as! [String : Any]
            let body : String = d["body"] as! String
            let title : String = d["title"] as! String
            print("Title:\(title) + body:\(body)")
            self.showAlertAppDelegate(title: title,message:body,buttonTitle:"ok",window:self.window!)
        }
        // Print full message.
        print(userInfo)
        
    }
    
    
}
