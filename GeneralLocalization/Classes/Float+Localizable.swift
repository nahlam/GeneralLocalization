//
//  Float+Localizable.swift
//  Localization
//
//  Created by Nahla Mortada on 5/22/17.
//  Copyright © 2017 Nahla Mortada. All rights reserved.
//

import Foundation

extension Float {
    
    public func localizedCurrency(symbol: String) -> String {
        return LanguageManager.localizedFormattedCurrency(aNum: self, symbol: symbol)
    }
    
    public func localized() -> String {
        LanguageManager.initalizeNumberFormatterFloat()
        let formattedString = LanguageManager.customNumberFormatter?.string(for: self)
        return formattedString ?? "\(self)"
    }
    
    public func localizedWithPlus() -> String {
        return "+\(localized())"
    }
}
