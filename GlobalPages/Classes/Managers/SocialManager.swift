//
//  SocialManager.swift
//
//  Created by Molham Mahmoud on 25/04/16.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

/// - Social Manager
///     - Login Facebook, Twitter and Instagram
///     - Share on social media
///
class SocialManager: NSObject{
    
    //MARK: Shared Instance
    static let shared: SocialManager = SocialManager()
    
    private override init() {
        super.init()
    }    
   
    // MARK: Authorization
    /// Facebook login request
    func facebookLogin(controller: UIViewController, completionBlock: @escaping (_ user: AppUser?, _ success: Bool, _ error: ServerError?) -> Void) {
        let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
        // ask for email permission
        fbLoginManager.logIn(withReadPermissions: ["email", "user_location"], from: controller) { (result, error) in
            // check errors
            if (error == nil) {
                // check if user grants the permissions
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if (fbloginresult.grantedPermissions != nil) {
                    if (fbloginresult.grantedPermissions.contains("email")) {
                        if ((FBSDKAccessToken.current()) != nil) {
                            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,name,first_name,last_name,picture,email,location{location{country_code}},gender"]).start(completionHandler: { (connection, result, error) -> Void in
                                if (error == nil) {
                                    let dict = result as! [String : AnyObject]
                                    if let facebookId = dict["id"] as? String {
                                        let fName = dict["first_name"] as? String
                                        let lName = dict["last_name"] as? String
                                        let userName = (fName?.trimed)! + "." + (lName?.trimed)!
                                        var pictureLink = ""
                                        let email = dict["email"] as! String
                                        var countryCode = "CH"
                                        let gender = "male"
                                        if let locationObj = dict["location"] as? [String : AnyObject], let innerLocationObj = locationObj["location"] as? [String : AnyObject] {
                                            countryCode = innerLocationObj["country_code"] as! String
                                        }
                                        if let picObj = dict["picture"] as? [String : AnyObject], let innerPicObj = picObj["data"] as? [String : AnyObject] {
                                            pictureLink = innerPicObj["url"] as! String
                                        }
                                        
                                        // send facebook ID to start login process
                                        ApiManager.shared.userFacebookLogin(facebookId: facebookId, fbName: userName, fbToken: FBSDKAccessToken.current().tokenString, email: email, fbGender: gender, imageLink: pictureLink) { (isSuccess, error, user) in
                                            // login success
                                            if (isSuccess) {
                                                completionBlock(user, true , nil)
                                            } else {
                                                completionBlock(nil, false , error)
                                            }
                                        }
                                    } else {
                                        completionBlock(nil, false , ServerError.socialLoginError)
                                    }
                                }  else {
                                    completionBlock(nil, false , ServerError.socialLoginError)
                                }
                            })
                        } else {
                            completionBlock(nil, false , ServerError.socialLoginError)
                        }
                    } else {
                        completionBlock(nil, false , ServerError.socialLoginError)
                    }
                } else {
                    completionBlock(nil, false , ServerError.socialLoginError)
                }
            } else {
                completionBlock(nil, false , ServerError.socialLoginError)
            }
        }
    }
    
    
    /// Instagram login request
    func instagramLogin(controller: UIViewController, completionBlock: @escaping (_ user: AppUser?, _ success: Bool, _ error: ServerError?) -> Void) {

    }
    
    func googleLoginResult(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!, completionBlock: @escaping (_ user: AppUser?, _ success: Bool, _ error: ServerError?) -> Void) {
        
        if (error == nil) {
            let userDataHolder = AppUser()
            userDataHolder.userName = user.profile.name
            //userDataHolder.socialToken = user.authentication.idToken
            //userDataHolder.socialId = user.userID
            userDataHolder.email = user.profile.email
            userDataHolder.profilePic = user.profile.imageURL(withDimension: 200).absoluteString
            userDataHolder.gender = .male
            userDataHolder.loginType = .google
            
            ApiManager.shared.userInstagramLogin(user: userDataHolder) { (isSuccess, error, user) in
                // login success
                if (isSuccess) {
                    completionBlock(user, true , nil)
                } else {
                    completionBlock(nil, false , error)
                }
            }
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
            
            // ...
        } else {
            completionBlock(nil, false , ServerError.socialLoginError)
        }
    }
    
    /// Google login request
    func googleLogin(delegateController: LoginViewController) {
        
        GIDSignIn.sharedInstance().clientID = AppConfig.googleClientID
//        GIDSignIn.sharedInstance().delegate = delegateController
//        GIDSignIn.sharedInstance().uiDelegate = delegateController
        GIDSignIn.sharedInstance().signIn()
        
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().clientID = AppConfig.googleClientID
//        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
//        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
//        GIDSignIn.sharedInstance().signInSilently()
        
        
    }
   
}




