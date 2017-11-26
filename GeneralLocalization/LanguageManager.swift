//
//  LanguageManager.swift
//  4Sale
//
//  Created by Nahla Mortada on 7/20/16.
//  Copyright © 2016 Technivance. All rights reserved.
//

import Foundation

public class LanguageManager: NSObject {
    
    
    struct LocaleIdentifier {
        
        static let Arabic = "ar_EG"
        static let English = "en-US"
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
    
    static var bundle: Bundle? = nil
    static var lang: String? = nil
    static var customNumberFormatter: NumberFormatter? = nil
    static var customCurrencyormatter: NumberFormatter? = nil
    static var eventDateFormatter: DateFormatter? = nil
    static var activityDateFormatter: DateFormatter? = nil
    static var timestampFormatter: DateFormatter? = nil
    
    
    
    internal var customLocalizationFileName: String = ""
    internal var languageUserDefaultsKey: String = "com.nahla.currentLanguage"
    public private(set) var isArabic: Bool = false
    public private(set) var isEnglish: Bool = true
    
    
    public static let shared : LanguageManager = {
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
    
    
    internal func setLanguageVariables()   {
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
        let languageCode:String = LanguageManager.language()
        if languageCode == Constants.LanguageCodeAr {
            return true
        }
        return false
    }
    
    public class func isEnglishLanguage() -> Bool   {
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
            let code:String = LanguageManager.language()
            let path:String? = Bundle.main.path(forResource: code, ofType: Constants.ProjectExtension)
            if path != nil  {
                bundle = Bundle(path: path!)
            }
            
        }
        return bundle!
    }
    
    public class func englishBundle() -> Bundle {
        if bundle == nil {
            let code:String = Constants.LanguageCodeEn
            let path:String = Bundle.main.path(forResource: code, ofType: Constants.ProjectExtension)!
            bundle = Bundle(path: path)
        }
        return bundle!
    }
    
    public class func arabicBundle() -> Bundle {
        if bundle == nil {
            let code:String = Constants.LanguageCodeAr
            let path:String = Bundle.main.path(forResource: code, ofType: Constants.ProjectExtension)!
            bundle = Bundle(path: path)
        }
        return bundle!
    }
    
    
    
    // MARK: - App Language Management
    
    public class func setApplicationLanguage(language: String) {
        
        LanguageManager.insertStringToUserDefaults(stringValue: language, key: LanguageManager.shared.languageUserDefaultsKey)
        bundle = nil
        lang = language
        customNumberFormatter = nil
        customCurrencyormatter = nil
        eventDateFormatter = nil
        activityDateFormatter = nil
        timestampFormatter = nil
        bundle = localizedBundle()
        if (language == "ar") {
            let notificationObject: [String: Any] = [Constants.LanguageCode : Constants.LanguageCodeAr, Constants.LanguageEnglishName: Constants.LanguageNameAr, Constants.LanguageisArabic : true]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.LanguageChanged), object: notificationObject)
        }else {
            let notificationObject: [String: Any] = [Constants.LanguageCode : Constants.LanguageCodeEn, Constants.LanguageEnglishName: Constants.LanguageNameEn, Constants.LanguageisArabic : false]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.LanguageChanged), object: notificationObject)
        }
    }
    
    
    
    class func localizedString(key: String, localizable: String = LanguageManager.shared.customLocalizationFileName) -> String {
        let localizedBundle:Bundle? = LanguageManager.localizedBundle()
        let generalLocalizable = Constants.LocalizationFileName
        if let value = localizedBundle?.localizedString(forKey: key, value: nil, table: generalLocalizable) , value != key {
            return value
        }
        
        if localizable.isEmpty {
            fatalError("customLocalizationFileName cannot be empty you should either add the key in the general \"Localizable\" file name or add custom localization file name to your target and pass it's name to the initalization method")
        }
        
        return localizedBundle?.localizedString(forKey: key, value: nil, table: localizable) ?? Constants.Empty
    }
    
    class func localizedString(key: String, languageCode: String, localizable: String = LanguageManager.shared.customLocalizationFileName) -> String {
        let path: String = Bundle.main.path(forResource: languageCode, ofType: Constants.ProjectExtension)!
        let localizedBundle: Bundle? = Bundle(path: path)!
        let generalLocalizable = Constants.LocalizationFileName
        if let value = localizedBundle?.localizedString(forKey: key, value: nil, table: generalLocalizable) , value != key  {
            return value
        }
        
        if localizable.isEmpty {
            fatalError("customLocalizationFileName cannot be empty you should either add the key in the general \"Localizable\" file name or add custom localization file name to your target and pass it's name to the initalization method")
        }
        
        return localizedBundle?.localizedString(forKey: key, value: nil, table: localizable) ?? Constants.Empty
    }
    
    
    
    // MARK: - Formating
    
    class func localizedFormattedNumberWithoutPlus(aNum: Int) -> String {
        if customNumberFormatter == nil {
            customNumberFormatter = NumberFormatter()
            if LanguageManager.shared.isArabic {
                customNumberFormatter?.locale = Locale(identifier: LocaleIdentifier.Arabic)
            }
            else {
                customNumberFormatter?.locale = Locale(identifier: LocaleIdentifier.English)
            }
        }

        
        
        let formattedString:String? = customNumberFormatter?.string(for: aNum)
        return formattedString!
    }
    
    class func localizedFormattedCurrency(aNum: Float, symbol: String) -> String {
        if customCurrencyormatter == nil {
            customCurrencyormatter = NumberFormatter()
            customCurrencyormatter?.numberStyle = .currency
            customCurrencyormatter?.currencySymbol = symbol
            if LanguageManager.shared.isArabic {
                customCurrencyormatter?.locale = Locale(identifier: LocaleIdentifier.Arabic)
            }
            else {
                customCurrencyormatter?.locale = Locale(identifier: LocaleIdentifier.English)
            }
        }
        let formattedString:String? = customCurrencyormatter?.string(for: aNum)
        return formattedString!
    }
    
    class func localizedFormattedNumberWithPlus(aNum: Int) -> String {
        if customNumberFormatter == nil {
            customNumberFormatter = NumberFormatter()
            if LanguageManager.shared.isArabic {
                customNumberFormatter?.locale = Locale(identifier: LocaleIdentifier.Arabic)
                customNumberFormatter?.positiveSuffix = "+";
            }
            else {
                customNumberFormatter?.locale = Locale(identifier: LocaleIdentifier.English)
                customNumberFormatter?.positiveSuffix = "+";
            }
        }
        let formattedString:String? = customNumberFormatter?.string(for: aNum)
        return formattedString!
    }
    
    class func localizedFormattedEventDate(aDate: Date, formatter: DateFormatter) -> String {
        if eventDateFormatter == nil {
            eventDateFormatter = formatter
            eventDateFormatter?.dateFormat = DateFormates.FullDateEvent
            let identifier:String = LanguageManager.shared.isArabic ? LocaleIdentifier.Arabic : LocaleIdentifier.English
            eventDateFormatter?.locale = Locale(identifier: identifier)
        }
        let normalString:String = (eventDateFormatter?.string(from: aDate))!
        let upperCaseString:String? = normalString.uppercased()
        return upperCaseString!
    }
    
    class func localizedFormattedActivityDate(aDate: Date, formatter: DateFormatter) -> String {
        if activityDateFormatter == nil {
            activityDateFormatter = formatter
            var locale: Locale? = nil
            if LanguageManager.shared.isArabic {
                locale =  Locale(identifier: LocaleIdentifier.Arabic)
            }
            else {
                locale =  Locale(identifier: LocaleIdentifier.English)
            }
            activityDateFormatter?.locale = locale!
            activityDateFormatter?.dateFormat = DateFormates.HM
        }
        return (activityDateFormatter?.string(from: aDate))!
    }
    
    class func localizedFormattedTime(aDateTime: Date, formatter: DateFormatter) -> String {
        if timestampFormatter == nil {
            timestampFormatter = formatter
            if LanguageManager.shared.isArabic {
                timestampFormatter?.locale = Locale(identifier: LocaleIdentifier.Arabic)
                timestampFormatter?.dateFormat = DateFormates.FullDateArabic
            }
            else {
                timestampFormatter?.locale = Locale(identifier: LocaleIdentifier.English)
                timestampFormatter?.dateFormat = DateFormates.FullDateEnglish
            }
        }
        return (timestampFormatter?.string(from: aDateTime))!
    }
    
    class func localizedFormattedDateOnly(aDateTime: Date, formatter: DateFormatter) -> String {
        if timestampFormatter == nil {
            timestampFormatter = formatter
            timestampFormatter?.dateFormat = DateFormates.DMY
            if LanguageManager.shared.isArabic {
                timestampFormatter?.locale = Locale(identifier: LocaleIdentifier.Arabic)
            }
            else {
                timestampFormatter?.locale = Locale(identifier: LocaleIdentifier.English)
                
            }
        }
        let dateString = timestampFormatter == nil ? "N/A" : timestampFormatter!.string(from: aDateTime)
        return dateString
    }
    
    
    class func getStringValueFromUserDefaults(key: String) -> String? {
        let defaults: UserDefaults = UserDefaults.standard
        let stringValue:String? = defaults.object(forKey: key) as? String
        return stringValue
    }

    class func insertStringToUserDefaults(stringValue: String, key: String) {
        let defaults: UserDefaults = UserDefaults.standard
        defaults.set(stringValue, forKey: key)
        defaults.synchronize()
    }
    
}
