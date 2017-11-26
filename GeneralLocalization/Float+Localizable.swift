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
}
