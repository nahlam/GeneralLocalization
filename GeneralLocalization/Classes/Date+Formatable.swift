//
//  Date+Localizable.swift
//  Localization
//
//  Created by Nahla Mortada on 5/22/17.
//  Copyright © 2017 Nahla Mortada. All rights reserved.
//

import Foundation

extension Date {
    
    public func formattedEventDate(formatter: DateFormatter) -> String {
        return LanguageManager.localizedFormattedEventDate(aDate: self, formatter: formatter)
    }
    
    public func formattedActivityDate(formatter: DateFormatter) -> String {
        return LanguageManager.localizedFormattedActivityDate(aDate: self, formatter: formatter)
    }
    
    public func formattedTime(formatter: DateFormatter) -> String {
        return LanguageManager.localizedFormattedTime(aDateTime: self, formatter: formatter)
    }
    
    public func formattedDateOnly(formatter: DateFormatter) -> String {
        return LanguageManager.localizedFormattedDateOnly(aDateTime: self, formatter: formatter)
    }
}
