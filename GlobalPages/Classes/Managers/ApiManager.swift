//
//  ApiManager.swift
//
//  Created by Molham Mahmoud on 25/04/16.
//  Copyright © 2016. All rights reserved.
//

import SwiftyJSON
import Alamofire
import UIKit

/// - Api store do all Networking stuff
///     - build server request 
///     - prepare params
///     - and add requests headers
///     - parse Json response to App data models
///     - parse error code to Server error object
///
class ApiManager: NSObject {

    typealias Payload = (MultipartFormData) -> Void
    
    /// frequent request headers
    var headers: HTTPHeaders{
        get{
            let httpHeaders = [
                "Authorization": ((DataStore.shared.token) != nil) ? (DataStore.shared.token)! : "",
                "Accept-Language": AppConfig.currentLanguage.langCode
            ]
            return httpHeaders
        }
    }
    
    let baseURL = "http://104.217.253.15:3000/api"
    let error_domain = "GlobalPages"
    
    //MARK: Shared Instance
    static let shared: ApiManager = ApiManager()
    
    private override init(){
        super.init()
    }    
   
   
    // MARK: Authorization
    /// User facebook login request
    func userFacebookLogin(facebookId: String, fbName: String, fbToken: String, email: String, fbGender: String, imageLink: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)/users/facebookLogin"
        let parameters : [String : Any] = [
            "socialId": facebookId,
            "token": fbToken,
            "gender": fbGender,
            "image": imageLink,
            "email": email,
            "name": fbName
        ]
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse["error"]) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse["user"])
                    DataStore.shared.token = jsonResponse["id"].string
                    DataStore.shared.onUserLogin()
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
    
    /// User twitter login request
    func userTwitterLogin(accessToken: String, secret: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)auth/twitter/login"
        let parameters : [String : Any] = [
            "accessToken": accessToken,
            "accessTokenSecret": secret
            ]
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse["user"])
                    DataStore.shared.me = user
                    DataStore.shared.onUserLogin()
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
    
    /// User instagram login request
    func userInstagramLogin(user: AppUser, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)/users/loginInstegram"
        let parameters : [String : Any] = [
            //"socialId": user.socialId!,
            //"token": user.socialToken!,
            "gender": user.gender!.rawValue,
            "image": user.profilePic!,
            "name": user.userName!
        ]
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse["error"]) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse["user"])
                    DataStore.shared.token = jsonResponse["id"].string
                    DataStore.shared.onUserLogin()
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
    
    /// User login request
    func userLogin(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)/users/login"
        
        let parameters : [String : Any] = [
            "email": email,
            "password": password
        ]
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse["error"]) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse["user"])
                    DataStore.shared.me = user
                    DataStore.shared.token = jsonResponse["id"].string
                    DataStore.shared.me?.objectId = jsonResponse["userId"].string
                    DataStore.shared.onUserLogin()
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                 if let code = responseObject.response?.statusCode, code >= 400 {
                completionBlock(false, ServerError.unknownError, nil)
                 } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
    
    /// User Signup request
    func userSignup(user: AppUser, password: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        // url & parameters
        guard password.length>0,
            let _ = user.email
            else {
                return
        }
        
        let signUpURL = "\(baseURL)/users"
        
        let parameters : [String : String] = [
            "username": user.userName!,
            "phoneNumber": user.mobileNumber!,
            "gender": user.gender?.rawValue ?? "male",
            "birthDate" : DateHelper.getISOStringFromDate(user.birthdate!)!,
            "email": user.email!,
            "password": password,
            "image": ""
        ]
        
        // build request
        Alamofire.request(signUpURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse["error"]) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse["user"])
                    DataStore.shared.me = user
                    DataStore.shared.token = jsonResponse["id"].string
                    DataStore.shared.me?.objectId = jsonResponse["userId"].string
                    DataStore.shared.onUserLogin()
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
    
    
    /// User Signup request
    func updateUser(user: AppUser, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        // url & parameters
        let signUpURL = "\(baseURL)/users/\(user.objectId!)"
        
        var parameters : [String : String] = [
            "username": user.userName!,
            "gender": user.gender?.rawValue ?? "male",
        ]
        
        if let email = user.email {
            parameters["email"] = email
        }
        
        if let date = user.birthdate {
            parameters["birthDate"] = DateHelper.getISOStringFromDate(date)
        }
        if let img = user.profilePic {
            parameters["imageProfile"] = img
        }
        
        // build request
        Alamofire.request(signUpURL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse["error"]) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse)
                    DataStore.shared.me = user
                    //DataStore.shared.onUserLogin()
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
    
    /// get me
    func getMe(completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        // url & parameters
        let signUpURL = "\(baseURL)/users/\(DataStore.shared.me?.objectId ?? " ")"
        
        // build request
        Alamofire.request(signUpURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse)
                    DataStore.shared.me = user
                    //DataStore.shared.onUserLogin()
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
    //businessCategories
    
    func userVerify(code: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        
        let signUpURL = "\(baseURL)auth/confirm_code"
        let parameters : [String : String] = [
            "code": code
        ]
        
        // build request
        Alamofire.request(signUpURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse["user"])
                    DataStore.shared.me = user
                    DataStore.shared.onUserLogin()
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
    
    func requestResendVerify(completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        
        let signUpURL = "\(baseURL)auth/resend_code"
        let parameters : [String : String] = [:]
        
        // build request
        Alamofire.request(signUpURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    // MARK: Reset Password
    /// User forget password
    func forgetPassword(email: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)auth/forgot_password"
        let parameters : [String : Any] = [
            "email": email,
        ]
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    /// Confirm forget password
    func confirmForgetPassword(email: String, code: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)auth/confirm_forgot_password"
        let parameters : [String : Any] = [
            "email": email,
            "code": code,
            "password": password
            ]
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse["user"])
                    DataStore.shared.me = user
                    DataStore.shared.onUserLogin()
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    // MARK: Categories
//    func requestCategories(completionBlock: @escaping (_ categories: Array<Category>?, _ error: NSError?) -> Void) {
//        let categoriesListURL = "\(baseURL)categories"
//        Alamofire.request(categoriesListURL).responseJSON { (responseObject) -> Void in
//            if responseObject.result.isSuccess {
//                let resJson = JSON(responseObject.result.value!)
//                if let data = resJson["data"].array
//                {
//                    let categories: [Category] = data.map{Category(json: $0)}
//                    //save to cache
//                    DataStore.shared.categories = categories
//                    completionBlock(categories, nil)
//                }
//            }
//            if responseObject.result.isFailure {
//                let error : NSError = responseObject.result.error! as NSError
//                completionBlock(nil, error)
//            }
//        }
//    }
    

    func requesReportTypes(completionBlock: @escaping (_ items: Array<ReportType>?, _ error: NSError?) -> Void) {
        let categoriesListURL = "\(baseURL)/report-types"
        Alamofire.request(categoriesListURL).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                if let data = resJson.array {
                    let items: [ReportType] = data.map{ReportType(json: $0)}
                    //save to cache
                    DataStore.shared.reportTypes = items
                    completionBlock(items, nil)
                }
            }
            if responseObject.result.isFailure {
                let error : NSError = responseObject.result.error! as NSError
                completionBlock(nil, error)
            }
        }
    }
    
    // MARK: Upload Video
    func uploadMedia(urls:[URL], mediaType: AppMediaType, completionBlock: @escaping (_ files: [Media], _ errorMessage: String?) -> Void) {
        
//        let mediaURL = "\(baseURL)/uploads/videos/upload"
        var mediaURL = "\(baseURL)/uploadFiles/videos/upload"
        if mediaType == .image {
            mediaURL = "\(baseURL)/uploadFiles/images/upload"
        } else if mediaType == .audio{
            mediaURL = "\(baseURL)/uploadFiles/audios/upload"
        }
        
        let payload : Payload = /*@escaping*/{ multipartFormData in
            
            for url in urls {
                if mediaType == .image {
                    do {
                        let imageData = try Data(contentsOf: url)
                        if let img = UIImage(data: imageData), let compressedImg = UIImageJPEGRepresentation(img, 0.65) {
                            multipartFormData.append(compressedImg, withName: "file", fileName: "file", mimeType: "image/png")
                        }
                    } catch {
                    }
                } else {
                    multipartFormData.append(url, withName: "file")
                }
            }
        
        }
        
        Alamofire.upload(multipartFormData: payload, to: mediaURL, method: .post, headers: headers,
                         encodingCompletion: { encodingResult in
                            
                switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { responseObject in
                                    
                            if responseObject.result.isSuccess {
                                        
                                let resJson = JSON(responseObject.result.value!)
                                if let resArray = resJson.array {
                                    var files: [Media] = []
                                    for  i in 0 ..< resArray.count {
                                        let media = Media(json:resArray[i])
                                        media.type = mediaType
                                        files.append(media)
                                    }
                                    completionBlock(files, nil)
                                 
                                }
                            } else { // failure
                                        
                                if let code = responseObject.response?.statusCode, code >= 400 {
                                    completionBlock([], ServerError.unknownError.type.errorMessage)
                                } else {
                                    completionBlock([], ServerError.connectionError.type.errorMessage)
                                }
                            }
                    }
                    case .failure(let encodingError):
                        completionBlock([], ServerError.connectionError.type.errorMessage)
                }
        })
    }
    
    // MARK: Upload Video
    func uploadImage(imageData:UIImage, completionBlock: @escaping (_ files: [Media], _ errorMessage: String?) -> Void) {
        
        let mediaURL = "\(baseURL)/uploadFiles/images/upload"
        
        let payload : Payload = /*@escaping*/{ multipartFormData in
            if let compressedImg = UIImageJPEGRepresentation(imageData, 0.65) {
                multipartFormData.append(compressedImg, withName: "file", fileName: "file", mimeType: "image/png")
            }
        }
        
        Alamofire.upload(multipartFormData: payload, to: mediaURL, method: .post, headers: headers,
                         encodingCompletion: { encodingResult in
                            
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { responseObject in
                                    
                                    if responseObject.result.isSuccess {
                                        let resJson = JSON(responseObject.result.value!)
                                        if let resArray = resJson.array {
                                            var files: [Media] = []
                                            for  i in 0 ..< resArray.count {
                                                let media = Media(json:resArray[i])
                                                media.type = .image
                                                files.append(media)
                                            }
                                            completionBlock(files, nil)
                                        }
                                    } else { // failure
                                        if let code = responseObject.response?.statusCode, code >= 400 {
                                            completionBlock([], ServerError.unknownError.type.errorMessage)
                                        } else {
                                            completionBlock([], ServerError.connectionError.type.errorMessage)
                                        }
                                    }
                                }
                            case .failure(let encodingError):
                                completionBlock([], ServerError.connectionError.type.errorMessage)
                            }
        })
    }
    
    
    
    // MARK: Upload images
    func uploadImages(images:[UIImage],mediaType: AppMediaType = .image, completionBlock: @escaping (_ urls: [Media], _ errorMessage: String?) -> Void) {
        
        let mediaURL = "\(baseURL)/attachments/images/upload"
        let payload : Payload = /*@escaping*/{ multipartFormData in
            
            for image in images {
                    if let compressedImg = UIImageJPEGRepresentation(image, 0) {
                            multipartFormData.append(compressedImg, withName: "file", fileName: "file", mimeType: "image/png")
                }
            }
            
        }
        
        Alamofire.upload(multipartFormData: payload, to: mediaURL, method: .post, headers: headers,
                         encodingCompletion: { encodingResult in
                            
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { responseObject in
                                    
                                    if responseObject.result.isSuccess {
                                        
                                        let resJson = JSON(responseObject.result.value!)
                                        if let resArray = resJson.array {
                                            var files: [Media] = []
                                            for  i in 0 ..< resArray.count {
                                                let media = Media(json:resArray[i])
                                                media.type = mediaType
                                                files.append(media)
                                            }
                                            completionBlock(files, nil)
                                        }
                                    } else { // failure
                                        
                                        if let code = responseObject.response?.statusCode, code >= 400 {
                                            completionBlock([], ServerError.unknownError.type.errorMessage)
                                        } else {
                                            completionBlock([], ServerError.connectionError.type.errorMessage)
                                        }
                                    }
                                }
                            case .failure(let encodingError):
                                completionBlock([], ServerError.connectionError.type.errorMessage)
                            }
        })
    }
    //filter[where][ownerId]=5b855cb0ee3548256fbf0b2a
    // MARK: notifications
    func sendPushNotification(msg: String, targetUser: AppUser, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // url & parameters
        let bottleURL = "\(baseURL)/notifications/sendNotification"
        
        let msgBodyParams : [String : Any] = [
            "en": msg
        ]
        
        let parameters : [String : Any] = [
            "content": msgBodyParams,
            "userId": targetUser.objectId!,
            ]
        
        // build request
        Alamofire.request(bottleURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse["error"]) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    
    // get notifications
    func getNotification(user_id: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?,_ result : [AppNotification]) -> Void) {
        // url & parameters
        let bottleURL = "\(baseURL)/notifications?filter[where][recipientId]=\(user_id)"
        
        // build request
        Alamofire.request(bottleURL, method: .get,encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse["error"]) ?? ServerError.unknownError
                    completionBlock(false , serverError,[])
                } else {
                    if let array = jsonResponse.array{
                        let notifications = array.map{AppNotification(json:$0)}
                        DataStore.shared.notifications = notifications
                        completionBlock(true , nil,notifications)
                    }else{
                        completionBlock(true , nil,[])
                    }
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError,[])
                } else {
                    completionBlock(false, ServerError.connectionError,[])
                }
            }
        }
    }
    
    
    /// Api
    // get categories filter
    //businessCategories
    func businessCategories(completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ result:[categoriesFilter],_ catResult:[Category]) -> Void) {
        // url & parameters
        let signUpURL = "\(baseURL)/businessCategories?filter[include]=subCategories"
        
        // build request
        Alamofire.request(signUpURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, [],[])
                } else {
                    // parse response to data model >> user object
                    if let array = jsonResponse.array{
                        let filters = array.map{categoriesFilter(json:$0)}
                        let categories = array.map{Category(json:$0)}
                        completionBlock(true , nil, filters,categories)
                    }else{
                        completionBlock(true , nil, [],[])
                    }
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, [],[])
                } else {
                    completionBlock(false, ServerError.connectionError, [],[])
                }
            }
        }
    }
    
    
    //cities
    func getCities(completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ result:[categoriesFilter],_ cityResult:[City]) -> Void) {
        // url & parameters
        let signUpURL = "\(baseURL)/cities?filter[include]=locations"
    
        // build request
        Alamofire.request(signUpURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, [],[])
                } else {
                    // parse response to data model >> user object
                    if let array = jsonResponse.array{
                        let filters = array.map{categoriesFilter(json:$0)}
                        let cities = array.map{City(json:$0)}
                        completionBlock(true , nil, filters,cities)
                    }else{
                        completionBlock(true , nil, [],[])
                    }
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, [],[])
                } else {
                    completionBlock(false, ServerError.connectionError, [],[])
                }
            }
        }
    }
    
//postCategories
    
    func postCategories(completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ result:[categoriesFilter]) -> Void) {
        // url & parameters
        let signUpURL = "\(baseURL)/postCategories?filter[include]=subCategories"
        // build request
        Alamofire.request(signUpURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, [])
                } else {
                    // parse response to data model >> user object
                    if let array = jsonResponse.array{
                        let filters = array.map{categoriesFilter(json:$0)}
                        completionBlock(true , nil, filters)
                    }else{
                        completionBlock(true , nil, [])
                    }
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, [])
                } else {
                    completionBlock(false, ServerError.connectionError, [])
                }
            }
        }
    }
    
    // volumes
    func getVolumes(limit:Int = 1,skip:Int ,completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ result:Volume?) -> Void) {
        // url & parameters
        let signUpURL = "\(baseURL)/volumes?filter[limit]=\(limit)&filter[skip]=\(skip)"
        // build request
         DataStore.shared.volume = nil
        Alamofire.request(signUpURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    if let array = jsonResponse.array{
                        let volumes = array.map{Volume(json:$0)}
                        DataStore.shared.volume = volumes.first
                         completionBlock(true , nil, volumes.first)
                    }else{
                        completionBlock(true , nil, nil)
                    }
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError,nil)
                } else {
                    completionBlock(false, ServerError.connectionError,nil)
                }
            }
        }
    }
    
    
    // posts
    func getPosts(completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ result:[Post]) -> Void) {
        // url & parameters
        let signUpURL = "\(baseURL)/posts"
        DataStore.shared.posts = []
        // build request
        Alamofire.request(signUpURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, [])
                } else {
                    // parse response to data model >> user object
                    if let array = jsonResponse.array{
                        let filters = array.map{Post(json:$0)}
                        DataStore.shared.posts = filters
                        completionBlock(true , nil, filters)
                    }else{
                        completionBlock(true , nil, [])
                    }
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, [])
                } else {
                    completionBlock(false, ServerError.connectionError, [])
                }
            }
        }
    }
    
    
    func getUserPosts(ownerId:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ result:[Post]) -> Void) {
        // url & parameters
        let signUpURL = "\(baseURL)/posts?filter[where][ownerId]=\(ownerId)"
//        DataStore.shared.posts = []
        // build request
        Alamofire.request(signUpURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, [])
                } else {
                    // parse response to data model >> user object
                    if let array = jsonResponse.array{
                        let filters = array.map{Post(json:$0)}
//                        DataStore.shared.posts = filters
                        completionBlock(true , nil, filters)
                    }else{
                        completionBlock(true , nil, [])
                    }
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, [])
                } else {
                    completionBlock(false, ServerError.connectionError, [])
                }
            }
        }
    }
    
    
    
    func getUserBussiness(ownerId:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ result:[Bussiness]) -> Void) {
        // url & parameters
        let signUpURL = "\(baseURL)/businesses?filter[where][ownerId]=\(ownerId)"
        //        DataStore.shared.posts = []
        // build request
        Alamofire.request(signUpURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, [])
                } else {
                    // parse response to data model >> user object
                    if let array = jsonResponse.array{
                        let filters = array.map{Bussiness(json:$0)}
                        completionBlock(true , nil, filters)
                    }else{
                        completionBlock(true , nil, [])
                    }
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, [])
                } else {
                    completionBlock(false, ServerError.connectionError, [])
                }
            }
        }
    }

    // add user post
    func addPost(post: Post,cityId:String,locationId:String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // url & parameters
        guard let token = DataStore.shared.token else {return}
        let signInURL = "\(baseURL)/posts?access_token=\(token)"
        print(signInURL)
        var parameters : [String : Any] = post.dictionaryRepresentation()
        parameters["cityId"] = cityId
        parameters["locationId"] = locationId
        print(parameters)
    
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    // parse response to data model >> user object
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    func editPost(post: Post,cityId:String,locationId:String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // url & parameters
//        guard let token = DataStore.shared.token else {return}
        let signInURL = "\(baseURL)/posts?id=\(post.id)"
        var parameters : [String : Any] = post.dictionaryRepresentation()
        parameters["cityId"] = cityId
        parameters["locationId"] = locationId
        parameters.removeValue(forKey: "id")
        parameters.removeValue(forKey: "city")
        parameters.removeValue(forKey: "subCategory")
        parameters.removeValue(forKey: "category")
        parameters.removeValue(forKey: "location")
        print(parameters)
        
        // build request
        Alamofire.request(signInURL, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    // parse response to data model >> user object
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    // add bussiness
    func addBussiness(bussiness: Bussiness, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // url & parameters
        guard let token = DataStore.shared.token else {return}
        let signInURL = "\(baseURL)/businesses?access_token=\(token)"
        let parameters : [String : Any] =  bussiness.dictionaryRepresentation()
        print(parameters)
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            print(responseObject)
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    // parse response to data model >> user object
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    // edit Bussiness
    func editBussiness(bussiness: Bussiness, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)/businesses?id=\(bussiness.id)"
        let parameters : [String : Any] =  bussiness.dictionaryRepresentation()
        // build request
        Alamofire.request(signInURL, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    // parse response to data model >> user object
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    // add product
    ///businesses/5b89bdbacb12b88b078c1963/myProducts
    
    func addProduct(product: Product,bussinessId:String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)/businesses/\(bussinessId)/myProducts"
        let parameters : [String : Any] = product.dictionaryRepresentation()
        print(parameters)
        
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    // parse response to data model >> user object
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    // edit product    
    func editProduct(product: Product,bussinessId:String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        
        let signInURL = "\(baseURL)/businesses/\(bussinessId)/myProducts/\(product.id ?? "")"
        let parameters : [String : Any] = product.dictionaryRepresentation()
        print(parameters)
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    // parse response to data model >> user object
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    
    // businesses
    func getBusinesses(completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ result:[Bussiness]) -> Void) {
        // url & parameters
        let signUpURL = "\(baseURL)/businesses"
        
        // build request
        Alamofire.request(signUpURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, [])
                } else {
                    // parse response to data model >> user object
                    if let array = jsonResponse.array{
                        let filters = array.map{Bussiness(json:$0)}
                        DataStore.shared.bussiness = filters
                        completionBlock(true , nil, filters)
                    }else{
                        completionBlock(true , nil, [])
                    }
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, [])
                } else {
                    completionBlock(false, ServerError.connectionError, [])
                }
            }
        }
    }
    
    // get nearby bussiness
    func getNearByBusinesses(lat:String,lng:String,catId:String,subCatId:String,codeSubCat:String,openDay:String,limit:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ result:[Bussiness]) -> Void) {
        // url & parameters
        let signUpURL = "\(baseURL)/businesses/searchByLocation?lat=\(lat)&lng=\(lng)&catId=\(catId)&subCatId=\(subCatId)&codeSubCat=\(codeSubCat)&openingDay=\(openDay)&limit=\(limit)"
        
        // build request
        Alamofire.request(signUpURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, [])
                } else {
                    // parse response to data model >> user object
                    if let array = jsonResponse.array{
                        let filters = array.map{Bussiness(json:$0)}
                        DataStore.shared.bussiness = filters
                        completionBlock(true , nil, filters)
                    }else{
                        completionBlock(true , nil, [])
                    }
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                let nsError : NSError = responseObject.result.error! as NSError
                print(nsError.localizedDescription)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, [])
                } else {
                    completionBlock(false, ServerError.connectionError, [])
                }
            }
        }
    }
    
    
}


/**
 Server error represents custome errors types from back end
 */
struct ServerError {
    
    static let errorCodeConnection = 50
    
    public var errorName:String?
    public var status: Int?
    public var code:Int!
    
    public var type:ErrorType {
        get{
            return ErrorType(rawValue: code) ?? .unknown
        }
    }
    
    /// Server erros codes meaning according to backend
    enum ErrorType:Int {
        case connection = 50
        case unknown = -111
        case authorization = 401
        case userNotActivated = 403
        case invalidUserName = 405
        case noBottleFound = 406
        case alreadyExists = 101
        case socialLoginFailed = -110
		case notRegistred = 102
        case missingInputData = 104
        case expiredVerifyCode = 107
        case invalidVerifyCode = 108
        case userNotFound = 109
        
        /// Handle generic error messages
        /// **Warning:** it is not localized string
        var errorMessage:String {
            switch(self) {
                case .unknown:
                    return "ERROR_UNKNOWN".localized
                case .connection:
                    return "ERROR_NO_CONNECTION".localized
                case .authorization:
                    return "ERROR_NOT_AUTHORIZED".localized
                case .alreadyExists:
                    return "ERROR_SIGNUP_EMAIL_EXISTS".localized
				case .notRegistred:
                    return "ERROR_SIGNIN_WRONG_CREDIST".localized
                case .missingInputData:
                    return "ERROR_MISSING_INPUT_DATA".localized
                case .expiredVerifyCode:
                    return "ERROR_EXPIRED_VERIFY_CODE".localized
                case .invalidVerifyCode:
                    return "ERROR_INVALID_VERIFY_CODE".localized
                case .userNotFound:
                    return "ERROR_RESET_WRONG_EMAIL".localized
                case .userNotActivated:
                    return "ERROR_UNACTIVATED_USER".localized
                case .invalidUserName:
                    return "ERROR_INVALID_USERNAME".localized
                case .noBottleFound:
                    return "ERROR_BOTTLE_NOT_FOUND".localized
                
                default:
                    return "ERROR_UNKNOWN".localized
            }
        }
    }
    
    public static var connectionError: ServerError{
        get {
            var error = ServerError()
            error.code = ErrorType.connection.rawValue
            return error
        }
    }
    
    public static var unknownError: ServerError{
        get {
            var error = ServerError()
            error.code = ErrorType.unknown.rawValue
            return error
        }
    }
    
    public static var socialLoginError: ServerError{
        get {
            var error = ServerError()
            error.code = ErrorType.socialLoginFailed.rawValue
            return error
        }
    }
    
    public init() {
    }
    
    public init?(json: JSON) {
        guard let errorCode = json["statusCode"].int else {
            return nil
        }
        code = errorCode
        if let errorString = json["message"].string{ errorName = errorString}
        if let statusCode = json["statusCode"].int{ status = statusCode}
    }
}


