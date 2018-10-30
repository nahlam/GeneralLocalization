//
//  LanguageManager.swift
//  4Sale
//
//  Created by Nahla Mortada on 7/20/16.
//  Copyright © 2016 Nahla Mortada. All rights reserved.
//

import Foundation

public class LanguageManager {
    
    public struct LocaleIdentifier {
        
        public static let Arabic = "ar_EG"
        public static let English = "en-US"
        public static let EnglishDate = "en_US_POSIX"
        public static let ArabicSaudi = "ar_SA"
    }
    
    public struct Constants {
        
        public static let Empty                    = ""
        public static let ProjectExtension         = "lproj"
        
        public static let LanguageChanged              = "localization-language-changed-notification"
        public static let LanguageCode                 = "code"
        public static let LanguageEnglishName          = "english-name"
        public static let LanguageisArabic             = "is-arabic"
        public static let LanguageCodeAr               = "ar"
        public static let LanguageCodeEn               = "en"
        public static let LanguageNameAr               = "Arabic"
        public static let LanguageNameEn               = "English"
        public static let LocalizationFileName         = "Localizable"
    }
    
    public struct DateFormates {
        
        public static let HM = "EEE h:mm a"
        public static let DMY = "d MMM yyyy"
        public static let FullDateEvent = "MMM dd, hh:mm a"
        public static let FullDateArabic = "d MMM, h:mm a"
        public static let FullDateEnglish = "MMM d, h:mm a"
    }
    
    // MARK: - Variables
    
    static var bundle: Bundle?
    static var lang: String?
    static var customNumberFormatter: NumberFormatter?
    static var customCurrencyormatter: NumberFormatter?
    static var eventDateFormatter: DateFormatter?
    static var activityDateFormatter: DateFormatter?
    static var timestampFormatter: DateFormatter?
    
    public private(set) var customLocalizationFileName: String = ""
    public private(set) var languageUserDefaultsKey: String = "com.4Sale.currentLanguage"
    public private(set) var isArabic: Bool = false
    public private(set) var isEnglish: Bool = true
    
    public var localeCode: String {
        return LanguageManager.isArabicLanguage() ? LocaleIdentifier.Arabic : LocaleIdentifier.English
    }
    
    public static let shared: LanguageManager = {
        let instance = LanguageManager()
        return instance
    }()
    
    /// Initalization Method
    ///
    /// - Parameters:
    ///   - customLocalizationFileName: If there is another localization file for your target set it's name so if didn't find the string in the general localization file will get it from there
    ///   - languageUserDefaultsKey: language defaults key by default it's "com.4Sale.currentLanguage"
    
    public func initalize(customLocalizationFileName: String, languageUserDefaultsKey: String) {
        self.customLocalizationFileName = customLocalizationFileName
        self.languageUserDefaultsKey = languageUserDefaultsKey
    }
    
    
    // MARK: - Check Language Related
    
    public class func languageSelected() -> Bool {
        var language: String?
        if let defaultLanguage = LanguageManager.getStringValueFromUserDefaults(key: LanguageManager.shared.languageUserDefaultsKey) {
            language = defaultLanguage
        }
        if language != nil {
            return true
        }
        return false
    }
    
    public func refreshLanguage() {
        self.setLanguageVariables()
    }
    
    internal func setLanguageVariables() {
        LanguageManager.shared.isArabic = LanguageManager.isArabicLanguage()
        LanguageManager.shared.isEnglish = LanguageManager.isEnglishLanguage()
    }
    
    public class func setLanguage(language: String) {
        LanguageManager.insertStringToUserDefaults(stringValue: language, key: LanguageManager.shared.languageUserDefaultsKey)
        LanguageManager.shared.setLanguageVariables()
    }
    
    public class func language() -> String {
        if let code = LanguageManager.getStringValueFromUserDefaults(key: LanguageManager.shared.languageUserDefaultsKey) {
            return code
        }
        return Constants.LanguageCodeEn
    }
    
    public class func isArabicLanguage() -> Bool {
        let languageCode = LanguageManager.language()
        if languageCode == Constants.LanguageCodeAr {
            return true
        }
        return false
    }
    
    public class func isEnglishLanguage() -> Bool {
        return !isArabicLanguage()
    }
    
    public class func getPhoneLocale() -> Locale {
        if LanguageManager.shared.isArabic {
            return Locale(identifier: "ar-EG")
        }
        
        return Locale.current
    }
    
    
    // MARK: - Bundle related
    
    public class func localizedBundle() -> Bundle {
        if bundle == nil {
            let code = LanguageManager.language()
            let path: String? = Bundle.main.path(forResource: code, ofType: Constants.ProjectExtension)
            if path != nil {
                bundle = Bundle(path: path!)
            }
        }
        return bundle!
    }
    
    public class func englishBundle() -> Bundle {
        if bundle == nil {
            let code = Constants.LanguageCodeEn
            let path = Bundle.main.path(forResource: code, ofType: Constants.ProjectExtension)!
            bundle = Bundle(path: path)
        }
        return bundle!
    }
    
    public class func arabicBundle() -> Bundle {
        if bundle == nil {
            let code = Constants.LanguageCodeAr
            let path = Bundle.main.path(forResource: code, ofType: Constants.ProjectExtension)!
            bundle = Bundle(path: path)
        }
        return bundle!
    }
    
    // MARK: - App Language Management
    
    public class func setApplicationLanguage(language: String) {
        
        LanguageManager.insertStringToUserDefaults(stringValue: language, key: LanguageManager.shared.languageUserDefaultsKey)
        LanguageManager.setLocale()
        bundle = nil
        lang = language
        customNumberFormatter = nil
        customCurrencyormatter = nil
        eventDateFormatter = nil
        activityDateFormatter = nil
        timestampFormatter = nil
        bundle = localizedBundle()
        if language == "ar" {
            let notificationObject: [String: Any] = [Constants.LanguageCode : Constants.LanguageCodeAr, Constants.LanguageEnglishName: Constants.LanguageNameAr, Constants.LanguageisArabic : true]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.LanguageChanged), object: notificationObject)
        } else {
            let notificationObject: [String: Any] = [Constants.LanguageCode : Constants.LanguageCodeEn, Constants.LanguageEnglishName: Constants.LanguageNameEn, Constants.LanguageisArabic : false]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.LanguageChanged), object: notificationObject)
        }
    }
    
    public class func localizedString(key: String, localizable: String = LanguageManager.shared.customLocalizationFileName) -> String {
        let localizedBundle: Bundle? = LanguageManager.localizedBundle()
        let generalLocalizable = Constants.LocalizationFileName
        if let value = localizedBundle?.localizedString(forKey: key, value: nil, table: generalLocalizable), value != key {
            return value
        }
        
        if localizable.isEmpty {
            fatalError("customLocalizationFileName cannot be empty you should either add the key in the general \"Localizable\" file name or add custom localization file name to your target and pass it's name to the initalization method")
        }
        
        return localizedBundle?.localizedString(forKey: key, value: nil, table: localizable) ?? Constants.Empty
    }
    
    public class func localizedString(key: String, languageCode: String, localizable: String = LanguageManager.shared.customLocalizationFileName) -> String {
        let path: String = Bundle.main.path(forResource: languageCode, ofType: Constants.ProjectExtension)!
        let localizedBundle: Bundle? = Bundle(path: path)!
        let generalLocalizable = Constants.LocalizationFileName
        if let value = localizedBundle?.localizedString(forKey: key, value: nil, table: generalLocalizable), value != key {
            return value
        }
        
        if localizable.isEmpty {
            fatalError("customLocalizationFileName cannot be empty you should either add the key in the general \"Localizable\" file name or add custom localization file name to your target and pass it's name to the initalization method")
        }
        
        return localizedBundle?.localizedString(forKey: key, value: nil, table: localizable) ?? Constants.Empty
    }
    
    
    // MARK: - Formating
    
    class func initalizeNumberFormatter() {
        if customNumberFormatter == nil {
            customNumberFormatter = NumberFormatter()
            let locale = Locale(identifier: LanguageManager.shared.localeCode)
            customNumberFormatter?.locale = locale
        }
        
        customNumberFormatter?.numberStyle = .decimal
        customNumberFormatter?.minimumFractionDigits = 0
        customNumberFormatter?.maximumFractionDigits = 0
        
    }
    
    class func initalizeNumberFormatterFloat() {
        if customNumberFormatter == nil {
            customNumberFormatter = NumberFormatter()
            let locale = Locale(identifier: LanguageManager.shared.localeCode)
            customNumberFormatter?.locale = locale
        }
        
        customNumberFormatter?.numberStyle = .decimal
        customNumberFormatter?.minimumFractionDigits = 2
        customNumberFormatter?.maximumFractionDigits = 2
    }
    
    class func initalizeCurrencyFormatter(symbol: String) {
        if customCurrencyormatter == nil {
            customCurrencyormatter = NumberFormatter()
            customCurrencyormatter?.numberStyle = .currency
            let locale = Locale(identifier: LanguageManager.shared.localeCode)
            customCurrencyormatter?.locale = locale
        }
        customCurrencyormatter?.currencySymbol = symbol
    }
    
    public class func localizedFormattedNumberWithoutPlus(aNum: Int) -> String {
        initalizeNumberFormatter()
        let formattedString = customNumberFormatter?.string(for: aNum)
        return formattedString ?? "\(aNum)"
    }
    
    public class func localizedFormattedCurrency(aNum: Float, symbol: String) -> String {
        initalizeCurrencyFormatter(symbol: symbol)
        let formattedString = customCurrencyormatter?.string(for: aNum)
        return formattedString!
    }
    
    public class func localizedFormattedNumberWithPlus(aNum: Int) -> String {
        if customNumberFormatter == nil {
            customNumberFormatter = NumberFormatter()
            let locale = Locale(identifier: LanguageManager.shared.localeCode)
            customNumberFormatter?.locale = locale
            customNumberFormatter?.positiveSuffix = "+"
        }
        let formattedString = customNumberFormatter?.string(for: aNum)
        return formattedString!
    }
    
    class func localizedFormattedEventDate(aDate: Date, formatter: DateFormatter) -> String {
        if eventDateFormatter == nil {
            eventDateFormatter = formatter
            eventDateFormatter?.dateFormat = DateFormates.FullDateEvent
            let locale = Locale(identifier: LanguageManager.shared.localeCode)
            eventDateFormatter?.locale = locale
        }
        let normalString = (eventDateFormatter?.string(from: aDate))!
        let upperCaseString: String? = normalString.uppercased()
        return upperCaseString!
    }
    
    public class func localizedFormattedActivityDate(aDate: Date, formatter: DateFormatter) -> String {
        if activityDateFormatter == nil {
            activityDateFormatter = formatter
            let locale = Locale(identifier: LanguageManager.shared.localeCode)
            activityDateFormatter?.locale = locale
            activityDateFormatter?.dateFormat = DateFormates.HM
        }
        return (activityDateFormatter?.string(from: aDate))!
    }
    
    public class func localizedFormattedTime(aDateTime: Date, formatter: DateFormatter) -> String {
        if timestampFormatter == nil {
            timestampFormatter = formatter
            let locale = Locale(identifier: LanguageManager.shared.localeCode)
            timestampFormatter?.locale = locale
            timestampFormatter?.dateFormat = LanguageManager.shared.isArabic ? DateFormates.FullDateArabic : DateFormates.FullDateEnglish
        }
        return (timestampFormatter?.string(from: aDateTime))!
    }
    
    public class func localizedFormattedDateOnly(aDateTime: Date, formatter: DateFormatter) -> String {
        if timestampFormatter == nil {
            timestampFormatter = formatter
            timestampFormatter?.dateFormat = DateFormates.DMY
            let locale = Locale(identifier: LanguageManager.shared.localeCode)
            timestampFormatter?.locale = locale
        }
        let dateString = timestampFormatter == nil ? "N/A" : timestampFormatter!.string(from: aDateTime)
        return dateString
    }
    
    public class func setLocale() {
        UserDefaults.standard.set([LanguageManager.shared.localeCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    public class func getStringValueFromUserDefaults(key: String) -> String? {
        let defaults: UserDefaults = UserDefaults.standard
        let stringValue = defaults.object(forKey: key) as? String
        return stringValue
    }

    public class func insertStringToUserDefaults(stringValue: String, key: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(stringValue, forKey: key)
        defaults.synchronize()
    }
}
