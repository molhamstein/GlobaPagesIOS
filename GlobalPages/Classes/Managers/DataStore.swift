//
//  DataStore.swift
//  
//
//  Created by Molham Mahmoud on 14/11/16.
//  Copyright © 2016 BrainSocket. All rights reserved.
//

import SwiftyJSON


/**This class handle all data needed by view controllers and other app classes
 
 It deals with:
 - Userdefault for read/write cached data
 - Any other data sources e.g social provider, contacts manager, etc..
 **Usag:**
 - to write something to chach add constant key and a computed property accessors (set,get) and use the according method  (save,load)
 */
class DataStore :NSObject {
    
    //MARK: Cache keys
    private let CACHE_KEY_CATEGORIES = "categories"
    private let CACHE_KEY_CATEGORIES_FILTERS = "categories_filters"
    private let CACHE_KEY_POST_CATEGORIES = "postcategories"
    private let CACHE_KEY_PRODUCT_CATEGORIES_FILTERS = "productcategoriesfilters"
    private let CACHE_KEY_PRODUCT_CATEGORIES = "productcategories"
    private let CACHE_KEY_SHORES = "SHORES"
    private let CACHE_KEY_SHOPITEM = "SHOPITEM"
    private let CACHE_KEY_INVENTORY = "INVENTORY_ITEMS"
    private let CACHE_KEY_REPORT_TYPES = "REPORT_TYPES"
    private let CACHE_KEY_AD_CATEGORY = "ADCategory"
    private let CACHE_KEY_AD_SUB_CATEGORY = "ADSUBCategory"
    private let CACHE_KEY_BUSSINESS = "bussiness"
    private let CACHE_KEY_NOTIFICATION = "notification"
    private let CACHE_KEY_CITY = "cities"
    private let CACHE_KEY_CITY_FILTERS = "citiesfilters"
    private let CACHE_KEY_AREA = "area"
    private let CACHE_KEY_USER = "user"
    private let CACHE_KEY_TOKEN = "token"
    private let CACHE_KEY_MY_BOTTLES = "myBottles"
    private let CACHE_KEY_MY_REPLIES = "myReplies"
    private let CACHE_KEY_POSTS = "posts"
    private let CACHE_KEY_MARKET_PRODUCTS = "marketProducts"
    private let CACHE_KEY_Volume = "volume"
    private let CACHE_KEY_FAVORITE = "favorites"
    //MARK: Temp data holders
    //keep reference to the written value in another private property just to prevent reading from cache each time you use this var
    private var _me:AppUser?
    private var _reportTypes: [ReportType] = [ReportType]()
    private var _volume:Volume?
    private var _posts:[Post] = [Post]()
    private var _marketProducts:[MarketProduct] = []
    private var _categories:[Category] = [Category]()
    private var _categories_filters:[categoriesFilter] = [categoriesFilter]()
    private var _post_categories:[categoriesFilter] = [categoriesFilter]()
    private var _product_categories_filters:[categoriesFilter] = [categoriesFilter]()
    private var _product_categories:[Category] = [Category]()
    private var _favorites:[Category] = [Category]()
    private var _subcategories:[Category] = [Category]()
    private var _cities:[City] = [City]()
    private var _cities_filters:[categoriesFilter] = [categoriesFilter]()
    private var _areas:[City] = [City]()
    private var _bussiness:[Bussiness] = [Bussiness]()
    private var _notification:[AppNotification] = [AppNotification]()
    private var _token: String?
    
    // user loggedin flag
    var isLoggedin: Bool {
        if let id = token, !id.isEmpty {
            return true
        }
        return false
    }
//favorites
    // Data in cache
    public var categories: [Category] {
        set {
            _categories = newValue
            saveBaseModelArray(array: _categories, withKey: CACHE_KEY_AD_CATEGORY)
        }
        get {
            if(_categories.isEmpty){
                _categories = loadBaseModelArrayForKey(key: CACHE_KEY_AD_CATEGORY)
            }
            return _categories
        }
    }
    
    
    public var categoriesfilters: [categoriesFilter] {
        set {
            _categories_filters = newValue
            saveBaseModelArray(array: _categories_filters, withKey: CACHE_KEY_CATEGORIES_FILTERS)
        }
        get {
            if(_categories_filters.isEmpty){
                _categories_filters = loadBaseModelArrayForKey(key: CACHE_KEY_CATEGORIES_FILTERS)
            }
            return _categories_filters
        }
    }
    
    public var postCategories: [categoriesFilter] {
        set {
            _post_categories = newValue
            saveBaseModelArray(array: _post_categories, withKey: CACHE_KEY_POST_CATEGORIES)
        }
        get {
            if(_post_categories.isEmpty){
                _post_categories = loadBaseModelArrayForKey(key: CACHE_KEY_POST_CATEGORIES)
            }
            return _post_categories
        }
    }
    
    public var productCategoriesFilters: [categoriesFilter] {
        set {
            _product_categories_filters = newValue
            saveBaseModelArray(array: _product_categories_filters, withKey: CACHE_KEY_PRODUCT_CATEGORIES_FILTERS)
        }
        get {
            if(_product_categories_filters.isEmpty){
                _product_categories_filters = loadBaseModelArrayForKey(key: CACHE_KEY_PRODUCT_CATEGORIES_FILTERS)
            }
            return _product_categories_filters
        }
    }
    
    public var productCategories: [Category] {
        set {
            _product_categories = newValue
            saveBaseModelArray(array: _product_categories, withKey: CACHE_KEY_PRODUCT_CATEGORIES)
        }
        get {
            if(_product_categories.isEmpty){
                _product_categories = loadBaseModelArrayForKey(key: CACHE_KEY_PRODUCT_CATEGORIES)
            }
            return _product_categories
        }
    }


    public var favorites: [Category] {
        set {
            _favorites = newValue
            saveBaseModelArray(array: _favorites, withKey: CACHE_KEY_FAVORITE)
        }
        get {
            if(_favorites.isEmpty){
                _favorites = loadBaseModelArrayForKey(key: CACHE_KEY_FAVORITE)
            }
            return _favorites
        }
    }

    public var subCategories: [Category] {
        set {
            _subcategories = newValue
            saveBaseModelArray(array: _subcategories, withKey: CACHE_KEY_AD_SUB_CATEGORY)
        }
        get {
            if(_subcategories.isEmpty){
                _subcategories = loadBaseModelArrayForKey(key: CACHE_KEY_AD_SUB_CATEGORY)
            }
            return _subcategories
        }
    }
    
    public var cities: [City] {
        set {
            _cities = newValue
            saveBaseModelArray(array: _cities, withKey: CACHE_KEY_CITY)
        }
        get {
            if(_cities.isEmpty){
                _cities = loadBaseModelArrayForKey(key: CACHE_KEY_CITY)
            }
            return _cities
        }
    }
    
    public var citiesfilters: [categoriesFilter] {
        set {
            _cities_filters = newValue
            saveBaseModelArray(array: _cities_filters, withKey: CACHE_KEY_CITY_FILTERS)
        }
        get {
            if(_cities_filters.isEmpty){
                _cities_filters = loadBaseModelArrayForKey(key: CACHE_KEY_CITY_FILTERS)
            }
            return _cities_filters
        }
    }
    
    
    
    public var areas: [City] {
        set {
            _areas = newValue
            saveBaseModelArray(array: _areas, withKey: CACHE_KEY_AREA)
        }
        get {
            if(_areas.isEmpty){
                _areas = loadBaseModelArrayForKey(key: CACHE_KEY_AREA)
            }
            return _areas
        }
    }
    
    
    public var reportTypes: [ReportType] {
        set {
            _reportTypes = newValue
            saveBaseModelArray(array: _reportTypes, withKey: CACHE_KEY_REPORT_TYPES)
        }
        get {
            if(_reportTypes.isEmpty){
                _reportTypes = loadBaseModelArrayForKey(key: CACHE_KEY_REPORT_TYPES)
            }
            return _reportTypes
        }
    }
    public var me:AppUser?{
        set {
            _me = newValue
            saveBaseModelObject(object: _me, withKey: CACHE_KEY_USER)
            NotificationCenter.default.post(name: .notificationUserChanged, object: nil)
        }
        get {
            if (_me == nil) {
                _me = loadBaseModelObjectForKey(key: CACHE_KEY_USER)
            }
            return _me
        }
    }
    
    public var volume:Volume?{
        set {
            _volume = newValue
            saveBaseModelObject(object: _volume, withKey: CACHE_KEY_Volume)
        }
        get {
            if (_volume == nil) {
                _volume = loadBaseModelObjectForKey(key: CACHE_KEY_Volume)
            }
            return _volume
        }
    }
    
    public var posts: [Post] {
        set {
            _posts = newValue
            saveBaseModelArray(array: _posts, withKey: CACHE_KEY_POSTS)
        }
        get {
            if(_posts.isEmpty){
                _posts = loadBaseModelArrayForKey(key: CACHE_KEY_POSTS)
            }
            return _posts
        }
    }
    
    public var marketProducts: [MarketProduct] {
        set {
            _marketProducts = newValue
            saveBaseModelArray(array: _marketProducts, withKey: CACHE_KEY_MARKET_PRODUCTS)
        }
        get {
            if(_marketProducts.isEmpty){
                _marketProducts = loadBaseModelArrayForKey(key: CACHE_KEY_MARKET_PRODUCTS)
            }
            return _marketProducts
        }
    }
    
    public var bussiness: [Bussiness] {
        set {
            _bussiness = newValue
            saveBaseModelArray(array: _bussiness, withKey: CACHE_KEY_BUSSINESS)
        }
        get {
            if(_bussiness.isEmpty){
                _bussiness = loadBaseModelArrayForKey(key: CACHE_KEY_BUSSINESS)
            }
            return _bussiness
        }
    }
    
    public var notifications: [AppNotification] {
        set {
            _notification = newValue
            saveBaseModelArray(array: _notification, withKey: CACHE_KEY_NOTIFICATION)
        }
        get {
            if(_notification.isEmpty){
                _notification = loadBaseModelArrayForKey(key: CACHE_KEY_NOTIFICATION)
            }
            return _notification
        }
    }
    
    
    public var featuredPosts:[Post]{
        return DataStore.shared.posts.filter{ $0.isFeatured == true && $0.isActiviated}
    }
    
    public var token:String? {
        set{
            _token = newValue
            if let tokenSting = _token {
                saveStringWithKey(stringToStore: tokenSting, key: CACHE_KEY_TOKEN)
            }
        }
        get {
            if (_token == nil) {
                _token = loadStringForKey(key: CACHE_KEY_TOKEN)
            }
            return _token
        }
    }
    
    public var didChangedFilters = false
    public var location:Location = Location()
    
    public var currentUTCTime:TimeInterval {
        get {
            return Date().timeIntervalSince1970 * 1000
        }
    }
    
    //MARK: Singelton
    public static var shared: DataStore = DataStore()
    
    private override init(){
        super.init()
    }
   
    //MARK: Cache Utils
    private func saveBaseModelArray(array: [BaseModel] , withKey key:String){
        let array : [[String:Any]] = array.map{$0.dictionaryRepresentation()}
        UserDefaults.standard.set(array, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func loadBaseModelArrayForKey<T:BaseModel>(key: String)->[T]{
        var result : [T] = []
        if let arr = UserDefaults.standard.array(forKey: key) as? [[String: Any]]
        {
            result = arr.map{T(json: JSON($0))}
        }
        return result
    }
    
    public func saveBaseModelObject<T:BaseModel>(object:T?, withKey key:String)
    {
        UserDefaults.standard.set(object?.dictionaryRepresentation(), forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    public func loadBaseModelObjectForKey<T:BaseModel>(key:String) -> T?
    {
        if let object = UserDefaults.standard.object(forKey: key)
        {
            return T(json: JSON(object))
        }
        return nil
    }
    
    private func loadStringForKey(key:String) -> String{
        let storedString = UserDefaults.standard.object(forKey: key) as? String ?? ""
        return storedString;
    }
    
    private func saveStringWithKey(stringToStore: String, key: String){
        UserDefaults.standard.set(stringToStore, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    private func loadIntForKey(key:String) -> Int{
        let storedInt = UserDefaults.standard.object(forKey: key) as? Int ?? 0
        return storedInt;
    }
    
    private func saveIntWithKey(intToStore: Int, key: String){
        UserDefaults.standard.set(intToStore, forKey: key);
        UserDefaults.standard.synchronize();
    }
    
    public func onUserLogin(){
//        if let meId = me?.objectId, let name = me?.userName {
//            OneSignal.sendTags(["user_id": meId, "user_name": name])
//        }
    }
    
    public func clearCache()
    {
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
        }
    }
    
    public func fetchBaseData() {
//        ApiManager.shared.requestCategories { (categories, error) in }
        ApiManager.shared.requesReportTypes { (reports, error) in}
    }
    
    public func logout() {
        clearCache()
        me = nil
        token = nil
//        categories = [Category]()
        //shopItems = [ShopItem]()
        //OneSignal.deleteTags(["user_id","user_name"])
        notifications = []
    }
}





