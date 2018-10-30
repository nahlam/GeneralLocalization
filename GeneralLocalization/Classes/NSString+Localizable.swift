//
//  NSString.swift
//  Localization
//
//  Created by Nahla Mortada on 5/24/18.
//  Copyright © 2018 Nahla Mortada. All rights reserved.
//

import Foundation

extension NSString {
    
    public static func localized(key: String, localizable: String = LanguageManager.shared.customLocalizationFileName) -> String   {
        return LanguageManager.localizedString(key: key, localizable: localizable)
    }
    
    public static func localized(key: String, languageCode: String, localizable: String = LanguageManager.shared.customLocalizationFileName) -> String   {
        return LanguageManager.localizedString(key: key, languageCode: languageCode, localizable: localizable)
    }
}
