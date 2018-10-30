//
//  String+Localizable.swift
//  Localization
//
//  Created by Nahla Mortada on 5/22/17.
//  Copyright © 2017 Nahla Mortada. All rights reserved.
//

import Foundation

extension String {
    
    public static func localized(key: String, localizable: String = LanguageManager.shared.customLocalizationFileName) -> String {
        return LanguageManager.localizedString(key: key, localizable: localizable)
    }
    
    public static func localized(key: String, languageCode: String, localizable: String = LanguageManager.shared.customLocalizationFileName) -> String {
        return LanguageManager.localizedString(key: key, languageCode: languageCode, localizable: localizable)
    }
}
