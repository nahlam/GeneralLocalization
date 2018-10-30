//
//  Int+Localizable.swift
//  Localization
//
//  Created by Nahla Mortada on 5/22/17.
//  Copyright © 2017 Nahla Mortada. All rights reserved.
//

import Foundation

extension Int {
    
    public func localized() -> String {
        return localizedWithoutPlus()
    }
    
    public func localizedWithoutPlus() -> String {
        return LanguageManager.localizedFormattedNumberWithoutPlus(aNum: self)
    }
    
    public func localizedWithPlus() -> String {
        return LanguageManager.localizedFormattedNumberWithPlus(aNum: self)
    }
}
