//
//  Date+Extensions.swift
//  ZanPro
//
//  Created by Vladimir on 09.06.2023.
//

import Foundation

extension Date {
    static func dateFromISOString(_ isoString: String) -> Date? {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate]  // ignores time!
        return isoDateFormatter.date(from: isoString)  // returns nil, if isoString is malformed.
    }
    
    static func stringFromISODate(_ date: Date) -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate]  // ignores time!
        return isoDateFormatter.string(from: date)
    }
}
